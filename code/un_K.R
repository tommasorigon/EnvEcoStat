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
beta_hat <- my_cov(x, y) / my_var(x) # Slope
alpha_hat <- mean(y) - beta_hat * mean(x) # Intercept
c(alpha_hat, beta_hat)

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
abline(fit) # Same as abline(a = alpha_hat, b = beta_hat)

## -----------------------------------------------------------------------------
n <- nrow(cherry)
s <- sqrt(sum(e^2) / (n - 2))
s

## -----------------------------------------------------------------------------
se_hat <- s / sqrt(n * my_var(x)) # Estimated standard error
se_hat

## -----------------------------------------------------------------------------
t_obs <- (beta_hat - 0) / se_hat # Observed test statistic
t_obs
qt(0.975, df = n - 2) # Critical value, significance level 5%
2 * (1 - pt(abs(t_obs), df = n - 2)) # Two-sided P-value

## -----------------------------------------------------------------------------
summary(fit)

## -----------------------------------------------------------------------------
t_quant <- qt(0.975, df = n - 2) # Quantile of order 0.975
c(beta_hat - t_quant * se_hat, beta_hat + t_quant * se_hat)
confint(fit) # Both alpha and beta, 95% by default

## -----------------------------------------------------------------------------
alpha_hat + beta_hat * 40
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
predict(fit, newdata = data.frame(diameter = 15))

## -----------------------------------------------------------------------------
fit_log <- lm(log(volume) ~ log(diameter), data = cherry)
summary(fit_log)

## -----------------------------------------------------------------------------
plot(fitted(fit_log), residuals(fit_log),
  pch = 16,
  xlab = "Fitted values", ylab = "Residuals"
)
abline(h = 0, lty = "dashed")

## -----------------------------------------------------------------------------
eta_hat <- exp(coef(fit_log)[1])
lambda_hat <- coef(fit_log)[2]

plot(cherry$diameter, cherry$volume,
  pch = 16,
  xlab = "Diameter (cm)", ylab = "Volume (cubic metres)"
)
abline(fit, lty = "dashed") # Linear model
curve(eta_hat * x^lambda_hat, add = TRUE, col = "red") # Linearised model

## -----------------------------------------------------------------------------
exp(predict(fit_log, newdata = new_tree, interval = "prediction"))

## -----------------------------------------------------------------------------
x_log <- log(cherry$diameter)
s_log <- sqrt(sum(residuals(fit_log)^2) / (n - 2))
se_hat <- s_log / sqrt(n * my_var(x_log)) # Estimated standard error
se_hat # The same value as in the column Std. Error

t_obs <- (lambda_hat - 2) / se_hat # Observed test statistic
t_obs
2 * (1 - pt(abs(t_obs), df = n - 2)) # Two-sided P-value
confint(fit_log)
