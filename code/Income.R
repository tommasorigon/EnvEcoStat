# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises D
# Income dataset
# ----------------------------------------------------------------------

rm(list = ls())

path <- "https://stat4ds.rwth-aachen.de/data/Income.dat"
Income <- read.table(path, header = TRUE)

# 1 --------------------------------------------------------------------
fit_edu <- lm(income ~ education, data = Income)
summary(fit_edu)
confint(fit_edu)
# One additional year of education corresponds, on average, to 4.66
# thousand dollars of additional income

# 2 --------------------------------------------------------------------
Income$race <- factor(Income$race, levels = c("H", "B", "W")) # H is the reference
fit_race <- lm(income ~ race, data = Income)
summary(fit_race)
# raceW = 11.48 is the difference between the mean incomes of Whites and
# Hispanics. Its P-value (0.060) is larger than 0.05: not significant at 5%

# 3 --------------------------------------------------------------------
fit_both <- lm(income ~ race + education, data = Income)
new_people <- data.frame(race = c("B", "H", "W"), education = c(12, 12, 12))
predict(fit_both, newdata = new_people) # 26.6, 32.6 and 37.5
# With the same education, the differences from the Hispanic person are the
# coefficients raceB (-5.94) and raceW (4.93), whatever the years of education:
# the lines of the three groups are parallel
