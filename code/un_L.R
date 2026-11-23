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
