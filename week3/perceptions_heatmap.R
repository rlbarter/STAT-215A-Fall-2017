# Heatmap on probability perception data
# author: Rebecca Barter
# date: 09/05/2017


library(tidyverse)

# load in the data
perceptions <- read.csv("perceptions/probly.csv")

# remove periods in column names
colnames(perceptions) <- gsub("\\.", " ", colnames(perceptions))



###############################################################################
################################ Superheat ####################################
###############################################################################

# load superheat package

# devtools::install_github("rlbarter/superheat")
library(superheat)

# calcualte the density for each column
density_matrix <- perceptions %>% 
  # map_df (from the purr package) is like apply()
  map_df(function(x) { 
    # calculate the density for each column with endpoints (0, 100)
    density <- density(x, from = 0, to = 100)$y
  })


# plot the superheatmap
superheat(t(density_matrix),
          # specify top plot
          yt = apply(density_matrix, 1, mean),
          yt.plot.type = "line",
          yt.axis.name = "average density",
          # specify right plot
          yr = apply(perceptions, 2, mean),
          yr.plot.type = "bar",
          yr.axis.name = "average probability",
          yr.lim = c(0, 100),
          # other aesthetics
          column.title = "Assigned probability",
          grid.hline.col = "white",
          left.label.text.alignment = "right")

# zoom (open plot in sepearate window) to view properly

###############################################################################
################################# ggplot ######################################
###############################################################################



library(forcats)
library(viridis)


# obtain the density for each statement using the map_df function 
# from the purr package
# note that to create heatmaps using ggplot2 they need to be in longform dfs
density_df <- perceptions %>% 
  map_df(function(x) {
    # calculate the density for each column with endpoints (0, 100)
    density <- density(x, from = 0, to = 100)
    # extract the x coordinate and y coordinate (height of density curve)
    data.frame(x = density$x, density = density$y)
    },
    # add an id column and call it "statement"
    .id = "statement") 


# arrange the statements in increasing order of probability
density_df <- density_df %>%
  # calcualte the average probability for each statement
  group_by(statement) %>%
  mutate(mean = mean(x * density)) %>%
  ungroup() %>%
  # arrange in order of average probability
  arrange(mean) %>%
  # reorder the factor levels
  mutate(statement = fct_inorder(statement))

# plot a heatmap of the density
density_df %>%
  ggplot() + 
  geom_tile(aes(x = x, y = statement, fill = density)) +
  # add some custom gridlines
  geom_hline(yintercept = 1:17 - 0.5, col = "white") +
  geom_vline(xintercept = c(25, 50, 75, 100), col = "white", size = 0.2) +
  # change the scale to viridis and change the transition points
  scale_fill_viridis(values = c(0, 0.005, 0.01, 0.07, 0.1, 1)) +
  # remove all unnecessary ggplot studd
  theme_classic() +
  theme(axis.line = element_blank(),
        axis.ticks.y = element_blank(),
        # move the y-axis labels closer to the heatmap
        axis.text.y = element_text(margin = margin(t = 0, b = 0, r = -15, l = 5)),
        # change the font and size of text
        axis.text = element_text(size = 12),
        axis.title = element_text(size = 16),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  xlab("Assigned probability") +
  ylab("")

