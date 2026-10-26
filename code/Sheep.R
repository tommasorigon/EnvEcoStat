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
weight_0 <- Sheep$weight[Sheep$survival == 0] # Did not survive
weight_1 <- Sheep$weight[Sheep$survival == 1] # Survived

mean(weight_0) # 16.0
mean(weight_1) # 20.6
median(weight_0) # 14.8
median(weight_1) # 21.6
sd(weight_0) # 5.3
sd(weight_1) # 4.9
summary(weight_0)
summary(weight_1)

# 3 --------------------------------------------------------------------
boxplot(weight ~ survival, data = Sheep)

# 4 --------------------------------------------------------------------
# The sheep that survived are clearly heavier, by about 5 kg on average, and
# the two distributions still overlap a great deal. This is an observational
# study: the weight is a symptom of the health of the animal, not necessarily
# a cause of its survival
