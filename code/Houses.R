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
price_mean <- mean(Houses$price) # 233.0
price_sd <- sd(Houses$price) # 151.9
mean(abs(Houses$price - price_mean) <= price_sd) # 0.85, that is 85%
# The empirical rule concerns bell-shaped distributions. Here the distribution
# is strongly asymmetric, so the rule does not apply

# 3 --------------------------------------------------------------------
fivenum(Houses$price) # 31.5, 138.8, 198.9, 257.6, 880.5
boxplot(Houses$price) # Several outliers, all on the right

# 4 --------------------------------------------------------------------
log_price <- log(Houses$price)
hist(log_price, breaks = seq(3, 7, by = 0.5))
boxplot(log_price)

mean(log_price) # 5.291
median(log_price) # 5.293, essentially the same value
mean(abs(log_price - mean(log_price)) <= sd(log_price)) # 0.74

# On the logarithmic scale the distribution is almost symmetric and the
# percentage is much closer to 68%: the empirical rule is a statement about
# the shape of the distribution, not about the variable itself

# 5 --------------------------------------------------------------------
table(Houses$new) # Only 11 of the 100 houses are new
tapply(Houses$price, Houses$new, mean) # 207.9 vs 436.4
tapply(Houses$price, Houses$new, median) # 190.8 vs 427.5
boxplot(price ~ new, data = Houses)
# New houses are sold at about twice the price, but they are only 11: the
# comparison is based on a very small group

# 6 --------------------------------------------------------------------
plot(Houses$size, Houses$price)
# One house is the largest of the sample but is sold at an average price
Houses[which.max(Houses$size), ] # Case 64: 4050 square feet, 337.5

# 7 --------------------------------------------------------------------
cor(Houses$size, Houses$price) # 0.834, a strong positive linear relationship

fit <- lm(price ~ size, data = Houses)
coef(fit) # Intercept -76.39, slope 0.1899
# One additional square foot is worth, on average, about 190 dollars
abline(fit)

predict(fit, newdata = data.frame(size = c(1000, 4000))) # 113.5 and 683.2

# 8 --------------------------------------------------------------------
Houses_no64 <- subset(Houses, case != 64)
fit2 <- lm(price ~ size, data = Houses_no64)
coef(fit2) # Intercept -109.37, slope 0.2127
cor(Houses_no64$size, Houses_no64$price) # 0.871
# A single observation out of 100 changes the slope by more than 10%
