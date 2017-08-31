
cleanGapminderData <- function(gapminder_data) {
  # the following is a bit unnecessary, but I'm going to it anyway 
  
  # rename the columns of the dataset to suit my consistent code format
  gapminder_data <- gapminder_data %>% 
    rename(life_exp = lifeExp,
           gdp_per_cap = gdpPercap,
           population = pop)
  
  return(gapminder_data)
}
