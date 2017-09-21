library(maps)
library(ggplot2)
library(dplyr)

# load the data
ling_data <- read.table('data/lingData.txt', header = T)
ling_location <- read.table('data/lingLocation.txt', header = T)
# question_data contains three objects: quest.mat, quest.use, all.ans
load("data/question_data.RData")

# ling_data has a column for each question, and ling_location has a column
# for each question x answer.  Sorry the columns in ling_location are not usefully named,
# but it's not too tricky to figure out which is which.
# Note that you still need to clean this data (check for NA's, missing location data, etc.)
names(ling_data)
names(ling_location)
state_df <- map_data("state")

blank_theme <- theme_bw() +
  theme(plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank()) 

############
# Make a plot for the second person plural answers.
# You may want to join these data sets more efficiently than this.
plural_second_person <- ling_data %>% 
  filter(Q050 %in% c(1, 2, 9), long > -125)
# extract the answers to question 50
answers_q50 <- all.ans[['50']]

# Make the column to join on.  They must be the same type.
answers_q50$Q050 <- rownames(answers_q50)
plural_second_person$Q050 <- as.character(plural_second_person$Q050)
plural_second_person <- inner_join(plural_second_person, answers_q50, by = "Q050")

# Plot!
ggplot(plural_second_person) +
  geom_point(aes(x = long, y = lat, color = ans), 
             size = 3, alpha = 0.5) +
  geom_polygon(aes(x = long, y = lat, group = group),
               data = state_df, colour = "black", fill = NA) +
  blank_theme



###############
# Plot the ling_location data (which lives on a grid).  
# Note that this doesn't look great with
# state outlines. You can probably do better!
ling_location %>%
  filter(Longitude > -125) %>%
  ggplot() +
  geom_tile(aes(x = Longitude, y = Latitude, 
                color = log10(V12), fill = log10(V12))) +
  geom_polygon(aes(x = long, y = lat, group = group),
               data = state_df, colour = "gray", fill = NA) +
  blank_theme
