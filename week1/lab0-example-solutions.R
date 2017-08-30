# example code for lab0

# Note that in a real lab you will be expected to write a full 
# publication-quality report. This pretend lab simply was purposed to 
# give you an idea about how to use R to load in data, create visualizations 
# and get a taste of the tidyverse.

library(ggplot2)
data(USArrests)
# convert rownames to a column
arrests <- USArrests %>% 
  mutate(state = rownames(USArrests)) %>%
  # convert all variable names to lowercase words separated by _
  select(state = state, murder = Murder, assault = Assault, 
         urban_pop = UrbanPop, rape = Rape)

# read in state coordinates data
state_coordinates <- read.table("data/stateCoord.txt")
# convert rownames to state
state_coordinates <- state_coordinates %>% 
  mutate(state = rownames(state_coordinates),
         # remove hyphens from state names
         state = gsub("-", " ", state))

# check to see which state names don't match
arrests$state[!(arrests$state %in% state_coordinates$state)]

# merge the datasets together (could also use a _join() function)
arrests <- left_join(arrests, state_coordinates, by = "state")
if (nrow(arrests) != nrow(USArrests)) {
  stop("The merge between the arrests and state locations failed.")
}


# There is a positive correlation between murder and assault rates.
ggplot(arrests) + geom_point(aes(x = murder, y = assault), size=4)


# There is an outlier in the relationship between urban population and
# rate of rape. Identify the outlier
arrests <- arrests %>% 
  mutate(outlier = if_else(rape > 0.75 * urban_pop, "Outlier", "Normal"))
# plot the data with the outlier colored
ggplot(arrests) +
  geom_point(aes(x = urban_pop, y = rape, color = outlier),
             size = 4)



# What is that outlier?  It is Alaska, those jerks.
ggplot(arrests) +
  geom_text(aes(x = urban_pop, y = rape, label = state,
                color = outlier))


# Run regressions of rate of rape on urban population.
regression <- lm(rape ~ urban_pop, arrests)
regression_df <- data.frame(fitted = regression$fitted.values, 
                            residuals = regression$residuals)
# The variance of the residuals increases with the prediction.  This is
# probably due to the response being constrained to be positive.  See
# below.
ggplot(regression_df) +
  geom_point(aes(x = fitted, y = residuals)) +
  geom_hline(yintercept = 0) +
  xlab("Fitted") + ylab("Residuals")

# The raw data with the fitted line.
ggplot(arrests) +
  geom_point(aes(x = urban_pop, y = rape, color = outlier),
             size = 4) +
  geom_abline(aes(intercept = regression$coefficients[1], 
                  slope = regression$coefficients[2]),
              color="blue")

# Run the regression with no outlier.
arrests_trim <- arrests %>% filter(outlier == "Normal")
trim_regression <- lm(rape ~ urban_pop, data = arrests_trim)
trim_regression_df <- data.frame(fitted = trim_regression$fitted.values, 
                                 residuals = trim_regression$residuals)

# The raw data with both fitted lines, with and without the outlier.
# I'll put the pretty title and legend for (6) in here.
ggplot(arrests) +
  geom_point(aes(x = urban_pop, y = rape, color = outlier), size = 4) +
  geom_abline(aes(intercept = regression$coefficients[1], 
                  slope = regression$coefficients[2],
                  color = "With Alaska (outlier)"), lwd = 2) +
  geom_abline(aes(intercept = trim_regression$coefficients[1], 
                  slope = trim_regression$coefficients[2],
                  color = "Without Alaska (outlier)"), lwd = 2) +
  ggtitle(paste("Linear fit to Rape / 100k people vs Urban Population %",
                "with and without Alaska (an outlier)", sep="\n")) +
  xlab("Urban Population %") + ylab("Rape per 100k") +
  scale_color_manual(name = "Color meanings", 
                     values = c("Normal" = "grey20", 
                                "Outlier" = "orange",
                                "With Alaska (outlier)" = "cornflowerblue",
                                "Without Alaska (outlier)" = "red"))

# The fit does not look great, especially the heteroskedasticity.
# The increase in the residuals' variance as a function of the fitted value
# could be because the response is constrained to be positive.
log_regression <- lm(log(rape) ~ log(urban_pop), data = arrests_trim)
log_regression_df <- data.frame(fitted = log_regression$fitted.values, 
                                residuals = log_regression$residuals)
# Note that there is less heteroskedasticity in log space and the fit looks better.
ggplot(log_regression_df) +
  geom_point(aes(x = fitted, y = residuals)) +
  geom_hline(yintercept = 0) +
  xlab("Fitted") + ylab("Residuals of the log regression")

# The raw data with the fitted line from the log regression.  Note that if
# Alaska is an outlier on the log scale, then Rhode Island is, too.
ggplot(arrests) +
  geom_text(aes(x = log(urban_pop), y = log(rape), 
                color = outlier, label = state),
            size = 4) +
  geom_abline(aes(intercept = log_regression$coefficients[1], 
                  slope = log_regression$coefficients[2]),
              color="blue") +
  ggtitle("Linear fit to log(Rape) / 100k people vs log(Urban Population %)") +
  xlab("log(Urban Population %)") + ylab("log(Rapes per 100k people)")

# However, the R2 doesn't increase very much.
var(trim_regression_df$fitted) / (var(trim_regression_df$fitted) + var(trim_regression_df$residuals))
var(log_regression_df$fitted) / (var(log_regression_df$fitted) + var(log_regression_df$residuals))

