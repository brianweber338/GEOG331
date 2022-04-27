#install.packages(c("caret","randomForest"))
library(terra)
library(caret)
library(randomForest)

#set up working directory for oneida data folder on the server
setwd("Z:/GEOG331_S22/data/oneida/")

#read in Sentinel data

# list files from sentinel satellite image files
f <- list.files(path = "sentinel/", pattern = "T18", full.names = T)

# read the list of files as a single multi-band spatRaster
rsdat <- rast(f)

# create a vector of band names so we can keep track of them
b <- c("B2","B3","B4","B5","B6","B7","B8","B11","B12")

#set band names in our raster
names(rsdat) <- b

# read the cloud mask data file
clouds <- rast("sentinel/MSK_CLDPRB_20m.tif")

#read in validation data
algae <- vect("Oneida/algae.shp")
agri <- vect("Oneida/agriculture.shp")
built <- vect("Oneida/built.shp")
forest <- vect("Oneida/forest.shp")
water <- vect("Oneida/water.shp")
wetlands <- vect("Oneida/wetlands.shp")


# reclassify the cloud mask so that pixel values below 60% become 1
# and values over 60 become NA
cloudsF <- classify(clouds, matrix(c(-Inf,60,1,60,Inf,NA), ncol = 3, byrow = T))

# use the cloud mask to remove NA pixels from the reflectance data
rsmask <- mask(rsdat,cloudsF)


#if I run this without setting the seed it will be different every time
#randomly choose 60 elements in the vector of 120 elements
sample(seq(1,120),60)

#set seed so samples always the same
set.seed(12153)
#randomly select the data in each dataset to be  used
sampleType <- rep("train",120)
#samples to randomly convert to validation data
sampleSamp <- sample(seq(1,120),60)
#convert these random samples from training to validation
sampleType[sampleSamp] <- "valid"


#set up table with coordinates and data type (validate or train) for each point
landExtract <-  data.frame(landcID = rep(seq(1,6),each=120),
                           x=c(crds(algae)[,1],crds(water)[,1],crds(agri)[,1],crds(built)[,1],crds(forest)[,1],crds(wetlands)[,1]),
                           y=c(crds(algae)[,2],crds(water)[,2],crds(agri)[,2],crds(built)[,2],crds(forest)[,2],crds(wetlands)[,2]))
#add sample type
landExtract$sampleType <- rep(sampleType, times=6)

#create id table that gives each landcover an ID
landclass <- data.frame(landcID= seq(1,6),
                        landcover = c("algal bloom", "open water","agriculture","built","forest","wetlands"))


#extract reflectance values for our sample points
rasterEx <- data.frame(extract(rsmask,landExtract[,2:3]))[,-1]

#combine point information with raster information
dataAll <- cbind(landExtract,rasterEx)
#preview
head(dataAll)

#remove missing data
dataAlln <- na.omit(dataAll)

#subset into two different data frames
trainD <- dataAlln[dataAlln$sampleType == "train",]
validD <- dataAlln[dataAlln$sampleType == "valid",]




#Kfold cross validation
tc <- trainControl(method = "repeatedcv", # repeated cross-validation of the training data
                   number = 10, # number 10 fold
                   repeats = 10) # number of repeats
###random forests
#Typically square root of number of variables
rf.grid <- expand.grid(mtry=1:sqrt(9)) # number of variables available for splitting at each tree node


# Train the random forest model to the Sentinel-2 data
#note that caret:: will make sure we use train from the caret package
rf_model <- caret::train(x = trainD[,c(5:13)], #digital number data
                         y = as.factor(trainD$landcID), #land class we want to predict
                         method = "rf", #use random forest
                         metric="Accuracy", #assess by accuracy
                         trainControl = tc, #use parameter tuning method
                         tuneGrid = rf.grid) #parameter tuning grid
#check output
rf_model


# Apply the random forest model to the Sentinel-2 data
rf_prediction <- terra::predict(rsmask, rf_model, na.rm = T)
#view prediction
plot(rf_prediction)

#landcover class names
landclass

#set up categorical colors
landclass$cols <-c("#a6d854","#8da0cb","#66c2a5",
                   "#fc8d62","#ffffb3","#ffd92f")
#make plot and hide legend
plot(rf_prediction,
     breaks=seq(0,6), 
     col=landclass$cols ,
     legend=FALSE, axes=FALSE)
legend("bottomleft", paste(landclass$landcover),
       fill=landclass$cols ,bty="n",horiz = T) 




#get validation data from raster by extracting 
#cell values at the cell coordinates
rf_Eval <- extract(rf_prediction, validD[,2:3])

#make the confusion matrix
rf_errorM <- confusionMatrix(as.factor(rf_Eval[,2]),as.factor(validD$landcID))
#add landcover names
colnames(rf_errorM$table) <- landclass$landcover
rownames(rf_errorM$table) <- landclass$landcover
#view the matrix
rf_errorM$table

#look at the overall accuracy
rf_errorM$overall