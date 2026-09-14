## -----------------------------------------------------------------------------
getwd() # Identifies the working directory (get working directory)

## -----------------------------------------------------------------------------
# THE PATH VARIABLE MUST BE CHANGED DEPENDING ON WHERE THE .csv FILE IS SAVED
path <- "data/calcio.csv" # This is the path of the file, relative to getwd()

## -----------------------------------------------------------------------------
#| eval: false
# path <- "https://tommasorigon.github.io/EnvEcoStat/data/calcio.csv"

## -----------------------------------------------------------------------------
calcio <- read.table(path, header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
#| eval: false
# calcio <- read.table("calcio.csv", header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
dim(calcio) # Equivalent to c(nrow(calcio), ncol(calcio))

## -----------------------------------------------------------------------------
head(calcio) # Equivalent command: calcio[1:6, ]

## -----------------------------------------------------------------------------
tail(calcio) # Equivalent command: calcio[1895:1900, ]

## -----------------------------------------------------------------------------
colnames(calcio) # To access the names of the variables

## -----------------------------------------------------------------------------
str(calcio)

## -----------------------------------------------------------------------------
is.numeric(calcio$B365H) # Check that it is a variable of type numeric
class(calcio$B365H)
calcio$B365H[1:10] # First 10 elements of an R vector

## -----------------------------------------------------------------------------
calcio$HomeTeam <- factor(calcio$HomeTeam)
calcio$AwayTeam <- factor(calcio$AwayTeam)
calcio$FTR <- factor(calcio$FTR)

## -----------------------------------------------------------------------------
calcio <- read.table(path, header = TRUE, sep = ",", stringsAsFactors = TRUE)

## -----------------------------------------------------------------------------
levels(calcio$HomeTeam)

## -----------------------------------------------------------------------------
calcio$FTR[1:10]
levels(calcio$FTR) <- c("Away", "Draw", "Home") # Rename the categories
calcio$FTR[1:10]

## -----------------------------------------------------------------------------
calcio$Draw <- calcio$FTR # Create a copy of the variable FTR called Draw
levels(calcio$Draw) <- c("Not_Draw", "Draw", "Not_Draw") # Merging of categories

calcio$Draw[1:10]

## -----------------------------------------------------------------------------
calcio$Date <- as.Date(calcio$Date, format = "%Y-%m-%d")
class(calcio$Date)
calcio$Date[1:10]

## -----------------------------------------------------------------------------
min(calcio$Date) # First match played
max(calcio$Date) # Last match played

## -----------------------------------------------------------------------------
calcio[c(1806, 501, 109), ]

## -----------------------------------------------------------------------------
calcio_draw <- calcio[calcio$FTR == "Draw", ]
head(calcio_draw)

## -----------------------------------------------------------------------------
calcio_home <- calcio[calcio$B365H > 9, ]
calcio_home

## -----------------------------------------------------------------------------
calcio[rowSums(is.na(calcio)) > 0, ] # Identifies the rows with missing values

## -----------------------------------------------------------------------------
calcio_no_na <- na.omit(calcio)
dim(calcio_no_na)

## -----------------------------------------------------------------------------
calcio_home <- subset(calcio, subset = B365H > 9)
calcio_home

## -----------------------------------------------------------------------------
calcio_B365 <- subset(calcio, select = c(B365H, B365D, B365A))
head(calcio_B365)

## -----------------------------------------------------------------------------
str(calcio)

## -----------------------------------------------------------------------------
# Computation of the overround
calcio$overround <- 1 / calcio$B365H + 1 / calcio$B365D + 1 / calcio$B365A - 1

# Overround associated with Udinese-Parma of 1 September 2013
subset(calcio, Date == "2013-09-01" & HomeTeam == "Udinese")

# Minimum and maximum overround
calcio[which.min(calcio$overround), ]
calcio[which.max(calcio$overround), ]

# The Serie A championship starts at the end of August and ends at the end of May
calcio2009_2010 <- subset(calcio, Date >= "2009-08-15" & Date <= "2010-06-15")
calcio2009_2010[which.max(calcio2009_2010$overround), ]
