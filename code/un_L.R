## -----------------------------------------------------------------------------
cherry <- data.frame(
  diameter = round(trees$Girth * 2.54, 1), # cm
  height = round(trees$Height * 0.3048, 1), # m
  volume = round(trees$Volume * 0.0283168, 3) # cubic metres
)
summary(cherry)

## -----------------------------------------------------------------------------
pairs(cherry, pch = 16)
round(cor(cherry), 2)

## -----------------------------------------------------------------------------
fit <- lm(volume ~ diameter + height, data = cherry)
coef(fit)

## -----------------------------------------------------------------------------
summary(fit)

## -----------------------------------------------------------------------------
confint(fit)

## -----------------------------------------------------------------------------
fit_height <- lm(volume ~ height, data = cherry)
coef(fit_height)

## -----------------------------------------------------------------------------
new_trees <- data.frame(diameter = c(40, 40), height = c(20, 25))
predict(fit, newdata = new_trees, interval = "prediction")

## -----------------------------------------------------------------------------
plot(fitted(fit), residuals(fit),
  pch = 16,
  xlab = "Fitted values", ylab = "Residuals"
)
abline(h = 0, lty = "dashed")

## -----------------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Houses.dat"
Houses <- read.table(path, header = TRUE)
Houses$new <- factor(Houses$new, levels = c(0, 1), labels = c("no", "yes"))

## -----------------------------------------------------------------------------
fit_new <- lm(price ~ new, data = Houses)
coef(fit_new)

## -----------------------------------------------------------------------------
price_no <- Houses$price[Houses$new == "no"]
price_yes <- Houses$price[Houses$new == "yes"]
mean(price_no)
mean(price_yes) - mean(price_no)

## -----------------------------------------------------------------------------
boxplot(size ~ new, data = Houses)

## -----------------------------------------------------------------------------
fit_size_new <- lm(price ~ size + new, data = Houses)
summary(fit_size_new)
