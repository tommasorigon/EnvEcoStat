# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises C
# Calibration of a CO2 sensor
# ----------------------------------------------------------------------

rm(list = ls())

y <- c(100.8, 99.7, 100.2, 101.0, 99.8, 100.3, 100.9, 100.1, 100.8)

# 1 --------------------------------------------------------------------
# H0: mu = 100 against Ha: mu != 100, where mu is the mean of the measurements

# 2 --------------------------------------------------------------------
n <- length(y)
c(mean(y), sd(y))
t_obs <- (mean(y) - 100) / (sd(y) / sqrt(n)) # Observed test statistic
t_obs
qt(0.975, df = n - 1) # Critical value, alpha = 0.05: H0 is rejected
qt(0.995, df = n - 1) # Critical value, alpha = 0.01: H0 is not rejected

# 3 --------------------------------------------------------------------
2 * (1 - pt(abs(t_obs), df = n - 1)) # Between 0.01 and 0.05

# 4 --------------------------------------------------------------------
t.test(y, mu = 100) # Same t and P-value; the 95% interval does not contain 100
t.test(y, mu = 100, conf.level = 0.99) # The 99% interval contains 100
# The two-sided test with level alpha rejects H0 exactly when the
# 100(1 - alpha)% confidence interval does not contain 100
