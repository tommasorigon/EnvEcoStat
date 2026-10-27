# Unit J - What does 95% confidence mean? Same seed and code as the notes.
n <- 173 # nrow(Crabs)
alpha <- 0.05
z_quant <- qnorm(1 - alpha / 2)

set.seed(123)
pi_true <- 0.65
R <- 1000
pi_hat_sim <- rbinom(R, size = n, prob = pi_true) / n
se_sim <- sqrt(pi_hat_sim * (1 - pi_hat_sim) / n)
lower <- pi_hat_sim - z_quant * se_sim
upper <- pi_hat_sim + z_quant * se_sim
print(head(cbind(lower, upper)))
print(mean(lower < pi_true & pi_true < upper))
write.csv(data.frame(pi_hat = pi_hat_sim, lower = lower, upper = upper), "intervals.csv", row.names = FALSE)
