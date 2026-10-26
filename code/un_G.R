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
