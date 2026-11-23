# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises D
# UN dataset (adapted from AK 6.12)
# ----------------------------------------------------------------------

rm(list = ls())

path <- "https://stat4ds.rwth-aachen.de/data/UN.dat"
UN <- read.table(path, header = TRUE)

# 1 --------------------------------------------------------------------
fit_gdp <- lm(CO2 ~ GDP, data = UN)
summary(fit_gdp) # The effect of GDP is clearly significant

# 2 --------------------------------------------------------------------
fit_both <- lm(CO2 ~ GDP + Internet, data = UN)
summary(fit_both)
# Neither P-value is smaller than 0.05, but the F test (last line) strongly
# rejects H0: beta_1 = beta_2 = 0

# 3 --------------------------------------------------------------------
cor(UN$GDP, UN$Internet) # Very strong correlation
# GDP and Internet carry almost the same information: once one of the two is
# in the model, the other one adds very little. Each t test asks whether a
# variable is useful given the other one, and the answer is "not much"

# 4 --------------------------------------------------------------------
# Multiple R-squared: 0.455 with GDP only, 0.465 with both variables.
# Adding Internet improves the fit very little
