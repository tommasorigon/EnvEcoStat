## -----------------------------------------------------------------------------
dde <- read.table("data/dde.csv", header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
#| eval: false
# dde <- read.table("https://tommasorigon.github.io/EnvEcoStat/data/dde.csv",
#   header = TRUE, sep = ","
# ) # Downloads the file from the internet

## -----------------------------------------------------------------------------
str(dde)

## -----------------------------------------------------------------------------
dde_preterm <- dde$DDE[dde$GAD < 37 * 7] # Preterm delivery group
dde_non_preterm <- dde$DDE[dde$GAD >= 37 * 7] # Non-preterm delivery group

length(dde_preterm) # Sample size of group 1
length(dde_non_preterm) # Sample size of group 2

## -----------------------------------------------------------------------------
breaks <- 18 * (0:10) # Definition of the intervals: 10 intervals of length 18

dde_preterm_class <- cut(dde_preterm, breaks = breaks)
dde_non_preterm_class <- cut(dde_non_preterm, breaks = breaks)

head(dde_preterm_class)

## -----------------------------------------------------------------------------
freq_abs_preterm <- table(dde_preterm_class)
freq_abs_preterm

freq_abs_non_preterm <- table(dde_non_preterm_class)
freq_abs_non_preterm

## -----------------------------------------------------------------------------
freq_rel_preterm <- freq_abs_preterm / sum(freq_abs_preterm)
round(freq_rel_preterm, digits = 3)

freq_rel_non_preterm <- freq_abs_non_preterm / sum(freq_abs_non_preterm)
round(freq_rel_non_preterm, digits = 3)

## -----------------------------------------------------------------------------
tab_summary <- cbind(
  freq_abs_preterm, freq_abs_non_preterm,
  freq_rel_preterm, freq_rel_non_preterm
)

colnames(tab_summary) <- c(
  "n_j preterm",
  "n_j non-preterm",
  "f_j preterm",
  "f_j non-preterm"
)

round(tab_summary, 3) # Display of the results

## -----------------------------------------------------------------------------
par(mfrow = c(1, 2)) # Splits the plot into two parts

# First plot, absolute frequencies
hist(dde_non_preterm,
  freq = TRUE,
  breaks = 10, # We use 10 sub-intervals
  # From here on we are only adding aesthetic details
  main = "Non-preterm births",
  xlab = "DDE",
  ylab = "Absolute frequencies"
)

# Second plot, density
hist(dde_non_preterm,
  freq = FALSE, # Frequencies are NOT used
  breaks = 10, # We use 10 sub-intervals
  # From here on we are only adding aesthetic details
  main = "Non-preterm births",
  xlab = "DDE",
  ylab = "Density"
)

## -----------------------------------------------------------------------------
# Definition of UNEQUALLY spaced intervals
breaks <- c(5 * 0:10, 70, 90, 110, 130, 150, 170, 190)

# CORRECT PLOT
hist(dde_non_preterm,
  freq = FALSE,
  breaks = breaks,
  # From here on we are only adding aesthetic details
  main = "CORRECT PLOT", xlab = "DDE", ylab = "Density"
)

# WRONG PLOT
hist(dde_non_preterm,
  freq = TRUE, # Frequencies are used
  breaks = breaks,
  # From here on we are only adding aesthetic details
  main = "WRONG PLOT", xlab = "DDE", ylab = "Absolute frequencies"
)

## -----------------------------------------------------------------------------
nclass.Sturges(dde_non_preterm) # Sturges' rule
nclass.FD(dde_non_preterm) # Freedman and Diaconis' rule

## -----------------------------------------------------------------------------
hist(dde_non_preterm, # Non-preterm births group
  freq = FALSE,
  main = "Non-preterm births"
)

hist(dde_preterm, # Preterm births group
  freq = FALSE,
  main = "Preterm births"
)

## -----------------------------------------------------------------------------
ecdf(dde_non_preterm)

## -----------------------------------------------------------------------------
F_non_preterm <- ecdf(dde_non_preterm)
F_non_preterm(c(20, 40, 60)) # Evaluates the empirical cdf at 20, 40 and 60
sum(dde_non_preterm <= 40) / length(dde_non_preterm) # Alternative "manual" command

## -----------------------------------------------------------------------------
par(mfrow = c(1, 1))
plot(ecdf(dde_non_preterm))

## -----------------------------------------------------------------------------
plot(ecdf(dde_preterm),
  do.points = FALSE, col = "blue",
  main = "Blue: preterm delivery. Red: non-preterm delivery",
  xlab = "DDE",
  ylab = "F(DDE)"
)

plot(ecdf(dde_non_preterm), col = "red", add = TRUE) # Add a second group

## -----------------------------------------------------------------------------
mean(dde_preterm) # Arithmetic mean of DDE for women with preterm delivery
mean(dde_non_preterm) # Arithmetic mean of DDE for women with regular delivery

## -----------------------------------------------------------------------------
n <- length(dde_preterm) # Sample size of dde_preterm (= 361)
sum(dde_preterm) / n # Arithmetic mean of the variable dde_preterm

## -----------------------------------------------------------------------------
median(dde_preterm) # Median of DDE for women with preterm delivery
median(dde_non_preterm) # Median of DDE for women with regular delivery

## -----------------------------------------------------------------------------
F_non_preterm(median(dde_non_preterm))

## -----------------------------------------------------------------------------
x <- c(10, 20, 25, 3.5, 28, 62)
n <- length(x) # Sample size
n # Note that n = 6 is even

x_sort <- sort(x) # Ordered vector of the values of x
x_sort

pos_med_1 <- n / 2 # Element in position n/2
pos_med_2 <- n / 2 + 1 # Element in position n/2+1

(x_sort[pos_med_1] + x_sort[pos_med_2]) / 2 # Median of x

median(x) # Of course, the result must coincide with:

## -----------------------------------------------------------------------------
quantile(dde_preterm, probs = c(0.1, 0.25, 0.75, 0.9), type = 1)
quantile(dde_non_preterm, probs = c(0.1, 0.25, 0.75, 0.9), type = 1)

## -----------------------------------------------------------------------------
min(dde_non_preterm[F_non_preterm(dde_non_preterm) >= 0.25])
min(dde_non_preterm[F_non_preterm(dde_non_preterm) >= 0.75])

## -----------------------------------------------------------------------------
tab <- rbind(
  quantile(dde_preterm, probs = c(0.1, 0.25, 0.5, 0.75, 0.9), type = 1),
  quantile(dde_preterm, probs = c(0.1, 0.25, 0.5, 0.75, 0.9), type = 6),
  quantile(dde_preterm, probs = c(0.1, 0.25, 0.5, 0.75, 0.9), type = 7),
  quantile(dde_preterm, probs = c(0.1, 0.25, 0.5, 0.75, 0.9), type = 9)
)
rownames(tab) <- c(1, 6, 7, 9) # Changes the names of the rows of the table
tab

## -----------------------------------------------------------------------------
summary(dde_preterm)
summary(dde_non_preterm)

## -----------------------------------------------------------------------------
summary(dde)

## -----------------------------------------------------------------------------
boxplot.stats(dde_preterm)

## -----------------------------------------------------------------------------
boxplot(dde_preterm, dde_non_preterm) # Produces the plot
