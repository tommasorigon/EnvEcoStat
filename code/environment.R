# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises C
# Laws to protect the environment
# ----------------------------------------------------------------------

rm(list = ls())

n <- 1353
pi_hat <- 1223 / n

# 1 --------------------------------------------------------------------
c(n * pi_hat, n * (1 - pi_hat)) # Both larger than 10

# 2 --------------------------------------------------------------------
se_hat <- sqrt(pi_hat * (1 - pi_hat) / n) # Estimated standard error
c(pi_hat - qnorm(0.975) * se_hat, pi_hat + qnorm(0.975) * se_hat)
# Between about 89% and 92% of the population is in favour

# 3 --------------------------------------------------------------------
# H0: pi = 0.5 against Ha: pi > 0.5
z <- (pi_hat - 0.5) / sqrt(0.5 * 0.5 / n) # Observed test statistic
z
1 - pnorm(z) # One-sided P-value, practically zero: a clear majority
