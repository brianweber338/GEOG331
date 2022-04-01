library(dplyr)


#### Data Read In ####

# Read in Air Temperature data
dgAirTemp <- read.csv("C:\\Users\\brian\\OneDrive\\Documents\\GEOG331\\Project Data\\data\\dg_air_temperature.csv",
                      stringsAsFactors = T)
# Adds dataF and Month Columns to assist in Sorting by Season
dgAirTemp$dateF <- as.Date(dgAirTemp$timestamp, "%Y-%m-%d")
dgAirTemp$month <- as.numeric(format(dgAirTemp$dateF,"%m"))


# Read in Relative Humidity data
dgRelativeHumid <- read.csv("C:\\Users\\brian\\OneDrive\\Documents\\GEOG331\\Project Data\\data\\dg_relative_humidity.csv",
                            stringsAsFactors = T)
# Adds dataF and Month Columns to assist in Sorting by Season
dgRelativeHumid$dateF <- as.Date(dgRelativeHumid$timestamp, "%Y-%m-%d")
dgRelativeHumid$month <- as.numeric(format(dgRelativeHumid$dateF,"%m"))


# Read in PAR data
dgPAR <- read.csv("C:\\Users\\brian\\OneDrive\\Documents\\GEOG331\\Project Data\\data\\dg_par.csv",
                  stringsAsFactors = T)
# Adds dataF and Month Columns to assist in Sorting by Season
dgPAR$dateF <- as.Date(dgPAR$timestamp, "%Y-%m-%d")
dgPAR$month <- as.numeric(format(dgPAR$dateF,"%m"))


# Read in Soil Temperature data
dgSoilTemp <- read.csv("C:\\Users\\brian\\OneDrive\\Documents\\GEOG331\\Project Data\\data\\dg_soil_temperature.csv",
                       stringsAsFactors = T)
# Adds dataF and Month Columns to assist in Sorting by Season
dgSoilTemp$dateF <- as.Date(dgSoilTemp$timestamp, "%Y-%m-%d")
dgSoilTemp$month <- as.numeric(format(dgSoilTemp$dateF,"%m"))


# Read in Soil Moisture data
dgSoilMoist <- read.csv("C:\\Users\\brian\\OneDrive\\Documents\\GEOG331\\Project Data\\data\\dg_soil_moisture.csv",
                        stringsAsFactors = T)
# Adds dataF and Month Columns to assist in Sorting by Season
dgSoilMoist$dateF <- as.Date(dgSoilMoist$timestamp, "%Y-%m-%d")
dgSoilMoist$month <- as.numeric(format(dgSoilMoist$dateF,"%m"))


#### End Data Read in ####


#### Create Summer Data Tables ####

# Stores all Air Temperature data from May 1 to September 30
SummerAirTemp <- rbind(subset(dgAirTemp, dgAirTemp$month > "4"), subset(dgAirTemp, dgAirTemp$month < "10"))
# Sorts winterAirTemp based on year and doy
SummerAirTemp <- SummerAirTemp %>% arrange(year, doy)

# Stores all Relative Humidity data from May 1 to September 30
SummerRelativeHumid <- rbind(subset(dgRelativeHumid, dgRelativeHumid$month > "4"), 
                             subset(dgRelativeHumid, dgRelativeHumid$month < "10"))
# Sorts winterRelativeHumid based on year and doy
SummerRelativeHumid <- SummerRelativeHumid %>% arrange(year, doy)

# Stores all PAR data from May 1 to September 30
SummerPAR <- rbind(subset(dgPAR, dgPAR$month > "4"), subset(dgPAR, dgPAR$month < "10"))
# Sorts winterPAR based on year and doy
SummerPAR <- SummerPAR %>% arrange(year, doy)

# Stores all Soil Temperature data from May 1 to September 30
SummerSoilTemp <- rbind(subset(dgSoilTemp, dgSoilTemp$month > "4"), subset(dgSoilTemp, dgSoilTemp$month < "10"))
# Sorts winterSoilTemp based on year and doy
SummerSoilTemp <- SummerSoilTemp %>% arrange(year, doy)

# Stores all Soil Moisture data from May 1 to September 30
SummerSoilMoist <- rbind(subset(dgSoilMoist, dgSoilMoist$month > "4"), subset(dgSoilMoist, dgSoilMoist$month < "10"))
# Sorts winterSoilMoist based on year and doy
SummerSoilMoist <- SummerSoilMoist %>% arrange(year, doy)

#### End Create Summer Data Tables ####

# if the day changes, added summed mean to new data table for that day
for (i in 1:nrow(SummerAirTemp)){
  
}