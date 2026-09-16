# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises B
# Murder dataset (AK 1.17)
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Murder.dat"
Murder <- read.table(path, header = TRUE)
Murder_no_DC <- subset(Murder, state != "DC")

# 2 --------------------------------------------------------------------
mean(Murder_no_DC$murder) # 4.87 murders per 100.000 inhabitants
sd(Murder_no_DC$murder) # 2.59

# 3 --------------------------------------------------------------------
fivenum(Murder_no_DC$murder) # 1.00, 2.60, 4.85, 6.20, 12.40
boxplot(Murder_no_DC$murder)
# Louisiana (12.4) is already an outlier among the 50 states

# 4 --------------------------------------------------------------------
c(mean(Murder_no_DC$murder), mean(Murder$murder)) # 4.87 -> 5.25
c(median(Murder_no_DC$murder), median(Murder$murder)) # 4.85 -> 5.00

diff(range(Murder_no_DC$murder)) # 11.4
diff(range(Murder$murder)) # 23.2, twice as much

IQR(Murder_no_DC$murder) # 3.55
IQR(Murder$murder) # 3.80, almost unchanged

# A single observation moves the mean and the range a lot, the median and the
# interquartile range very little: the latter are *robust* to outliers
