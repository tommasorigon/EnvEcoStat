# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises B
# Houses dataset (AK 1.19-1.20)
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Houses.dat"
Houses <- read.table(path, header = TRUE)

classes <- seq(0, 900, by = 100)
table(cut(Houses$price, breaks = classes))
hist(Houses$price, breaks = classes)
# The distribution is strongly skewed to the right

# 2 --------------------------------------------------------------------
boxplot(Houses$price)
# Several unusually high prices, all on the right

# 3 --------------------------------------------------------------------
log_price <- log(Houses$price)
hist(log_price, breaks = seq(3, 7, by = 0.5))
boxplot(log_price)

c(mean(Houses$price), median(Houses$price)) # 233.0 and 198.9: the mean is larger
c(mean(log_price), median(log_price)) # 5.291 and 5.293: essentially the same value
# On the logarithmic scale the distribution is almost symmetric

# 4 --------------------------------------------------------------------
table(Houses$new) # Only 11 of the 100 houses are new
price_old <- Houses$price[Houses$new == 0] # Old houses
price_new <- Houses$price[Houses$new == 1] # New houses

summary(price_old)
summary(price_new)
boxplot(price ~ new, data = Houses)
# New houses are sold at about twice the price, but they are only 11: the
# comparison is based on a very small group

# 5 --------------------------------------------------------------------
plot(Houses$size, Houses$price)
Houses[which.max(Houses$size), ] # Case 64: the largest house, 4050 square feet
# Its price is in line with houses of about half its size

# 6 --------------------------------------------------------------------
my_var <- function(x) mean(x^2) - mean(x)^2
my_cov <- function(x, y) mean(x * y) - mean(x) * mean(y)

cor(Houses$size, Houses$price) # 0.834, a strong positive linear relationship

beta_hat <- my_cov(Houses$size, Houses$price) / my_var(Houses$size)
alpha_hat <- mean(Houses$price) - beta_hat * mean(Houses$size)
c(alpha_hat, beta_hat) # Intercept -76.39, slope 0.1899
# One additional square foot is worth, on average, about 190 dollars
abline(a = alpha_hat, b = beta_hat)

alpha_hat + beta_hat * c(1000, 4000) # 113.5 and 683.2 thousand dollars

# 7 --------------------------------------------------------------------
Houses_no64 <- subset(Houses, case != 64)
beta_hat2 <- my_cov(Houses_no64$size, Houses_no64$price) / my_var(Houses_no64$size)
alpha_hat2 <- mean(Houses_no64$price) - beta_hat2 * mean(Houses_no64$size)
c(alpha_hat2, beta_hat2) # Intercept -109.37, slope 0.2127
# A single observation out of 100 changes the slope by more than 10%
