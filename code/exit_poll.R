# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises C
# Exit poll in Arizona (AK 3.2)
# ----------------------------------------------------------------------

rm(list = ls())

n <- 1648
pi_hat_obs <- 0.515 # Observed sample proportion

# 1 --------------------------------------------------------------------
sqrt(0.5 * 0.5 / n) # Standard error under pi = 0.5

# 2 --------------------------------------------------------------------
set.seed(123)
R <- 5000
pi_hat <- rbinom(R, size = n, prob = 0.5) / n # R simulated exit polls
hist(pi_hat, breaks = 30)
abline(v = pi_hat_obs, col = "red")
sd(pi_hat) # Close to the theoretical standard error

# 3 --------------------------------------------------------------------
mean(pi_hat >= pi_hat_obs) # Simulation
1 - pnorm(pi_hat_obs, mean = 0.5, sd = sqrt(0.5 * 0.5 / n)) # Central limit theorem
# About 1 exit poll out of 10 gives 51.5% or more even if pi = 0.5: the result
# is not surprising, and we would not be confident in predicting the winner
