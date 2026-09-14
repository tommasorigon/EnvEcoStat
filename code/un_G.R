## -----------------------------------------------------------------------------
titanic <- read.table("data/titanic.csv",
  header = TRUE, sep = ",", stringsAsFactors = TRUE
)

## -----------------------------------------------------------------------------
#| eval: false
# path <- "https://tommasorigon.github.io/EnvEcoStat/data/titanic.csv"
# titanic <- read.table(path, header = TRUE, sep = ",", stringsAsFactors = TRUE)

## -----------------------------------------------------------------------------
str(titanic)

## -----------------------------------------------------------------------------
summary(titanic)

## -----------------------------------------------------------------------------
freq_abs_class <- table(titanic$class)
freq_rel_class <- freq_abs_class / sum(freq_abs_class)
tab_summary <- cbind(freq_abs_class, freq_rel_class)
tab_summary

## -----------------------------------------------------------------------------
tab <- table(titanic$survived, titanic$class)
tab

## -----------------------------------------------------------------------------
addmargins(tab) # Adds the (absolute) marginal distributions

## -----------------------------------------------------------------------------
tab_rel <- prop.table(tab) # Alternative command: table(tab) / sum(tab)
tab_rel

## -----------------------------------------------------------------------------
addmargins(tab_rel) # Adds the relative marginal distributions

## -----------------------------------------------------------------------------
prop.table(tab, 1)

## -----------------------------------------------------------------------------
prop.table(tab, 2)

## -----------------------------------------------------------------------------
barplot(tab, beside = TRUE, legend.text = TRUE) # beside = TRUE places the bars side by side

## -----------------------------------------------------------------------------
barplot(prop.table(tab, 2),
  beside = FALSE,
  xlab = "Class",
  legend.text = TRUE
) # beside = FALSE stacks the bars.

## -----------------------------------------------------------------------------
library(ggplot2)

## -----------------------------------------------------------------------------
ggplot(data = titanic, aes(x = class, fill = survived)) +
  geom_bar(position = "dodge") +
  theme_bw() +
  theme(legend.position = "top") +
  scale_fill_brewer(palette = "Dark2") +
  ylab("Absolute frequencies")

## -----------------------------------------------------------------------------
ggplot(data = titanic, aes(x = class, fill = survived)) +
  geom_bar(position = "fill") +
  theme_bw() +
  theme(legend.position = "top") +
  scale_fill_brewer(palette = "Dark2") +
  ylab("Relative frequencies")

## -----------------------------------------------------------------------------
chi_squared <- function(x, y) {
  nn <- table(x, y)
  n <- sum(nn)
  ff <- nn / n # Joint relative frequencies
  f_x <- table(x) / n # Marginal relative frequencies of x
  f_y <- table(y) / n # Marginal relative frequencies of y
  S <- 0
  for (i in 1:length(f_x)) {
    for (j in 1:length(f_y)) {
      S <- S + ff[i, j]^2 / (f_x[i] * f_y[j])
    }
  }
  n * (S - 1)
}
chi_squared(titanic$survived, titanic$class)

## -----------------------------------------------------------------------------
chi_squared <- function(x, y) {
  nn <- table(x, y)
  n <- sum(nn)
  ff <- nn / n
  f_x <- apply(ff, 1, sum)
  f_y <- apply(ff, 2, sum)
  f_e <- outer(f_x, f_y) # "Outer" product between vectors
  n * (sum(ff^2 / f_e) - 1)
}
chi_squared(titanic$survived, titanic$class)

## -----------------------------------------------------------------------------
chisq.test(table(titanic$survived, titanic$class))
