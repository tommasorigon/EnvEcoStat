# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises A
# Exercise G
# ----------------------------------------------------------------------

rm(list = ls())

# The exercise asked you to guess the result without running the code. If executed, it returns 202.

h <- function(x) {
  x^2
}

g <- function(x) {
  h(x) + 1
}

f <- function(x) {
  g(x) * 2
}

f(10)
