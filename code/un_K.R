## -----------------------------------------------------------------------------
trees <- read.table("data/trees.csv", header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
#| eval: false
# path <- "https://tommasorigon.github.io/EnvEcoStat/data/trees.csv"
# trees <- read.table(path, header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
str(trees)

## -----------------------------------------------------------------------------
cherry <- data.frame(
  diameter = round(trees$Girth * 2.54, 1), # cm
  height = round(trees$Height * 0.3048, 1), # m
  volume = round(trees$Volume * 0.0283168, 3) # cubic metres
)
summary(cherry)

## -----------------------------------------------------------------------------
plot(cherry$diameter, cherry$volume,
  pch = 16,
  xlab = "Diameter (cm)", ylab = "Volume (cubic metres)"
)
cor(cherry$diameter, cherry$volume)

## -----------------------------------------------------------------------------
my_var <- function(x) mean(x^2) - mean(x)^2
my_cov <- function(x, y) mean(x * y) - mean(x) * mean(y)

x <- cherry$diameter
y <- cherry$volume
beta1_hat <- my_cov(x, y) / my_var(x) # Slope
beta0_hat <- mean(y) - beta1_hat * mean(x) # Intercept
c(beta0_hat, beta1_hat)

## -----------------------------------------------------------------------------
fit <- lm(volume ~ diameter, data = cherry)
coef(fit) # Least squares estimates

## -----------------------------------------------------------------------------
head(fitted(fit))
head(residuals(fit))

## -----------------------------------------------------------------------------
e <- residuals(fit)
1 - my_var(e) / my_var(y)
cor(x, y)^2

## -----------------------------------------------------------------------------
plot(cherry$diameter, cherry$volume,
  pch = 16,
  xlab = "Diameter (cm)", ylab = "Volume (cubic metres)"
)
abline(fit) # Same as abline(a = beta0_hat, b = beta1_hat)

## -----------------------------------------------------------------------------
n <- nrow(cherry)
s <- sqrt(sum(e^2) / (n - 2))
s
sigma(fit) # The same value, computed by R

## -----------------------------------------------------------------------------
se_hat <- s / sqrt(sum((x - mean(x))^2)) # Estimated standard error
se_hat

## -----------------------------------------------------------------------------
t_obs <- (beta1_hat - 0) / se_hat # Observed test statistic
t_obs
qt(0.975, df = n - 2) # Critical value, significance level 5%
2 * (1 - pt(abs(t_obs), df = n - 2)) # Two-sided P-value

## -----------------------------------------------------------------------------
summary(fit)

## -----------------------------------------------------------------------------
t_quant <- qt(0.975, df = n - 2) # Quantile of order 0.975
c(beta1_hat - t_quant * se_hat, beta1_hat + t_quant * se_hat)
confint(fit) # Both beta_0 and beta_1, 95% by default

## -----------------------------------------------------------------------------
beta0_hat + beta1_hat * 40
new_tree <- data.frame(diameter = 40)
predict(fit, newdata = new_tree)

## -----------------------------------------------------------------------------
predict(fit, newdata = new_tree, interval = "confidence")
predict(fit, newdata = new_tree, interval = "prediction")

## -----------------------------------------------------------------------------
plot(fitted(fit), residuals(fit),
  pch = 16,
  xlab = "Fitted values", ylab = "Residuals"
)
abline(h = 0, lty = "dashed") # Horizontal line at zero

## -----------------------------------------------------------------------------
par(mfrow = c(1, 2)) # Two plots side by side
plot(fit, which = 1:2)
par(mfrow = c(1, 1))

## -----------------------------------------------------------------------------
predict(fit, newdata = data.frame(diameter = 15))

## -----------------------------------------------------------------------------
pairs(cherry, pch = 16)
round(cor(cherry), 2)

## -----------------------------------------------------------------------------
fit2 <- lm(volume ~ diameter + height, data = cherry)
coef(fit2)

## -----------------------------------------------------------------------------
summary(fit2)

## -----------------------------------------------------------------------------
confint(fit2)

## -----------------------------------------------------------------------------
new_trees <- data.frame(diameter = c(40, 40), height = c(20, 25))
predict(fit2, newdata = new_trees, interval = "prediction")

## -----------------------------------------------------------------------------
par(mfrow = c(1, 2))
plot(fit2, which = 1:2)
par(mfrow = c(1, 1))
