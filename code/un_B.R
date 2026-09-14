## -----------------------------------------------------------------------------
class(sum) # Identifies the type of object

## -----------------------------------------------------------------------------
class(log) # Second example

## -----------------------------------------------------------------------------
cube <- function(x) {
  out <- x^3
  out
}

## -----------------------------------------------------------------------------
cube(4) # Computes the cube of the value 4

## -----------------------------------------------------------------------------
cube <- function(x) {
  out <- x^3
  return(out) # Makes it explicit that the value to be returned is out
}
cube(8) # Computes the cube of the value 8

## -----------------------------------------------------------------------------
power <- function(x, p = 2) {
  out <- x^p
  out
}

## -----------------------------------------------------------------------------
power(x = 4) # Computes the square of the value 4

## -----------------------------------------------------------------------------
power(4) # Alternative syntax: the argument names need not be specified

## -----------------------------------------------------------------------------
power(x = 4, p = 3) # Computes the cube of the value 4
power(4, 3) # Alternative syntax: the argument names need not be specified

## -----------------------------------------------------------------------------
condition <- pi^2 < 10 # Boolean value (in this case the condition is TRUE)

if (condition) {
  print("The condition is true")
  # Some commands to be executed
  # ...
} else {
  print("The condition is false")
  # Other commands to be executed
  # ...
}

## -----------------------------------------------------------------------------
square_root <- function(x) {
  if (x < 0) {
    # Warning message; it would actually be more appropriate to use "warning"
    print("The value of x must be positive")
    out <- NaN # Return Not A Number
  } else {
    out <- sqrt(x)
  }
  out
}

square_root(-2) # The condition x < 0 is satisfied
square_root(36) # The condition x < 0 is NOT satisfied

## -----------------------------------------------------------------------------
i <- 5 # We start with i = 5

while (i <= 25) { # Repeats the operation as long as i is smaller or equal to 25
  print(i) # Prints on screen the value of i
  i <- i + 5 # Increases the value of i

  # In real settings, here there are of course other operations to be executed
  # ...
}

## -----------------------------------------------------------------------------
#| eval: false
# # DO NOT RUN THE FOLLOWING CODE!
# #
# # The condition i <= 25 is always true because i is never updated
# i <- 5
# while (i <= 25) {
#   print(i)
#
#   # Other operations to be executed
#   # ...
# }

## -----------------------------------------------------------------------------
values <- seq(from = 5, to = 25, by = 5)
values

for (i in values) {
  print(i + 2) # Prints on screen the value of i + 2

  # Other operations to be executed
  # ...
}

## -----------------------------------------------------------------------------
distances <- function(x) {
  n <- length(x) # Get the length of the vector x
  D <- matrix(0, nrow = n, ncol = n) # Creation of an empty matrix

  for (i in 1:n) {
    for (j in 1:n) {
      D[i, j] <- (x[i] - x[j])^2
    }
  }
  D # Value to be returned
}

x <- c(5, 2, 1, 24) # Example to check that it is correct
distances(x)

## -----------------------------------------------------------------------------
#| eval: false
# for (i in 1:100) {
#   condA <- (i %% 3) == 0 # Is the number a multiple of 3?
#   condB <- (i %% 5) == 0 # Is the number a multiple of 5?
#
#   if (condA & condB) {
#     print("fizzbuzz")
#   } else if (condA) {
#     print("fizz")
#   } else if (condB) {
#     print("buzz")
#   } else {
#     print(i)
#   }
# }

## -----------------------------------------------------------------------------
library(MASS) # Loads the MASS package into memory
library(knitr) # Loads the knitr package into memory

## -----------------------------------------------------------------------------
#| eval: false
# install.packages("knitr") # Installs the knitr package
