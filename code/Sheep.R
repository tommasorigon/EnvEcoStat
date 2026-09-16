# ----------------------------------------------------------------------
# Programming and Data Analysis with R - Exercises B
# Sheep dataset (AK 1.27)
# ----------------------------------------------------------------------

rm(list = ls())

# 1 --------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Sheep.dat"
Sheep <- read.table(path, header = TRUE)

nrow(Sheep) # 1359 sheep
table(Sheep$survival) # 318 did not survive, 1041 did

# 2 --------------------------------------------------------------------
tapply(Sheep$weight, Sheep$survival, mean) # 16.0 vs 20.6
tapply(Sheep$weight, Sheep$survival, median) # 14.8 vs 21.6
tapply(Sheep$weight, Sheep$survival, sd) # 5.3 vs 4.9
tapply(Sheep$weight, Sheep$survival, summary)

# 3 --------------------------------------------------------------------
boxplot(weight ~ survival, data = Sheep)

# 4 --------------------------------------------------------------------
# The sheep that survived are clearly heavier, by about 5 kg on average, and
# the two distributions still overlap a great deal. This is an observational
# study: the weight is a symptom of the health of the animal, not necessarily
# a cause of its survival
