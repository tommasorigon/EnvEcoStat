# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises C
# Solar panels
# ----------------------------------------------------------------------

rm(list = ls())

n <- 144
y_bar <- 17.60
s <- 2.40

# 1 --------------------------------------------------------------------
# H0: mu = 18 against Ha: mu < 18 (the claim of the company is H0)
t_obs <- (y_bar - 18) / (s / sqrt(n)) # Observed test statistic
t_obs
qt(0.01, df = n - 1) # Critical value, alpha = 0.01: H0 is not rejected
pt(t_obs, df = n - 1) # One-sided P-value, the left tail only

# 2 --------------------------------------------------------------------
qt(0.05, df = n - 1) # Critical value, alpha = 0.05: H0 is rejected
# The P-value is between 0.01 and 0.05: the decision depends on alpha
