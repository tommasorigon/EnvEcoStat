# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises B
# UN dataset (AK 1.24)
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/UN.dat"
UN <- read.table(path, header = TRUE)

summary(UN$Prison) # Median 119.5, mean 153.9: the distribution is skewed
sd(UN$Prison) # 124.3
boxplot(UN$Prison)
UN$Nation[order(UN$Prison, decreasing = TRUE)][1:3]
# The United States (716) are far above every other nation, Russia is second

# 2 --------------------------------------------------------------------
round(cor(UN[, -1]), 2) # The first column contains the names of the nations
# The strongest association is between GDP and HDI (0.90), which is no
# surprise, since the income per capita is one of the components of the HDI

# 3 --------------------------------------------------------------------
plot(UN$GDP, UN$CO2)
cor(UN$GDP, UN$CO2) # 0.674

fit <- lm(CO2 ~ GDP, data = UN)
coef(fit) # Intercept 1.926, slope 0.1778
abline(fit)

predict(fit, newdata = data.frame(GDP = range(UN$GDP))) # From 2.71 to 13.11

# 4 --------------------------------------------------------------------
cor(UN$GDP, UN$Prison) # -0.003
plot(UN$GDP, UN$Prison) # The United States are an extreme observation

UN_no_US <- subset(UN, Nation != "US")
cor(UN_no_US$GDP, UN_no_US$Prison) # -0.27
# A correlation close to zero does not mean that there is no relationship: here
# it is the result of a single, very influential observation
