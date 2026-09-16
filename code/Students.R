# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises A
# Students dataset (AK 1.2(a))
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Students.dat"
students <- read.table(path, header = TRUE)

# 2 --------------------------------------------------------------------
dim(students) # 60 rows and 18 columns
str(students) # Every variable is stored as a number
sum(is.na(students)) # 0, there are no missing values

# 3 --------------------------------------------------------------------
students$gender <- factor(students$gender,
  levels = c(0, 1),
  labels = c("male", "female")
)
students$life <- factor(students$life,
  levels = c(1, 2, 3),
  labels = c("yes", "no", "undecided")
)
table(students$life)

# 4 --------------------------------------------------------------------
students[, c("age", "hsgpa", "cogpa")]

# 5 --------------------------------------------------------------------
sum(students$veg) # 9 vegetarians
nrow(subset(students, age > 30)) # 18 students

# 6 --------------------------------------------------------------------
students$gpa_change <- students$cogpa - students$hsgpa
sum(students$gpa_change > 0) # The GPA improved for 29 students
