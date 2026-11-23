# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises B
# elections dataset
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
load("data/elections.RData")
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
round(100 * prop.table(table(elections$party)), 2)

# 5 --------------------------------------------------------------------
Gini <- function(x) {
  freq_rel <- prop.table(table(x)) # Relative frequencies
  1 - sum(freq_rel^2)
}

# 6 --------------------------------------------------------------------
Gini_norm <- function(x) {
  k <- length(table(x)) # Number of categories
  k / (k - 1) * Gini(x)
}

# 7 --------------------------------------------------------------------
districts <- levels(elections$district)
G <- rep(NA, length(districts)) # Empty vector, to be filled
for (j in 1:length(districts)) {
  G[j] <- Gini_norm(elections$party[elections$district == districts[j]])
}
cbind(district = 1:length(districts), Gini = round(G, 4)) # Table of the results
districts[which.max(G)] # District 9: the most fragmented
districts[which.min(G)] # District 1: the most concentrated (polarised)
