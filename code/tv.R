# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises C
# Students dataset (AK 4.14(a))
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Students.dat"
students <- read.table(path, header = TRUE)
tv <- students$tv

summary(tv)
hist(tv) # Skewed to the right

# 2 --------------------------------------------------------------------
n <- length(tv)
t_quant <- qt(0.975, df = n - 1)
c(mean(tv) - t_quant * sd(tv) / sqrt(n), mean(tv) + t_quant * sd(tv) / sqrt(n))
t.test(tv)$conf.int # The same interval

# 3 --------------------------------------------------------------------
# The population is not normal, but n = 60 is large enough for the central
# limit theorem. The real issue is that the students are not a random sample
# of a well-defined population
