## -----------------------------------------------------------------------------
n <- 10 # Number of trials
p <- 0.6 # Probability of success
k <- 4 # Number of successes

choose(n, k) * p^k * (1 - p)^(n - k)

## -----------------------------------------------------------------------------
dbinom(k, size = n, prob = p)

## -----------------------------------------------------------------------------
sum(dbinom(0:5, size = n, prob = p))
pbinom(5, size = n, prob = p) # Specific R function

## -----------------------------------------------------------------------------
1 - pbinom(5, size = n, prob = p)
pbinom(5, size = n, prob = p, lower.tail = FALSE)

## -----------------------------------------------------------------------------
n * p # Expected value obtained through analytical computations
sum(0:n * dbinom(0:n, size = n, prob = 0.6)) # Numerical computation

## -----------------------------------------------------------------------------
sum(sqrt(0:n) * dbinom(0:n, size = n, prob = 0.6))

## -----------------------------------------------------------------------------
qbinom(0.25, size = 10, prob = 0.6) # First quartile

## -----------------------------------------------------------------------------
pbinom(4, size = 10, prob = 0.6) # The value is smaller than 0.25
pbinom(5, size = 10, prob = 0.6) # The value is larger than 0.25

## -----------------------------------------------------------------------------
kk <- 0:n
prob <- dbinom(0:n, size = n, prob = p)
plot(kk, prob, type = "h", main = "Bin(10,0.6)", xlab = "k", ylab = "P(X=k)")

## -----------------------------------------------------------------------------
x <- 1 # Point at which to compute f(x)
mu <- 3 # Mean
sigma2 <- 10 # Variance

1 / sqrt(2 * pi * sigma2) * exp(-1 / (2 * sigma2) * (x - mu)^2)
dnorm(x, mean = 3, sd = sqrt(sigma2))

## -----------------------------------------------------------------------------
integrate(dnorm, lower = -1, upper = 1)

## -----------------------------------------------------------------------------
pnorm(1) - pnorm(-1)

## -----------------------------------------------------------------------------
qnorm(0.75)

## -----------------------------------------------------------------------------
pnorm(qnorm(0.75))

## -----------------------------------------------------------------------------
curve(dnorm(x, mean = 0, sd = 1), from = -3, to = 3, ylab = "f(x)", main = "N(0,1)")

## -----------------------------------------------------------------------------
R <- 5
rnorm(R, mean = 0, sd = 1)

## -----------------------------------------------------------------------------
dice <- 1:6

## -----------------------------------------------------------------------------
set.seed(123) # R command to fix the "seed"
sample(x = dice, size = 1) # size = 1 implies that a single die is rolled

## -----------------------------------------------------------------------------
set.seed(140)
n <- 10
# replace = TRUE implies that the die is rolled 10 times
sim <- sample(dice, size = n, replace = TRUE)
sim

## -----------------------------------------------------------------------------
sample(1:90, size = 5, replace = FALSE)

## -----------------------------------------------------------------------------
sample(dice)

## -----------------------------------------------------------------------------
set.seed(321)
n <- 1000
size <- 10
prob <- 0.3

y <- rbinom(n, size = size, prob = prob)
freq_rel <- table(factor(y, levels = 0:size)) / n

plot(0:size, dbinom(0:size, size = size, prob = prob),
  type = "h", lwd = 2,
  xlab = "k", ylab = "Probability", main = "Bin(10, 0.3)"
)
points(0:size, freq_rel, col = "red", pch = 16) # Relative frequencies

## -----------------------------------------------------------------------------
# Largest discrepancy between theoretical and empirical
max(abs(dbinom(0:size, size = size, prob = prob) - as.numeric(freq_rel)))

## -----------------------------------------------------------------------------
set.seed(123)
n <- 1000
lambda <- 0.5

x <- rexp(n, rate = lambda)

hist(x, freq = FALSE, breaks = 30, main = "Exp(0.5)", xlab = "x")
curve(dexp(x, rate = lambda), add = TRUE, col = "red", lwd = 2)

## -----------------------------------------------------------------------------
plot(ecdf(x), do.points = FALSE, main = "Exp(0.5)", xlab = "x", ylab = "F(x)")
curve(pexp(x, rate = lambda), add = TRUE, col = "red", lwd = 2)

## -----------------------------------------------------------------------------
p <- c(0.1, 0.25, 0.5, 0.75, 0.9)
rbind(
  theoretical = qexp(p, rate = lambda),
  empirical = quantile(x, probs = p)
)

## -----------------------------------------------------------------------------
#| fig-width: 12
#| fig-height: 4
set.seed(1)
par(mfrow = c(1, 3))
for (nn in c(20, 200, 20000)) {
  xx <- rexp(nn, rate = lambda)
  hist(xx, freq = FALSE, breaks = "FD", main = paste("n =", nn), xlab = "x")
  curve(dexp(x, rate = lambda), add = TRUE, col = "red", lwd = 2)
}
par(mfrow = c(1, 1))
