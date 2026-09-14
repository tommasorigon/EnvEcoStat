## -----------------------------------------------------------------------------
forbes <- read.table("data/forbes.csv", header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
#| eval: false
# path <- "https://tommasorigon.github.io/EnvEcoStat/data/forbes.csv"
# forbes <- read.table(path, header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
str(forbes)

## -----------------------------------------------------------------------------
colnames(forbes) <- c("TempF", "Pressure") # Change the names of the variables

forbes$TempC <- round((forbes$TempF - 32) * 5 / 9, 2) # From Fahrenheit to Celsius
summary(forbes)

## -----------------------------------------------------------------------------
par(mfrow = c(1, 2)) # Split the graphical window into 2 parts

# Option 1, for a total of 6 equally spaced classes
hist(forbes$TempC) # Equivalent to: hist(forbes$TempC, breaks = "sturges")

# Option 2, we define manually 5 equally spaced classes
breaks <- c(90, 92.5, 95, 97.5, 100, 102.5)
hist(forbes$TempC, breaks = breaks)

## -----------------------------------------------------------------------------
# First part of the question
mean(forbes$TempC)
mean(forbes$Pressure)

## -----------------------------------------------------------------------------
# Second part of the question
32 + 9 / 5 * mean(forbes$TempC) # Using the properties of the mean
mean(forbes$TempF) # Not required: computes the mean from the original data

## -----------------------------------------------------------------------------
# Yes, the function is defined on a single line and there is nothing wrong with it
my_var <- function(x) mean(x^2) - mean(x)^2

# Computation of the two variances
my_var(forbes$TempC)
my_var(forbes$Pressure)

## -----------------------------------------------------------------------------
par(mfrow = c(1, 1)) # We want to show one plot at a time
plot(forbes$TempC, forbes$Pressure)
plot(forbes$TempC, forbes$Pressure,
  pch = 16,
  xlab = "Temperature", ylab = "Pressure"
)

## -----------------------------------------------------------------------------
my_cov <- function(x, y) mean(x * y) - mean(x) * mean(y)
my_cov(forbes$TempC, forbes$Pressure) # = my_cov(forbes$Pressure, forbes$TempC)

## -----------------------------------------------------------------------------
cov(forbes$Pressure, forbes$TempC) # = 17 / 16 * my_cov(forbes$TempC, forbes$Pressure)

## -----------------------------------------------------------------------------
my_cov(forbes$TempC, forbes$Pressure) /
  sqrt(my_var(forbes$TempC) * my_var(forbes$Pressure))

cov(forbes$TempC, forbes$Pressure) /
  sqrt(var(forbes$TempC) * var(forbes$Pressure))

## -----------------------------------------------------------------------------
correlation <- cor(forbes$TempC, forbes$Pressure)
correlation

## -----------------------------------------------------------------------------
# Slope
beta_hat <- my_cov(forbes$TempC, forbes$Pressure) / my_var(forbes$TempC)
# Intercept
alpha_hat <- mean(forbes$Pressure) - mean(forbes$TempC) * beta_hat

c(alpha_hat, beta_hat)

## -----------------------------------------------------------------------------
plot(forbes$TempC, forbes$Pressure,
  pch = 16,
  xlab = "Temperature", ylab = "Pressure"
)
abline(a = alpha_hat, b = beta_hat)

## -----------------------------------------------------------------------------
lm(Pressure ~ TempC, data = forbes)

## -----------------------------------------------------------------------------
x <- seq(from = 90, to = 100, length = 20)
alpha_hat + beta_hat * x

## -----------------------------------------------------------------------------
alpha_hat + beta_hat * 97

## -----------------------------------------------------------------------------
residuals <- forbes$Pressure - (alpha_hat + beta_hat * forbes$TempC)

## -----------------------------------------------------------------------------
correlation^2
1 - my_var(residuals) / my_var(forbes$Pressure)

## -----------------------------------------------------------------------------
income <- c(18.2, 21.4, 25.0, 27.6, 30.1, 33.4, 36.8, 41.2, 45.9, 52.3)
consumption <- c(3.1, 3.6, 4.0, 4.2, 4.9, 5.1, 5.8, 6.0, 6.9, 7.4)
