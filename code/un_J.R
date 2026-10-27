## -----------------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Crabs.dat"
Crabs <- read.table(path, header = TRUE)
str(Crabs)

## -----------------------------------------------------------------------------
n <- nrow(Crabs) # Sample size
pi_hat <- mean(Crabs$y) # Sample proportion
c(n * pi_hat, n * (1 - pi_hat)) # Both larger than 10

alpha <- 0.05 # 95% confidence level
z_quant <- qnorm(1 - alpha / 2)
se_hat <- sqrt(pi_hat * (1 - pi_hat) / n) # Estimated standard error
c(pi_hat - z_quant * se_hat, pi_hat + z_quant * se_hat)

## -----------------------------------------------------------------------------
set.seed(123)
pi_true <- 0.65
R <- 1000
pi_hat_sim <- rbinom(R, size = n, prob = pi_true) / n # R sample proportions
se_sim <- sqrt(pi_hat_sim * (1 - pi_hat_sim) / n)
lower <- pi_hat_sim - z_quant * se_sim # R lower endpoints
upper <- pi_hat_sim + z_quant * se_sim # R upper endpoints

head(cbind(lower, upper)) # The first intervals
mean(lower < pi_true & pi_true < upper) # Proportion of intervals containing pi

## -----------------------------------------------------------------------------
curve(dnorm(x), from = -4, to = 4, ylab = "Density") # Standard normal
curve(dt(x, df = 3), add = TRUE, col = "red") # t with 3 degrees of freedom
curve(dt(x, df = 30), add = TRUE, col = "blue") # t with 30 degrees of freedom

## -----------------------------------------------------------------------------
y <- Crabs$width
t_quant <- qt(1 - alpha / 2, df = n - 1) # Right-tail probability alpha / 2
c(mean(y) - t_quant * sd(y) / sqrt(n), mean(y) + t_quant * sd(y) / sqrt(n))

## -----------------------------------------------------------------------------
t.test(y, conf.level = 0.95)

## -----------------------------------------------------------------------------
path <- "https://stat4ds.rwth-aachen.de/data/Anorexia.dat"
Anorexia <- read.table(path, header = TRUE)
change <- Anorexia$after - Anorexia$before # Weight change
change_cb <- change[Anorexia$therapy == "cb"] # Cognitive behavioural therapy

## -----------------------------------------------------------------------------
n_cb <- length(change_cb)
t_obs <- (mean(change_cb) - 0) / (sd(change_cb) / sqrt(n_cb)) # Observed test statistic
t_obs
qt(1 - 0.05 / 2, df = n_cb - 1) # Critical value, alpha = 0.05
2 * (1 - pt(abs(t_obs), df = n_cb - 1)) # Two-sided P-value

## -----------------------------------------------------------------------------
t.test(change_cb, mu = 0)

## -----------------------------------------------------------------------------
pi_hat <- 524 / 1008
pi_0 <- 0.5
z <- (pi_hat - pi_0) / sqrt(pi_0 * (1 - pi_0) / 1008) # Observed test statistic
z
2 * (1 - pnorm(abs(z))) # Two-sided P-value

## -----------------------------------------------------------------------------
prop.test(524, 1008, p = 0.5, correct = FALSE)

## -----------------------------------------------------------------------------
1 - pnorm(z) # One-sided P-value

## -----------------------------------------------------------------------------
boxplot(width ~ y, data = Crabs, xlab = "Satellites (0 = no, 1 = yes)", ylab = "Width (cm)")

## -----------------------------------------------------------------------------
t.test(width ~ y, data = Crabs, var.equal = TRUE)
