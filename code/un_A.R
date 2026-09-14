## -----------------------------------------------------------------------------
2 + 2
4 * (3 + 5) # The sum within brackets is executed first
pi / 4 # Pi over four

## -----------------------------------------------------------------------------
2^5 # Alternative syntax: 2**5

## -----------------------------------------------------------------------------
sqrt(2)
sin(pi / 4)

## -----------------------------------------------------------------------------
# Assign the value sqrt(5) to the object x
x <- sqrt(5) # Alternative syntax (not recommended): x = sqrt(5)

## -----------------------------------------------------------------------------
y <- x + pi # That is, pi plus the square root of 5
y

## -----------------------------------------------------------------------------
rm(x) # x is no longer present in the "workspace"

## -----------------------------------------------------------------------------
ls() # The object y is present in the workspace

## -----------------------------------------------------------------------------
rm(list = ls())

## -----------------------------------------------------------------------------
x <- 1 / 2 # Example of a real number

## -----------------------------------------------------------------------------
exp(x) # Exponential and natural logarithm
log(x)

## -----------------------------------------------------------------------------
abs(x) # Absolute value
sign(x) # Sign function

## -----------------------------------------------------------------------------
sin(x) # Trigonometric functions (sine, cosine, tangent)
cos(x)
tan(x)

## -----------------------------------------------------------------------------
asin(x) # Inverse trigonometric functions
acos(x)
atan(x)

## -----------------------------------------------------------------------------
x <- 1 / 2 # Real numbers
y <- 1 / 3
n <- 5 # Natural numbers
k <- 2

## -----------------------------------------------------------------------------
factorial(n) # n!
choose(n, k) # Binomial coefficient

## -----------------------------------------------------------------------------
round(x, digits = 2) # Rounds x using 2 decimal digits
floor(x) # Rounds x down to the nearest integer
ceiling(x) # Rounds x up to the nearest integer

## -----------------------------------------------------------------------------
gamma(x) # Gamma function

## -----------------------------------------------------------------------------
beta(x, y) # Beta function

## -----------------------------------------------------------------------------
#| fig-width: 12
#| fig-height: 5
curve(sin(x) / x, from = 0, to = 15)

## -----------------------------------------------------------------------------
# Run the following command in the console to open the documentation
# of the log function:
# ? log

## -----------------------------------------------------------------------------
10^15
10^(-15)

## -----------------------------------------------------------------------------
10^1000 # A very large number, although finite

## -----------------------------------------------------------------------------
#| warning: true
log(-1) # This command also generates a warning

## -----------------------------------------------------------------------------
sin(pi)

## -----------------------------------------------------------------------------
cos(pi)

## -----------------------------------------------------------------------------
x <- 5
x < 0 # Is the value of x smaller than 0?
a <- (x == -3) # Is the value of x equal to -3?
a

## -----------------------------------------------------------------------------
a <- TRUE
b <- FALSE
x <- 5
y <- 7
x >= y # Is x greater than or equal to y? (Use "<=" for smaller or equal)
x != y # Is x different from y?
a & b # a AND b. Are the boolean values a and b both true?
a | b # a OR b. Is at least one of a and b true?

## -----------------------------------------------------------------------------
x <- c(4, 2, 2, 8, 10)
x

## -----------------------------------------------------------------------------
x <- c("A", "B", 2, 8, 10)
x

## -----------------------------------------------------------------------------
x <- 5:10 # Equivalent to: x <- c(5, 6, 7, 8, 9, 10)
x

## -----------------------------------------------------------------------------
x <- seq(from = 0, to = 1, by = 0.1)
x

## -----------------------------------------------------------------------------
x <- rep(10, 7) # Vector in which the number 10 is repeated 7 times
x

## -----------------------------------------------------------------------------
exp(1:6) + (1:6) / 2 + 1 # Example 1

## -----------------------------------------------------------------------------
x <- c(10, 10^2, 10^3, 10^4, 10^5, 10^6) # Example 2
log(x, base = 10)

## -----------------------------------------------------------------------------
1:8 > 4 # Example 3

## -----------------------------------------------------------------------------
x <- c(2, 3, 1, 3, 10, 5)
length(x) # Length of the vector
sum(x) # Sum of the elements of the vector
cumsum(x) # Cumulative sums

## -----------------------------------------------------------------------------
x <- c(2, 3, 1, 3, 10, 5)
prod(x) # Product of the elements of the vector
cumprod(x) # Cumulative products
sort(x, decreasing = FALSE) # Vector sorted in increasing order
min(x) # Minimum value
which.min(x) # Position of the value corresponding to the minimum

## -----------------------------------------------------------------------------
max(x) # Maximum value
which.max(x) # Position of the value corresponding to the maximum
range(x) # Equivalent to: c(min(x), max(x))

## -----------------------------------------------------------------------------
# Concatenation of vectors
x <- c(rep(pi, 2), sqrt(2), c(10, 7))
x[3] # Extracts the third element from the vector x, that is sqrt(2)
x[c(1, 3, 5)] # Extracts the first, the third and the fifth element
x[-c(1, 3, 5)] # Deletes the first, the third and the fifth element
x[x > 3.5] # Extracts the elements greater than 3.5

## -----------------------------------------------------------------------------
#| warning: true
x <- 1:5
y <- 1:6
x + y # Equivalent to: c(x, x[1]) + y

## -----------------------------------------------------------------------------
x <- 1:3
y <- 1:6
x + y # Equivalent to: c(x, x) + y

## -----------------------------------------------------------------------------
A <- matrix(c(5, 1, 2, 4), nrow = 2, ncol = 2)
A

## -----------------------------------------------------------------------------
# Equivalent definition
A <- matrix(c(5, 2, 1, 4), nrow = 2, ncol = 2, byrow = TRUE)

## -----------------------------------------------------------------------------
x_col <- matrix(c(1, 10, 3, 5), ncol = 1)
x_col

## -----------------------------------------------------------------------------
x_row <- matrix(c(1, 10, 3, 5), nrow = 1)
x_row

## -----------------------------------------------------------------------------
x_row <- matrix(c(1, 10, 3, 5), nrow = 1)
x <- c(1, 10, 3, 5) # Similar, but not identical, to x_row

## -----------------------------------------------------------------------------
dim(x_row)
dim(x)

## -----------------------------------------------------------------------------
A[1, 2] # Extraction of the element in position (1,2)
A[, 2] # Extraction of the second column
A[1, ] # Extraction of the first row

## -----------------------------------------------------------------------------
dim(A) # Returns the dimension of the matrix
a <- c(A) # Converts the matrix into a vector
a

## -----------------------------------------------------------------------------
diag(A) # Returns the diagonal of the matrix
t(A) # Computes the transposed matrix A'
sum(A) # Sum of all the elements of A

## -----------------------------------------------------------------------------
exp(A)

## -----------------------------------------------------------------------------
B <- A # I create a matrix B identical to A, for simplicity
C <- rbind(A, B)
C

## -----------------------------------------------------------------------------
C <- cbind(A, B)
C

## -----------------------------------------------------------------------------
x <- matrix(c(-4, 2, 6, 10, 22), ncol = 1)
y <- matrix(c(3, 2, 2, 7, 9), ncol = 1)
crossprod(x, y) # Equivalent to: sum(x * y)

## -----------------------------------------------------------------------------
A <- rbind(c(1, 2, 3), c(4, 9, 2), c(2, 2, 2))
B <- rbind(c(5, 2, 5), c(3, 3, 7), c(-2, -8, 10))

A %*% B # Row-by-column product AB

## -----------------------------------------------------------------------------
A <- rbind(c(1, 2, 3), c(4, 9, 2), c(2, 2, 2))
A1 <- solve(A) # Inverse matrix of A
A1

## -----------------------------------------------------------------------------
round(A %*% A1, digits = 5) # Sanity check

## -----------------------------------------------------------------------------
det(A) # Computes the determinant of the matrix A

## -----------------------------------------------------------------------------
# Example of a NON invertible matrix
A <- rbind(c(1, 2, 3), c(2, 4, 6), c(2, 2, 2))
det(A) # Determinant equal to 0, solve(A) produces an error

## -----------------------------------------------------------------------------
A <- matrix(c(4, 1, 1, 8), ncol = 2)
chol(A) # Cholesky decomposition
qr(A) # QR decomposition
eigen(A) # Spectral decomposition

## -----------------------------------------------------------------------------
# Creation of a list
new_list <- list(
  A = matrix(c(4, 1, 1, 8), ncol = 2),
  x = c(1, 2, 6, 6, 9)
)

new_list

## -----------------------------------------------------------------------------
Spec_A <- eigen(A) # Spectral decomposition of the matrix A
Spec_A

## -----------------------------------------------------------------------------
Spec_A$values # Extraction of the eigenvalues
