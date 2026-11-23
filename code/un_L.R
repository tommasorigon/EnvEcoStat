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

## -----------------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Income.dat"
Income <- read.table(path, header = TRUE)
Income$race <- factor(Income$race)
table(Income$race)
boxplot(income ~ race, data = Income)

## -----------------------------------------------------------------------------
fit_race <- lm(income ~ race, data = Income)
coef(fit_race)

## -----------------------------------------------------------------------------
income_B <- Income$income[Income$race == "B"]
income_H <- Income$income[Income$race == "H"]
income_W <- Income$income[Income$race == "W"]
c(mean(income_B), mean(income_H), mean(income_W))
c(mean(income_H) - mean(income_B), mean(income_W) - mean(income_B))

## -----------------------------------------------------------------------------
anova(fit_race)

## -----------------------------------------------------------------------------
fit_race_edu <- lm(income ~ race + education, data = Income)
summary(fit_race_edu)
