# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises D
# Houses dataset (adapted from AK 6.15)
# ----------------------------------------------------------------------

rm(list = ls())

path <- "https://stat4ds.rwth-aachen.de/data/Houses.dat"
Houses <- read.table(path, header = TRUE)

# 1 --------------------------------------------------------------------
fit_size <- lm(price ~ size, data = Houses)
summary(fit_size)
confint(fit_size)
# One additional square foot corresponds, on average, to about 190 dollars

# 2 --------------------------------------------------------------------
new_house <- data.frame(size = 2000)
predict(fit_size, newdata = new_house, interval = "confidence") # Mean price
predict(fit_size, newdata = new_house, interval = "prediction") # A single house

# 3 --------------------------------------------------------------------
cor(Houses$size, Houses$taxes) # Larger houses pay more taxes
fit_both <- lm(price ~ size + taxes, data = Houses)
summary(fit_both)
# Adjusting for taxes, the effect of size is about halved: the taxes depend
# on the value of the house, which in turn depends on its size
