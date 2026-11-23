# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises C
# Defective chips
# ----------------------------------------------------------------------

rm(list = ls())

n <- 500
pi_0 <- 0.04 # Proportion of defective chips claimed by the supplier

# 1 --------------------------------------------------------------------
pi_0 # Mean of the sample proportion
sqrt(pi_0 * (1 - pi_0) / n) # Standard error

# 2 --------------------------------------------------------------------
c(n * pi_0, n * (1 - pi_0)) # Both larger than 10: the normal approximation is reasonable

# 3 --------------------------------------------------------------------
set.seed(123)
R <- 5000
pi_hat <- rbinom(R, size = n, prob = pi_0) / n # R simulated samples
mean(pi_hat > 0.05) # Simulation

1 - pnorm(0.05, mean = pi_0, sd = sqrt(pi_0 * (1 - pi_0) / n)) # Central limit theorem
1 - pbinom(0.05 * n, size = n, prob = pi_0) # Exact: more than 25 defective chips
# The normal distribution only approximates the distribution of the sample
# proportion, which is discrete: the approximation is rough when n * pi_0 = 20
