## -----------------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Crabs.dat"
Crabs <- read.table(path, header = TRUE)
str(Crabs)

## -----------------------------------------------------------------------------
y <- Crabs$width
n <- length(y)
alpha <- 0.05 # 95% confidence level
t_quant <- qt(1 - alpha / 2, df = n - 1) # Right-tail probability alpha / 2

c(mean(y) - t_quant * sd(y) / sqrt(n), mean(y) + t_quant * sd(y) / sqrt(n))

## -----------------------------------------------------------------------------
t.test(y, conf.level = 0.95)

## -----------------------------------------------------------------------------
pi_hat <- mean(Crabs$y) # Sample proportion
c(n * pi_hat, n * (1 - pi_hat)) # Both larger than 10

z_quant <- qnorm(1 - alpha / 2)
se_hat <- sqrt(pi_hat * (1 - pi_hat) / n) # Estimated standard error
c(pi_hat - z_quant * se_hat, pi_hat + z_quant * se_hat)

## -----------------------------------------------------------------------------
mu <- 28
sigma <- 12
k <- mu^2 / sigma^2
lambda <- mu / sigma^2

set.seed(123)
R <- 1000
covers <- rep(NA, R)

for (r in 1:R) {
  y_sim <- rgamma(64, shape = k, rate = lambda) # A new campaign
  ci <- t.test(y_sim)$conf.int # Its 95% confidence interval
  covers[r] <- (ci[1] < mu) & (mu < ci[2]) # TRUE if the interval contains mu
}

mean(covers) # Proportion of intervals that contain mu

## -----------------------------------------------------------------------------
pi_hat <- 524 / 1008
pi_0 <- 0.5
z <- (pi_hat - pi_0) / sqrt(pi_0 * (1 - pi_0) / 1008) # Observed test statistic
z
2 * (1 - pnorm(abs(z))) # Two-sided P-value

## -----------------------------------------------------------------------------
prop.test(524, 1008, p = 0.5, correct = FALSE)

## -----------------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Anorexia.dat"
Anorexia <- read.table(path, header = TRUE)
change <- Anorexia$after - Anorexia$before # Weight change
change_cb <- change[Anorexia$therapy == "cb"] # Cognitive behavioural therapy

## -----------------------------------------------------------------------------
n <- length(change_cb)
t_obs <- (mean(change_cb) - 0) / (sd(change_cb) / sqrt(n)) # Observed test statistic
2 * (1 - pt(abs(t_obs), df = n - 1)) # Two-sided P-value

## -----------------------------------------------------------------------------
t.test(change_cb, mu = 0)

## -----------------------------------------------------------------------------
boxplot(width ~ y, data = Crabs, xlab = "Satellites (0 = no, 1 = yes)", ylab = "Width (cm)")

## -----------------------------------------------------------------------------
t.test(width ~ y, data = Crabs, var.equal = TRUE)
