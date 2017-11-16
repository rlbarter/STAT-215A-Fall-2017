# This file loads and looks at some of the data sets for the
# STAT215A Fall 2015 final project.
library(corrplot)
library(tidyverse)
source('utils.R')

# Load the data.
load("data/fMRIdata.RData")
ls()

# Read in a raw image.
img1 <- ReadImage(1)
image(img1, col = gray((1:500) / 501))

# Load in a raw basis function (function may not work for windows users).
wav1 <- ReadRealBasisFunction(150)
image(wav1)

# Take a look at the distribution of responses.
resp_dat <- data.frame(resp_dat)
names(resp_dat) <- paste("voxel", 1:ncol(resp_dat), sep = "")
# elongate the data
resp_long <- gather(resp_dat, key = "voxel", value = "response")
# view distribution using ridge plot
library(ggridges)
ggplot(resp_long) +
  geom_density_ridges(aes(x = response, y = voxel, group = voxel)) 
# look at correlation plot
corrplot(cor(resp_dat))

# Look at the first image's feature distribution.
fit_feat <- data.frame(fit_feat)
qplot(x = as.numeric(fit_feat[1, ]), 
      geom = "density", xlab = "Gabor features for image 1")


