
# Make a vector of tree heights
heights <- c(30, 41, 20, 22)

heights_cm <- heights*100
print(heights_cm)
# 1:99
# 99:1
# help(matrix)
# ?matrix

#set up a matrix with 2 columns and fill in by rows
#first argument is the vector of numbers to fill in the matrix
Mat<-matrix(c(1,2,3,4,5,6), ncol=2, byrow=TRUE)


# In class PC File Path
datW <- read.csv("C:\\Users\\bweber\\Documents\\Activity2Files\\2011124.csv", stringsAsFactors = T)
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


# Numeric Data


# Integer Data


# Factor Data

