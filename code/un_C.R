## -----------------------------------------------------------------------------
getwd() # Identifies the working directory (get working directory)

## -----------------------------------------------------------------------------
# THE PATH VARIABLE MUST BE CHANGED DEPENDING ON WHERE THE .csv FILE IS SAVED
path <- "data/football.csv" # This is the path of the file, relative to getwd()

## -----------------------------------------------------------------------------
#| eval: false
# path <- "https://tommasorigon.github.io/EnvEcoStat/data/football.csv"

## -----------------------------------------------------------------------------
football <- read.table(path, header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
#| eval: false
# football <- read.table("football.csv", header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
dim(football) # Equivalent to c(nrow(football), ncol(football))

## -----------------------------------------------------------------------------
head(football) # Equivalent command: football[1:6, ]

## -----------------------------------------------------------------------------
tail(football) # Equivalent command: football[1895:1900, ]

## -----------------------------------------------------------------------------
colnames(football) # To access the names of the variables

## -----------------------------------------------------------------------------
str(football)

## -----------------------------------------------------------------------------
is.numeric(football$B365H) # Check that it is a variable of type numeric
class(football$B365H)
football$B365H[1:10] # First 10 elements of an R vector

## -----------------------------------------------------------------------------
football$HomeTeam <- factor(football$HomeTeam)
football$AwayTeam <- factor(football$AwayTeam)
football$FTR <- factor(football$FTR)

## -----------------------------------------------------------------------------
football <- read.table(path, header = TRUE, sep = ",", stringsAsFactors = TRUE)

## -----------------------------------------------------------------------------
levels(football$HomeTeam)

## -----------------------------------------------------------------------------
football$FTR[1:10]
levels(football$FTR) <- c("Away", "Draw", "Home") # Rename the categories
football$FTR[1:10]

## -----------------------------------------------------------------------------
football$Draw <- football$FTR # Create a copy of the variable FTR called Draw
levels(football$Draw) <- c("Not_Draw", "Draw", "Not_Draw") # Merging of categories

football$Draw[1:10]

## -----------------------------------------------------------------------------
football$Date <- as.Date(football$Date, format = "%Y-%m-%d")
class(football$Date)
football$Date[1:10]

## -----------------------------------------------------------------------------
min(football$Date) # First match played
max(football$Date) # Last match played

## -----------------------------------------------------------------------------
football[c(1806, 501, 109), ]

## -----------------------------------------------------------------------------
football_draw <- football[football$FTR == "Draw", ]
head(football_draw)

## -----------------------------------------------------------------------------
football_home <- football[football$B365H > 9, ]
football_home

## -----------------------------------------------------------------------------
football[rowSums(is.na(football)) > 0, ] # Identifies the rows with missing values

## -----------------------------------------------------------------------------
football_no_na <- na.omit(football)
dim(football_no_na)

## -----------------------------------------------------------------------------
football_home <- subset(football, subset = B365H > 9)
football_home

## -----------------------------------------------------------------------------
football_B365 <- subset(football, select = c(B365H, B365D, B365A))
head(football_B365)

## -----------------------------------------------------------------------------
str(football)

## -----------------------------------------------------------------------------
# Computation of the overround
football$overround <- 1 / football$B365H + 1 / football$B365D + 1 / football$B365A - 1

# Overround associated with Udinese-Parma of 1 September 2013
subset(football, Date == "2013-09-01" & HomeTeam == "Udinese")

# Minimum and maximum overround
football[which.min(football$overround), ]
football[which.max(football$overround), ]

# The Serie A championship starts at the end of August and ends at the end of May
football2009_2010 <- subset(football, Date >= "2009-08-15" & Date <= "2010-06-15")
football2009_2010[which.max(football2009_2010$overround), ]
