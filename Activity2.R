
# Make a vector of tree heights
heights <- c(30, 41, 20, 22)

heights_cm <- heights*100
print(heights_cm)
# 1:99
# 99:1
# help(matrix)
# ?matrix
# rm(ElementIWantRemoved)


#set up a matrix with 2 columns and fill in by rows
#first argument is the vector of numbers to fill in the matrix
Mat<-matrix(c(1,2,3,4,5,6), ncol=2, byrow=TRUE)


#HW START

setwd("Z:\\students\\bweber\\Data\\Activity2Files")
getwd()

# In class PC File Path
datW <- read.csv("Z:\\students\\bweber\\Data\\Activity2Files\\2011124.csv", stringsAsFactors = T)
str(datW)

#Question 1
ncol(datW)
nrow(datW)

#specify a column with a proper date format
#note the format here dataframe$column
datW$dateF <- as.Date(datW$DATE, "%Y-%m-%d")
#create a date column by reformatting the date to only include years
#and indicating that it should be treated as numeric data
datW$year <- as.numeric(format(datW$dateF,"%Y"))


#Question 2
# Character Data
CharVector <- c("My",  "GitHub", "Username", "Is", "brianweber338")

# Numeric Data
NumericVector <- c(-3.75, -2.5, -1.25, 0, 1.25, 2.5, 3.75)

# Integer Data
IntVector <- c(-1L, 2L, 4L, 8L, 16L)

# Factor Data

