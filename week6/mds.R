# source: http://www.analytictech.com/borgatti/mds.htm

# MDS for US cities example

D <- read.csv("us_cities_distance.csv")
D <- D[, -1]

n <- nrow(D)


# define centering matrix J
I <- diag(1, n)
one <- matrix(1, nrow = n, ncol = n)
J <- I - (1 / n) * one %*% t(one)


# Apply double centering
B <- -(1 / 2) * (J %*% D^2 %*% J)

# check double centering
apply(B, 1, mean)
apply(B, 2, mean)

# obtain eigendecomposition of B
eigen_B <- eigen(B)
E <- eigen_B$vectors[, 1:2]
Lambda <- diag(eigen_B$values[1:2])


# define projected X
X <- E %*% sqrt(Lambda)
colnames(X) <- c("x", "y")
X <- data.frame(X, city = colnames(D))

library(ggplot2)
# plot the positions of the cities
ggplot(X) + 
  geom_text(aes(x = -x, y = y, label = city), size = 8) +
  theme_classic() +
  scale_x_continuous(limits = c(min(X[, 1]) - 1000, max(X[, 1]) + 1000))
