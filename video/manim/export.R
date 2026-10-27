# Simulations of Unit I, with the same seeds and the same order as the notes.
# Writes the data used by the Manim scripts.

# A survey on climate change
set.seed(123)
R <- 5000
pi_hat <- rbinom(R, size = 1008, prob = 0.5) / 1008
write.csv(data.frame(pi_hat = pi_hat), "pi_hat.csv", row.names = FALSE)

# Air pollution in a city
mu <- 28
sigma <- 12
k <- mu^2 / sigma^2
lambda <- mu / sigma^2
set.seed(123)
n <- 64
mean(rgamma(n, shape = k, rate = lambda)) # the three campaigns of the notes
mean(rgamma(n, shape = k, rate = lambda))
mean(rgamma(n, shape = k, rate = lambda))

Y <- matrix(NA, R, n) # the n days of every campaign, shown in the video
y_bar <- rep(NA, R)
for (r in 1:R) {
  y <- rgamma(n, shape = k, rate = lambda)
  Y[r, ] <- y
  y_bar[r] <- mean(y)
}
write.csv(data.frame(y_bar = y_bar), "y_bar.csv", row.names = FALSE)
con <- gzfile("campaigns.csv.gz", "w")
write.csv(round(Y, 3), con, row.names = FALSE)
close(con)

# Histogram breaks, as in hist(..., breaks = 30)
b1 <- hist(pi_hat, breaks = 30, plot = FALSE)$breaks
b2 <- hist(y_bar, breaks = 30, plot = FALSE)$breaks
cat(paste0('{"b1":[', paste(b1, collapse = ","), '],"b2":[', paste(b2, collapse = ","), "]}"),
    file = "breaks.json")

c(mean(pi_hat >= 0.52), mean(y_bar), sd(y_bar), mean(y_bar > 31))
