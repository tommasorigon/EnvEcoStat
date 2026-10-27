## -----------------------------------------------------------------------------
524 / 1008 # Sample proportion

## -----------------------------------------------------------------------------
set.seed(123)
R <- 5000 # Number of simulated surveys
pi_hat <- rbinom(R, size = 1008, prob = 0.5) / 1008 # R sample proportions
head(pi_hat)

## -----------------------------------------------------------------------------
hist(pi_hat, breaks = 30, main = "Sample proportions (n = 1008)", xlab = "Sample proportion")
abline(v = 0.52, col = "red") # Observed sample proportion

## -----------------------------------------------------------------------------
mean(pi_hat >= 0.52) # The mean of TRUE / FALSE values is a proportion

## -----------------------------------------------------------------------------
mean(pi_hat) # Simulated
sd(pi_hat) # Simulated
sqrt(0.5 * 0.5 / 1008) # Theoretical standard error

## -----------------------------------------------------------------------------
sqrt(0.5 * 0.5 / 10000)

## -----------------------------------------------------------------------------
mu <- 28
sigma <- 12
k <- mu^2 / sigma^2 # Shape, so that the mean is mu
lambda <- mu / sigma^2 # Rate, so that the standard deviation is sigma
curve(dgamma(x, shape = k, rate = lambda), from = 0, to = 100, xlab = "PM2.5", ylab = "f(y)")

## -----------------------------------------------------------------------------
set.seed(123)
n <- 64
mean(rgamma(n, shape = k, rate = lambda))
mean(rgamma(n, shape = k, rate = lambda))
mean(rgamma(n, shape = k, rate = lambda))

## -----------------------------------------------------------------------------
y_bar <- rep(NA, R) # Empty vector, to be filled with the R sample means

for (r in 1:R) {
  y <- rgamma(n, shape = k, rate = lambda) # A new campaign of n days
  y_bar[r] <- mean(y) # Its sample mean is stored in position r
}

## -----------------------------------------------------------------------------
mean(y_bar) # Simulated
sd(y_bar) # Simulated
sigma / sqrt(n) # Theoretical standard error

## -----------------------------------------------------------------------------
hist(y_bar, breaks = 30, freq = FALSE, main = "Sample means (n = 64)", xlab = "Sample mean")
curve(dnorm(x, mean = mu, sd = sigma / sqrt(n)), add = TRUE, col = "red")

## -----------------------------------------------------------------------------
1 - pnorm(31, mean = mu, sd = sigma / sqrt(n)) # Central limit theorem
mean(y_bar > 31) # Simulation

## -----------------------------------------------------------------------------
my_var <- function(x) mean(x^2) - mean(x)^2 # From Unit F: divides by n

set.seed(123)
n <- 5
R <- 10000
sigma2_hat <- rep(NA, R)
S2 <- rep(NA, R)

for (r in 1:R) {
  y <- rgamma(n, shape = k, rate = lambda)
  sigma2_hat[r] <- my_var(y)
  S2[r] <- var(y)
}

c(mean(sigma2_hat), mean(S2), sigma^2)

## -----------------------------------------------------------------------------
mean((sigma2_hat - sigma^2)^2) # MSE of the biased estimator
mean((S2 - sigma^2)^2) # MSE of the unbiased estimator
