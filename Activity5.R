#load in lubridate
library(lubridate)

#read in streamflow data (In Class Path)
#datH <- read.csv("Z:\\data\\streamflow\\stream_flow_data.csv",
                 na.strings = c("Eqp"))

#read in streamflow data (Home Path)
datH <- read.csv("C:\\Users\\brian\\OneDrive\\Documents\\GEOG331\\Activity5Files\\stream_flow_data.csv",
                na.strings = c("Eqp"))
head(datH)

#read in precipitation data (In class Path)
#hourly precipitation is in mm
#datP <- read.csv("Z:\\data\\streamflow\\2049867.csv")

# read in precipitation data (Home Path)
datP <- read.csv("C:\\Users\\brian\\OneDrive\\Documents\\GEOG331\\Activity5Files\\2049867.csv")
head(datP)

#only use most reliable measurements
datD <- datH[datH$discharge.flag == "A",]

#### define time for streamflow #####
#convert date and time
datesD <- as.Date(datD$date, "%m/%d/%Y")
#get day of year
datD$doy <- yday(datesD)
#get month of year
datD$month <- month(datesD)
#calculate year
datD$year <- year(datesD)
#define time
timesD <- hm(datD$time)

#### define time for precipitation #####    
dateP <- ymd_hm(datP$DATE)
#get day of year
datP$doy <- yday(dateP)
#get month of year
datP$month <- month(dateP)
#get year 
datP$year <- year(dateP)

#### get decimal formats #####
#convert time from a string to a more usable format
#with a decimal hour
datD$hour <- hour(timesD ) + (minute(timesD )/60)
#get full decimal time
datD$decDay <- datD$doy + (datD$hour/24)
#calculate a decimal year, but account for leap year
datD$decYear <- ifelse(leap_year(datD$year),datD$year + (datD$decDay/366),
                       datD$year + (datD$decDay/365))
#calculate times for datP                       
datP$hour <- hour(dateP ) + (minute(dateP )/60)
#get full decimal time
datP$decDay <- datP$doy + (datP$hour/24)
#calculate a decimal year, but account for leap year
datP$decYear <- ifelse(leap_year(datP$year),datP$year + (datP$decDay/366),
                       datP$year + (datP$decDay/365))          




#### Question 3 ####
#plot discharge
dev.new(width=8,height=8)
plot(datD$decYear, datD$discharge, type="l", xlab="Year", 
     ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")))

#### Question 4 ####


#### Question 5 ####
#basic formatting
aveF <- aggregate(datD$discharge, by=list(datD$doy), FUN="mean")
colnames(aveF) <- c("doy","dailyAve")
sdF <- aggregate(datD$discharge, by=list(datD$doy), FUN="sd")
colnames(sdF) <- c("doy","dailySD")

#start new plot
dev.new(width=8,height=8)
#bigger margins
par(mai=c(1,1,1,1))
#make plot
plot(aveF$doy,aveF$dailyAve, 
     type="l", 
     xlab="Year", 
     ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")),
     lwd=2,
     ylim=c(0,90),
     xaxs="i", yaxs ="i",#remove gaps from axes
     axes=FALSE)#no axes
polygon(c(aveF$doy, rev(aveF$doy)),#x coordinates
        c(aveF$dailyAve-sdF$dailySD,rev(aveF$dailyAve+sdF$dailySD)),#ycoord
        col=rgb(0.392, 0.584, 0.929,.2), #color that is semi-transparent
        border=NA#no border
)
# Adds 2017 line
lines(datD$discharge[datD$year == "2017"],
      col= "red", pch=15)

axis(1, seq(15,345, by=30), #tick intervals
     lab=seq(15,345, by=30)) #tick labels
axis(2, seq(0,80, by=20),
     seq(0,80, by=20),
     las = 2)#show ticks at 90 degree angle
legend("topright", c("mean","1 standard deviation", "2017 Streamflow"), #legend items
       lwd=c(2,NA),#lines
       col=c("black",rgb(0.392, 0.584, 0.929,.2), "red"),#colors
       pch=c(NA,15),#symbols
       bty="n")#no legend border

#### Question 7 ####

#load dplyr
library(dplyr)

# Categorize unique date
datP$new.date <-  paste(yday(dateP), year(dateP))
# Sum of hours across each unique date
full <- summarise(group_by(datP, new.date), sum(hour))
colnames(full) <- c("id", "HR")

# join the sum of hours back into the data
datP <- left_join(datP, full, by=c("new.date"="id"))

# categorize datP based on if there is a full day of precipitation data
# only days with a measurement every hour should be selected
datP$fullPrecip <- ifelse(datP$HR == sum(c(0:23)), "full", "not full")

# categorize unique date to match unique dates in datP
datD$new.date <- paste(yday(datesD), year(datesD))
# categorize unique dates to be used for x-axis
datD$new.date1 <- as.numeric(paste(year(datesD), yday(datesD), sep = "."))

# join the two datasets based on new.date
datD2 <- left_join(datD, datP, by="new.date")

# plot the discharge, days with full precipitation measures are colored green
# this code works, it just takes a bit to run
plot(datD2$new.date1, datD2$discharge, main = "Precipitation Measurements by Day Over All Recorded Years",
     ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")), 
     xlab = "Year")
points(datD2$new.date1[datD2$fullPrecip=="full"], datD2$discharge[datD2$fullPrecip=="full"], col="green")




#### Question 8 ####
#subsest discharge and precipitation within range of interest
hydroD <- datD[datD$doy >= 248 & datD$doy < 250 & datD$year == 2011,]
hydroP <- datP[datP$doy >= 248 & datP$doy < 250 & datP$year == 2011,]

#get minimum and maximum range of discharge to plot
#go outside of the range so that it's easy to see high/low values
#floor rounds down the integer
yl <- floor(min(hydroD$discharge))-1
#ceiling rounds up to the integer
yh <- ceiling(max(hydroD$discharge))+1
#minimum and maximum range of precipitation to plot
pl <- 0
pm <-  ceiling(max(hydroP$HPCP))+.5
#scale precipitation to fit on the 
hydroP$pscale <- (((yh-yl)/(pm-pl)) * hydroP$HPCP) + yl

par(mai=c(1,1,1,1))
#make plot of discharge
plot(hydroD$decDay,
     hydroD$discharge, 
     type="l", 
     ylim=c(yl,yh), 
     lwd=2,
     xlab="Day of year", 
     ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")))
#add bars to indicate precipitation 
for(i in 1:nrow(hydroP)){
  polygon(c(hydroP$decDay[i]-0.017,hydroP$decDay[i]-0.017,
            hydroP$decDay[i]+0.017,hydroP$decDay[i]+0.017),
          c(yl,hydroP$pscale[i],hydroP$pscale[i],yl),
          col=rgb(0.392, 0.584, 0.929,.2), border=NA)
}


#My work
#subsest discharge and precipitation within range of interest
hydroD <- datD[datD$doy >= 356 & datD$doy < 358 & datD$year == 2012,]
hydroP <- datP[datP$doy >= 356 & datP$doy < 358 & datP$year == 2012,]

#get minimum and maximum range of discharge to plot
#go outside of the range so that it's easy to see high/low values
#floor rounds down the integer
yl <- floor(min(hydroD$discharge))-1
#ceiling rounds up to the integer
yh <- ceiling(max(hydroD$discharge))+1
#minimum and maximum range of precipitation to plot
pl <- 0
pm <-  ceiling(max(hydroP$HPCP))+.5
#scale precipitation to fit on the 
hydroP$pscale <- (((yh-yl)/(pm-pl)) * hydroP$HPCP) + yl

par(mai=c(1,1,1,1))
#make plot of discharge
plot(hydroD$decDay,
     hydroD$discharge, 
     type="l", 
     ylim=c(yl,yh), 
     lwd=2,
     xlab="Day of year", 
     ylab=expression(paste("Discharge ft"^"3 ","sec"^"-1")))
#add bars to indicate precipitation 
for(i in 1:nrow(hydroP)){
  polygon(c(hydroP$decDay[i]-0.017,hydroP$decDay[i]-0.017,
            hydroP$decDay[i]+0.017,hydroP$decDay[i]+0.017),
          c(yl,hydroP$pscale[i],hydroP$pscale[i],yl),
          col=rgb(0.392, 0.584, 0.929,.2), border=NA)
}





#### Question 9 ####
library(ggplot2)
#specify year as a factor
datD$yearPlot <- as.factor(datD$year)
#make a boxplot
ggplot(data= datD, aes(yearPlot,discharge)) + 
  geom_boxplot()

#make a violin plot
ggplot(data= datD, aes(yearPlot,discharge)) + 
  geom_violin()



#isolate 2016 and 2017 data into two separate data frames
only16 <- data.frame(datD$discharge[datD$year==2016],
                     datD$doy[datD$year==2016], datD$year[datD$year==2016],
                     datD$month[datD$year==2016])
colnames(only16) <- c("discharge", "doy", "year", "month")

only17 <- data.frame(datD$discharge[datD$year==2017],
                     datD$doy[datD$year==2017], datD$year[datD$year==2017],
                     datD$month[datD$year==2017])
colnames(only17) <- c("discharge", "doy", "year", "month")

#classify seasons using ifelse statements
only16$season <- ifelse(only16$doy < 32, "Winter",
                        ifelse(only16$doy < 153, "Spring",
                               ifelse(only16$doy < 245, "Summer",
                                      ifelse(only16$doy < 336, "Fall", "Winter"))))

only17$season <- ifelse(only17$doy < 32, "Winter",
                        ifelse(only17$doy < 153, "Spring",
                               ifelse(only17$doy < 245, "Summer",
                                      ifelse(only17$doy < 336, "Fall", "Winter"))))
#Make a violin plot of only16
ggplot(data = only16, aes(x=season, y = discharge, fill = season)) +
  geom_violin() +
  xlab("Seasons") +
  ylab(expression(paste("Discharge ft"^"3 ","sec"^"-1"))) +
  ggtitle("2016 Stream Discharge by Season") +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none")
  
#Make a violin plot of only17
ggplot(data = only17, aes(x=season, y = discharge, fill = season)) +
  geom_violin() +
  xlab("Seasons") +
  ylab(expression(paste("Discharge ft"^"3 ","sec"^"-1"))) +
  ggtitle("2017 Stream Discharge by Season") +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none")

