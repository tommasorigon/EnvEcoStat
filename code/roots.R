# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises A
# Exercise C
# ----------------------------------------------------------------------

rm(list = ls())

# The solution of a quadratic equation is of course available in closed form

roots <- function(a, b, c) {
  Delta <- b^2 - 4 * a * c
  (-b + c(-1, 1) * sqrt(Delta)) / (2 * a)
}

# 1 --------------------------------------------------------------------
roots(1, 5, 2)

# 2 --------------------------------------------------------------------
roots(1, 2, 1)

# 3 --------------------------------------------------------------------
roots(1, 1, 1) # NaN and a warning: the discriminant is negative, so there
# are no real solutions (as for sqrt(-3))
