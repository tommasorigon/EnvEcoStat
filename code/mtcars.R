# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises A
# mtcars dataset
# ----------------------------------------------------------------------

rm(list = ls())

data(mtcars)

# 1 --------------------------------------------------------------------
dim(mtcars) # 32 rows, 11 columns

# 2 --------------------------------------------------------------------
# mtcars[1:20] # It returns an error: a comma is missing
mtcars[1:20, ] # Correct command

# 3 --------------------------------------------------------------------
# mtcars[mtcars$cyl = 4, ] # WRONG
mtcars[mtcars$cyl == 4, ] # CORRECT

# mtcars[-1:4, ] # WRONG
mtcars[-(1:4), ] # CORRECT (drops the first 4 rows)

# mtcars[mtcars$cyl <= 5] # WRONG
mtcars[mtcars$cyl <= 5, ] # CORRECT

# mtcars[mtcars$cyl == 4 | 6, ] # WRONG
mtcars[mtcars$cyl == 4 | mtcars$cyl == 6, ] # CORRECT
