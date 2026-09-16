# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises B
# elections dataset
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
load("../data/elections.RData")
# Alternatively, reading the file directly from the website of the course:
# load(url("https://tommasorigon.github.io/EnvEcoStat/data/elections.RData"))

# 2 --------------------------------------------------------------------
str(elections) # Two variables of type "factor", "party" and "district"

# 3 --------------------------------------------------------------------
table(elections$party, elections$district)

# 4 --------------------------------------------------------------------
# Number of votes
table(elections$party)

# Barplot (the names may not appear, depending on the size of the plot window)
barplot(table(elections$party))

# Percentage of votes (rounded)
round(100 * table(elections$party) / nrow(elections), 2)

# 5 --------------------------------------------------------------------
Gini <- function(x) {
  freq <- as.numeric(table(x))
  freq_rel <- freq / sum(freq)
  1 - sum(freq_rel^2)
}

# 6 --------------------------------------------------------------------
Gini_norm <- function(x) {
  freq <- as.numeric(table(x))
  freq_rel <- freq / sum(freq)
  k <- length(freq)
  k / (k - 1) * (1 - sum(freq_rel^2))
}

# 7 --------------------------------------------------------------------
G <- tapply(elections$party, elections$district, Gini_norm)
round(G, 4)
names(which.max(G)) # District 9: the most fragmented
names(which.min(G)) # District 1: the most concentrated (polarised)
