# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises D
# Polid dataset (adapted from AK 6.13)
# ----------------------------------------------------------------------

rm(list = ls())

Polid <- read.table("data/polid.csv", header = TRUE, sep = ",")
Polid$race <- factor(Polid$race)

# 1 --------------------------------------------------------------------
table(Polid$race)
ideology_black <- Polid$ideology[Polid$race == "black"]
ideology_hispanic <- Polid$ideology[Polid$race == "hispanic"]
ideology_white <- Polid$ideology[Polid$race == "white"]
c(mean(ideology_black), mean(ideology_hispanic), mean(ideology_white)) # 3.82, 4.09, 4.17

# 2 --------------------------------------------------------------------
fit <- lm(ideology ~ race, data = Polid)
coef(fit) # Differences from the reference category, black

# 3 --------------------------------------------------------------------
anova(fit) # F = 9.62, P-value 0.00007: the three means are not all equal

# 4 --------------------------------------------------------------------
# The largest difference between the means is about 0.35 points on a scale
# from 1 to 7: statistically significant, because n = 2575 is very large, but
# small in practice
