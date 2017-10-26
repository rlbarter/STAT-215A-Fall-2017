library(dplyr)
library(ggplot2)

# Get the data for three images
path <- "data"
image1 <- read.table(paste0('data/', 'image1.txt'), header = F)
image2 <- read.table(paste0('data/', 'image2.txt'), header = F)
image3 <- read.table(paste0('data/', 'image3.txt'), header = F)

# Add informative column names.
collabs <- c('y','x','label','NDAI','SD','CORR','DF','CF','BF','AF','AN')
names(image1) <- collabs
names(image2) <- collabs
names(image3) <- collabs

# take a peek at the data from image1
head(image1)
summary(image1)

# The raw image (red band, from nadir).
ggplot(image1) + geom_point(aes(x = x, y = y, color = AN))

# Plot the expert pixel-level classification
ggplot(image1) + geom_point(aes(x = x, y = y, color = factor(label))) +
  scale_color_discrete(name = "Expert label")

# Class conditional densities.
ggplot(image1) + 
  geom_density(aes(x = AN, group = factor(label), fill = factor(label)), 
               alpha = 0.5) +
  scale_fill_discrete(name = "Expert label")


