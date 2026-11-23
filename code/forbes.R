# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises D
# forbes dataset
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
forbes <- read.table("data/forbes.csv", header = TRUE, sep = ",")
colnames(forbes) <- c("TempF", "Pressure")
forbes$TempC <- round((forbes$TempF - 32) * 5 / 9, 2)

fit <- lm(Pressure ~ TempC, data = forbes)
coef(fit) # The same estimates of Unit F
# One additional degree Celsius corresponds, on average, to 0.94 inHg more

# 2 --------------------------------------------------------------------
summary(fit) # P-value of the slope practically zero: we reject H0
confint(fit)

# 3 --------------------------------------------------------------------
new_temp <- data.frame(TempC = 97)
predict(fit, newdata = new_temp, interval = "confidence")
predict(fit, newdata = new_temp, interval = "prediction") # Wider

# 4 --------------------------------------------------------------------
plot(fitted(fit), residuals(fit), pch = 16)
abline(h = 0, lty = "dashed")
which.max(abs(residuals(fit))) # One location has a much larger residual
