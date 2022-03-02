#### NonQuestionCode ####
#create a function. The names of the arguments for your function will be in parentheses. Everything in curly brackets will be run each time the function is run.
assert <- function(statement,err.message){
  #if evaluates if a statement is true or false for a single item
  if(statement == FALSE){
    print(err.message)
  }
}


#### End ####

#### Question 3 ####

#read in the data file
#skip the first 3 rows since there is additional column info
#specify the the NA is designated differently
#In class path
#datW <- read.csv("Z:\\students\\bweber\\Data\\bewkes\\bewkes_weather.csv",
                 #na.strings=c("#N/A"), skip=3, header=FALSE)

#Laptop path
datW <- read.csv("C:\\Users\\brian\\OneDrive\\Documents\\GEOG331\\Activity3Files\\bewkes\\bewkes_weather.csv",
                na.strings=c("#N/A"), skip=3, header=FALSE)

#get sensor info from file
# this data table will contain all relevant units
#In class path
#sensorInfo <- read.csv("Z:\\students\\bweber\\Data\\bewkes\\bewkes_weather.csv",
                        # na.strings=c("#N/A"), nrows=2)

# Laptop path
sensorInfo <- read.csv("C:\\Users\\brian\\OneDrive\\Documents\\GEOG331\\Activity3Files\\bewkes\\bewkes_weather.csv",
                       na.strings=c("#N/A"), nrows=2)


#get column names from sensorInfo table
# and set weather station colnames  to be the same
colnames(datW) <-   colnames(sensorInfo)


#### Question 3 End ####

#### Question 4 ####

#use install.packages to install lubridate
#install.packages(c("lubridate"))

library(lubridate)
#convert to standardized format
#date format is m/d/y
dates <- mdy_hm(datW$timestamp, tz= "America/New_York")


#calculate day of year
datW$doy <- yday(dates)
#calculate hour in the day
datW$hour <- hour(dates) + (minute(dates)/60)
#calculate decimal day of year
datW$DD <- datW$doy + (datW$hour/24)


#see how many values have missing data for each sensor observation
#air temperature
length(which(is.na(datW$air.temperature)))

#wind speed
length(which(is.na(datW$wind.speed)))

#precipitation
length(which(is.na(datW$precipitation)))

#soil temperature
length(which(is.na(datW$soil.moisture)))

#soil moisture
length(which(is.na(datW$soil.temp)))

#make a plot for soil moisture with filled in points (using pch)
#line lines
plot(datW$DD, datW$soil.moisture, pch=19, type="b", xlab = "Day of Year",
     ylab="Soil moisture (cm3 water per cm3 soil)")

#make a plot for air temperature with filled in points (using pch)
#line lines
plot(datW$DD, datW$air.temperature, pch=19, type="b", xlab = "Day of Year",
     ylab="Air temperature (degrees C)")

datW$air.tempQ1 <- ifelse(datW$air.temperature < 0, NA, datW$air.temperature)

#check the values at the extreme range of the data
#and throughout the percentiles
quantile(datW$air.tempQ1)

#look at days with really low air temperature
datW[datW$air.tempQ1 < 8,]  

#look at days with really high air temperature
datW[datW$air.tempQ1 > 33,]  

#### Question 4 End ####

#### Question 5 ####
# Create lightscale based on precipitation and lightning activitity
lightscale <- (max(datW$precipitation)/max(datW$lightning.acvitivy)) * datW$lightning.acvitivy

#plot precipitation and lightning strikes on the same plot
#normalize lighting strikes to match precipitation
#make it empty to start and add in features
plot(datW$DD , datW$precipitation, xlab = "Day of Year", ylab = "Precipitation & lightning",
     type="n")

#plot precipitation points only when there is precipitation 
#make the points semi-transparent
points(datW$DD[datW$precipitation > 0], datW$precipitation[datW$precipitation > 0],
       col= rgb(95/255,158/255,160/255,.5), pch=15)        

#plot lightning points only when there is lightning     
points(datW$DD[lightscale > 0], lightscale[lightscale > 0],
       col= "tomato3", pch=19)


#Assert that datW$preciptation and lightscale are the same length (ie. modified equally)
assert(length(datW$precipitation) == length(lightscale), "error: They are not equal sizes")



#### Question 5 End ####

#### Question 6 ####
#filter out storms in wind and air temperature measurements
# filter all values with lightning that coincides with rainfall greater than 2mm or only rainfall over 5 mm.    
#create a new air temp column
datW$air.tempQ2 <- ifelse(datW$precipitation  >= 2 & datW$lightning.acvitivy >0, NA,
                          ifelse(datW$precipitation > 5, NA, datW$air.tempQ1))

#filter out suspect wind speed measurements
#filter all values with lightning that coincides with rainfall greater than 2mm or only rainfall over 5 mm.
#create a new wind speed column
datW$wind.speedQ1 <- ifelse(datW$precipitation  >= 2 & datW$lightning.acvitivy >0, NA,
                            ifelse(datW$precipitation > 5, NA, datW$wind.speed))

#Assert that if wind.speedQ1 and air tempQ2 have been modified equally
assert(length(datW$wind.speedQ1) == length(datW$air.tempQ2), "error: They are not equal sizes")

#make the plot with Wind Speed marked
plot(datW$DD , datW$wind.speedQ1, xlab = "Day of Year", ylab = "Wind Speed",
     type="n")

#plot wind speed points only when there is wind speed 
#make the points semi-transparent
points(datW$DD[datW$wind.speedQ1 > 0], datW$wind.speedQ1[datW$wind.speedQ1 > 0],
       col= rgb(95/255,158/255,160/255,.5), pch=15) 

#plot line based on wind speed points
lines(datW$DD[datW$wind.speedQ1 > 0], datW$wind.speedQ1[datW$wind.speedQ1 > 0],
      col= "chocolate1", pch=15)

#### Question 6 End ####

#### Question 7 ####
#generate plots for Soil Moisture, Soil Temperature, Precipitation, and Air Temperature
par(mfrow=c(2,2))

#Plot Soil Moisture prior to soil data loss on Day 192
plot(datW$DD, datW$soil.moisture, pch = 19, type="b", xlim = c(163,192),
     xlab = "Day of Year", ylab = "Soil Moisture (cm3 water per cm3 soil)")

#Plot Soil Temp prior to soil data loss on Day 192
plot(datW$DD, datW$soil.temp, pch = 19, type="b", xlim = c(163,192),
     xlab = "Day of Year", ylab = "Soil Temperature (C°)")

#Plot Precipitation prior to soil data loss on Day 192
plot(datW$DD, datW$precipitation, pch = 19, type="b", xlim = c(163,192),
     xlab = "Day of Year", ylab = "Precipitation (mm)")

#Plot Air Temperature prior to soil data loss on Day 192
plot(datW$DD, datW$air.temperature, pch = 19, type="b", xlim = c(163,192),
     xlab = "Day of Year", ylab = "Air Temperature (C°)")


#### Question 7 End ####

#### Question 8 ####
# Create observation table with total precipitation
# This data table will store other requested averages
observationTable <- data.frame("Total Precipitation" = round(sum(datW$precipitation, na.rm = TRUE), digits = 3))

# Add avgAirTemp to the data table
observationTable$avgAirTemp <- mean(datW$air.temperature, na.rm = TRUE)
# Add avgWindSpeed to the data table
observationTable$avgWindSpeed <- round(mean(datW$wind.speed, na.rm = TRUE), digits = 2)
# Add avgWindSpeed to the data table
observationTable$avgSoilMoisture <- round(mean(datW$soil.moisture, na.rm = TRUE), digits =  4)
# Add avgSoilMoisture to the data table
observationTable$avgSoilTemp <- round(mean(datW$soil.temp, na.rm = TRUE), digits = 1)
# Add Total Number of observations to the data table
observationTable$NumObservations <- length(datW$solar.radiation)
# Add time period of measurement to the data table
observationTable$DDTimePeriod <- max(datW$DD, na.rm = TRUE)

observationTable

#3 measurements for time
#### Question 8 End ####

#### Question 9 ####
#generate plots for Soil Moisture, Soil Temperature, Precipitation, and Air Temperature
par(mfrow=c(2,2))

#Plot Soil Moisture
plot(datW$DD, datW$soil.moisture, pch = 19, type="b",
     xlab = "Day of Year", ylab = "Soil Moisture (cm3 water per cm3 soil)")

#Plot Soil Temp
plot(datW$DD, datW$soil.temp, pch = 19, type="b",
     xlab = "Day of Year", ylab = "Soil Temperature (C°)")

#Plot Precipitation
plot(datW$DD, datW$precipitation, pch = 19, type="b",
     xlab = "Day of Year", ylab = "Precipitation (mm)")

#Plot Air Temperature
plot(datW$DD, datW$air.temperature, pch = 19, type="b",
     xlab = "Day of Year", ylab = "Air Temperature (C°)")

