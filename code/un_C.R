## -----------------------------------------------------------------------------
getwd() # Identifies the working directory (get working directory)

## -----------------------------------------------------------------------------
# THE PATH VARIABLE MUST BE CHANGED DEPENDING ON WHERE THE .csv FILE IS SAVED
path <- "data/airquality.csv" # This is the path of the file, relative to getwd()

## -----------------------------------------------------------------------------
#| eval: false
# path <- "https://tommasorigon.github.io/EnvEcoStat/data/airquality.csv"

## -----------------------------------------------------------------------------
airquality <- read.table(path, header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
#| eval: false
# airquality <- read.table("airquality.csv", header = TRUE, sep = ",")

## -----------------------------------------------------------------------------
dim(airquality) # Equivalent to c(nrow(airquality), ncol(airquality))

## -----------------------------------------------------------------------------
head(airquality) # Equivalent command: airquality[1:6, ]

## -----------------------------------------------------------------------------
tail(airquality) # Equivalent command: airquality[148:153, ]

## -----------------------------------------------------------------------------
colnames(airquality) # To access the names of the variables

## -----------------------------------------------------------------------------
str(airquality)

## -----------------------------------------------------------------------------
is.numeric(airquality$Wind) # Check that it is a variable of type numeric
class(airquality$Wind)
airquality$Wind[1:10] # First 10 elements of an R vector

## -----------------------------------------------------------------------------
airquality$TempC <- (airquality$Temp - 32) * 5 / 9

head(airquality[, c("Temp", "TempC")]) # The two scales side by side

## -----------------------------------------------------------------------------
range(airquality$Temp) # In degrees Fahrenheit
range(airquality$TempC) # In degrees Celsius

## -----------------------------------------------------------------------------
dates <- paste(1973, airquality$Month, airquality$Day, sep = "-")
dates[1:3] # Character strings of the form "1973-5-1"

airquality$Date <- as.Date(dates, format = "%Y-%m-%d")
class(airquality$Date)
airquality$Date[1:10]

## -----------------------------------------------------------------------------
min(airquality$Date) # First day of the series
max(airquality$Date) # Last day of the series

## -----------------------------------------------------------------------------
airquality$Month <- factor(airquality$Month)
class(airquality$Month)

## -----------------------------------------------------------------------------
levels(airquality$Month)
table(airquality$Month) # Number of days observed in each month

## -----------------------------------------------------------------------------
airquality$Month[1:10]
levels(airquality$Month) <- c("May", "June", "July", "August", "September")
airquality$Month[1:10]

## -----------------------------------------------------------------------------
airquality$Season <- airquality$Month # Create a copy of Month called Season
# June, July and August are the peak months for ozone: merge them
levels(airquality$Season) <- c("Off-peak", "Peak", "Peak", "Peak", "Off-peak")

table(airquality$Season)

## -----------------------------------------------------------------------------
airquality[c(120, 62, 9), ]

## -----------------------------------------------------------------------------
airquality_hot <- airquality[airquality$Temp > 90, ]
dim(airquality_hot)
head(airquality_hot)

## -----------------------------------------------------------------------------
airquality_ozone <- airquality[airquality$Ozone > 100, ]
dim(airquality_ozone)
head(airquality_ozone)

## -----------------------------------------------------------------------------
sum(is.na(airquality$Ozone)) # How many days lack the ozone measurement
colSums(is.na(airquality)) # The same count, variable by variable

## -----------------------------------------------------------------------------
sum(rowSums(is.na(airquality)) > 0) # Number of incomplete days

## -----------------------------------------------------------------------------
airquality_no_na <- na.omit(airquality)
dim(airquality_no_na)

## -----------------------------------------------------------------------------
airquality_ozone <- subset(airquality, subset = Ozone > 100)
airquality_ozone

## -----------------------------------------------------------------------------
airquality_pollution <- subset(airquality, select = c(Date, Ozone, Temp, Wind))
head(airquality_pollution)

## -----------------------------------------------------------------------------
subset(airquality, subset = Ozone > 100, select = c(Date, Ozone, Temp))

## -----------------------------------------------------------------------------
str(airquality)

## -----------------------------------------------------------------------------
# Day of the maximum ozone concentration, and of the maximum temperature
airquality[which.max(airquality$Ozone), ]
airquality[which.max(airquality$Temp), ]

# Missing ozone measurements, month by month
table(airquality$Month[is.na(airquality$Ozone)])

# Average ozone concentration in each month
tapply(airquality$Ozone, airquality$Month, mean, na.rm = TRUE)

# Windy days and average ozone concentration
airquality$Windy <- factor(airquality$Wind > median(airquality$Wind),
  levels = c(FALSE, TRUE), labels = c("Calm", "Windy")
)
tapply(airquality$Ozone, airquality$Windy, mean, na.rm = TRUE)
