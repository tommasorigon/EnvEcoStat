# Data for the Unit K video (v4_least_squares.py): the black cherry trees, in
# the same units of the notes.
trees <- read.table("../../data/trees.csv", header = TRUE, sep = ",")
cherry <- data.frame(
  diameter = round(trees$Girth * 2.54, 1), # cm
  volume = round(trees$Volume * 0.0283168, 3) # cubic metres
)
write.csv(cherry, "cherry.csv", row.names = FALSE)

fit <- lm(volume ~ diameter, data = cherry)
print(coef(fit))
print(c(SSE = sum(residuals(fit)^2), SST = sum((cherry$volume - mean(cherry$volume))^2)))
