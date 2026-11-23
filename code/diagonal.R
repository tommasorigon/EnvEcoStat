# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises A
# Exercise E
# ----------------------------------------------------------------------

rm(list = ls())

diag2 <- function(A) {
  n <- nrow(A)
  diagonal <- rep(NA, n) # Empty vector, to be filled
  for (i in 1:n) {
    diagonal[i] <- A[i, i]
  }
  diagonal
}

A <- matrix(1:25, nrow = 5)

diag(A)
diag2(A)
