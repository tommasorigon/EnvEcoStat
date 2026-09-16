# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises A
# swiss dataset
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
swiss <- read.table("data/swiss.csv", header = TRUE, sep = ",")

dim(swiss) # 47 rows, 7 columns
str(swiss) # province is a character variable, the others are numeric

# 2 --------------------------------------------------------------------
# swiss[1:20] # It returns an error: a comma is missing
# Without the comma, R selects the columns, and there are only 7 of them
swiss[1:20, ] # Correct command: the first 20 provinces

# 3 --------------------------------------------------------------------
# swiss[swiss$Education = 7, ] # WRONG
swiss[swiss$Education == 7, ] # CORRECT (7 provinces)

# swiss[-1:4, ] # WRONG
swiss[-(1:4), ] # CORRECT (drops the first 4 rows, 43 are left)

# swiss[swiss$Education <= 5] # WRONG
swiss[swiss$Education <= 5, ] # CORRECT (10 provinces)

# swiss[swiss$Education == 7 | 12, ] # WRONG
swiss[swiss$Education == 7 | swiss$Education == 12, ] # CORRECT (12 provinces)
