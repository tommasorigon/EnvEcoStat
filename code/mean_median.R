# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises C
# Exercise A
# ----------------------------------------------------------------------

rm(list = ls())

mu <- 28
sigma <- 12
k <- mu^2 / sigma^2 # Shape
lambda <- mu / sigma^2 # Rate

# 1 --------------------------------------------------------------------
set.seed(123)
n <- 20
R <- 1000
y_bar <- rep(NA, R)
y_med <- rep(NA, R)

for (r in 1:R) {
  y <- rgamma(n, shape = k, rate = lambda)
  y_bar[r] <- mean(y) # Sample mean
  y_med[r] <- median(y) # Sample median
}

# 2 --------------------------------------------------------------------
boxplot(y_bar, y_med, names = c("Mean", "Median"))
abline(h = mu, col = "red")

# 3 --------------------------------------------------------------------
mean(y_bar) - mu # Bias of the sample mean, close to 0
mean(y_med) - mu # Bias of the sample median, negative

mean((y_bar - mu)^2) # MSE of the sample mean
mean((y_med - mu)^2) # MSE of the sample median, larger

# The sample mean is preferable

# 4 --------------------------------------------------------------------
# The sample median estimates the median of the population, which is
# smaller than mu because the gamma distribution is asymmetric
qgamma(0.5, shape = k, rate = lambda)
mean(y_med)

# 5 --------------------------------------------------------------------
set.seed(123)
y_bar_norm <- rep(NA, R)
y_med_norm <- rep(NA, R)

for (r in 1:R) {
  y <- rnorm(n, mean = mu, sd = sigma)
  y_bar_norm[r] <- mean(y)
  y_med_norm[r] <- median(y)
}

mean(y_bar_norm) - mu # Both biases are close to 0
mean(y_med_norm) - mu

mean((y_bar_norm - mu)^2) # The sample mean has a smaller MSE
mean((y_med_norm - mu)^2)

sd(y_med_norm) # Simulated standard error of the median
1.25 * sigma / sqrt(n) # Approximate theoretical value
