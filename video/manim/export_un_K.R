# Data for the Unit K videos (v4_least_squares.py, v5_least_squares_3d.py): the
# black cherry trees, in the same units of the notes.
cherry <- data.frame(
  diameter = round(trees$Girth * 2.54, 1), # cm
  height = round(trees$Height * 0.3048, 1), # m
  volume = round(trees$Volume * 0.0283168, 3) # cubic metres
)
write.csv(cherry, "cherry.csv", row.names = FALSE)

fit <- lm(volume ~ diameter, data = cherry)
print(coef(fit))
print(c(SSE = sum(residuals(fit)^2), SST = sum((cherry$volume - mean(cherry$volume))^2)))

fit2 <- lm(volume ~ diameter + height, data = cherry)
print(coef(fit2))
print(c(SSE2 = sum(residuals(fit2)^2)))
