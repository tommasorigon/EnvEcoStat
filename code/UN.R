# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises B
# UN dataset (AK 1.24)
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/UN.dat"
UN <- read.table(path, header = TRUE)

summary(UN$Prison) # The mean is much larger than the median: skewed distribution
sd(UN$Prison) # 124.3
boxplot(UN$Prison) # One very large value
UN[which.max(UN$Prison), ] # The United States, far above every other nation

# 2 --------------------------------------------------------------------
round(cor(UN[, -1]), 2) # The first column contains the names of the nations
# The strongest association is between GDP and HDI (0.90), which is no
# surprise, since the income per capita is one of the components of the HDI

# 3 --------------------------------------------------------------------
plot(UN$GDP, UN$CO2)
cor(UN$GDP, UN$CO2) # 0.674

my_var <- function(x) mean(x^2) - mean(x)^2
my_cov <- function(x, y) mean(x * y) - mean(x) * mean(y)

beta_hat <- my_cov(UN$GDP, UN$CO2) / my_var(UN$GDP)
alpha_hat <- mean(UN$CO2) - beta_hat * mean(UN$GDP)
c(alpha_hat, beta_hat) # Intercept 1.926, slope 0.1778
abline(a = alpha_hat, b = beta_hat)

alpha_hat + beta_hat * range(UN$GDP) # From 2.71 to 13.11 metric tons

# 4 --------------------------------------------------------------------
cor(UN$GDP, UN$Prison) # -0.003, essentially zero
plot(UN$GDP, UN$Prison) # The United States are an extreme observation

UN_no_US <- subset(UN, Nation != "US")
cor(UN_no_US$GDP, UN_no_US$Prison) # -0.27
# A correlation close to zero does not mean that there is no relationship: here
# it is the result of a single, very influential observation
