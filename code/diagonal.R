# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises A
# Exercise F
# ----------------------------------------------------------------------

rm(list = ls())

diag2 <- function(A) {
  n <- nrow(A)
  diagonal <- numeric(n)
  for (i in 1:n) {
    diagonal[i] <- A[i, i]
  }
  diagonal
}

A <- rbind(
  c(26, 22, 17, 22, 23),
  c(22, 18, 14, 23, 27),
  c(17, 14, 14, 20, 24),
  c(22, 23, 20, 26, 23),
  c(23, 27, 24, 23, 12)
)

diag(A)
diag2(A)
