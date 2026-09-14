## -----------------------------------------------------------------------------
hemoglobin <- read.table("data/hemoglobin.csv",
  header = TRUE, sep = ",", stringsAsFactors = TRUE
)

## -----------------------------------------------------------------------------
#| eval: false
# path <- "https://tommasorigon.github.io/EnvEcoStat/data/hemoglobin.csv"
# hemoglobin <- read.table(path, header = TRUE, sep = ",", stringsAsFactors = TRUE)

## -----------------------------------------------------------------------------
str(hemoglobin)

## -----------------------------------------------------------------------------
hemo_A <- hemoglobin$hemoglobin[hemoglobin$method == "A"] # Group A
hemo_B <- hemoglobin$hemoglobin[hemoglobin$method == "B"] # Group B

summary(hemo_A)
summary(hemo_B)

## -----------------------------------------------------------------------------
boxplot(hemoglobin$hemoglobin ~ hemoglobin$method,
  ylab = "Haemoglobin",
  xlab = "Method"
)

## -----------------------------------------------------------------------------
mean((hemo_A - mean(hemo_A))^2) # Variance of group A
mean((hemo_B - mean(hemo_B))^2) # Variance of group B

mean(hemo_A^2) - mean(hemo_A)^2 # Variance of group A, alternative formula
mean(hemo_B^2) - mean(hemo_B)^2 # Variance of group B, alternative formula

## -----------------------------------------------------------------------------
my_var <- function(x) {
  mean(x^2) - mean(x)^2
}

my_var(hemo_A)
my_var(hemo_B)

## -----------------------------------------------------------------------------
var(hemo_A)
var(hemo_B)

## -----------------------------------------------------------------------------
my_sd <- function(x) {
  sqrt(my_var(x))
}

my_sd(hemo_A)
my_sd(hemo_B)

sd(hemo_A)
sd(hemo_B)

## -----------------------------------------------------------------------------
max(hemo_A) - min(hemo_A)
max(hemo_B) - min(hemo_B)

diff(range(hemo_A))
diff(range(hemo_B))

## -----------------------------------------------------------------------------
interquartile_range <- function(x) {
  diff(quantile(x, probs = c(0.25, 0.75)))
}

interquartile_range(hemo_A)
interquartile_range(hemo_B)

## -----------------------------------------------------------------------------
MAD <- function(x) {
  median(abs(x - median(x)))
}

## -----------------------------------------------------------------------------
MAD(hemo_A)
MAD(hemo_B)

## -----------------------------------------------------------------------------
tapply(hemoglobin$hemoglobin, hemoglobin$method, mean)
with(hemoglobin, tapply(hemoglobin, method, mean)) # Even more compactly

## -----------------------------------------------------------------------------
tab <- rbind(
  with(hemoglobin, tapply(hemoglobin, method, my_var)),
  with(hemoglobin, tapply(hemoglobin, method, my_sd)),
  with(hemoglobin, tapply(hemoglobin, method, interquartile_range)),
  with(hemoglobin, tapply(hemoglobin, method, MAD))
)
rownames(tab) <- c("Variance", "Standard deviation", "Interquartile range", "MAD")
tab

## -----------------------------------------------------------------------------
# First possible implementation
asym <- function(x) {
  sdev <- sqrt(mean(x^2) - mean(x)^2)
  mean((x - mean(x))^3) / sdev^3
}

# (Slightly) alternative implementation
asym <- function(x) {
  sdev <- sqrt(mean(x^2) - mean(x)^2)
  z <- (x - mean(x)) / sdev
  mean(z^3)
}

asym(hemo_A)
