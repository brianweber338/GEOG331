
# load the terra package
library(terra)

#set working directory
setwd("Z:/students/bweber")

# read a raster from file
p <- rast("Z:/data/rs_data/20190706_002918_101b_3B_AnalyticMS_SR.tif")

# plot the raster
plot(p)

# plot an rgb rendering of the data
# causes error because color intensity exceeds 8-bit limit of 255
plotRGB(p, r = 3, g = 2, b = 1)

# plot an rgb rendering of the data
plotRGB(p, r = 3, g = 2, b = 1, 
        scale = 65535, 
        stretch = "hist")


# read file with field observations of canopy cover
tree <- read.csv("Z:/data/rs_data/siberia_stand_data.csv",
                 header = T)

# convert to vector object using terra package
gtree <- vect(tree, geom = c("Long", "Lat"), "epsg:4326")

# project the data to match the coordinate system of the raster layer
gtree2 <- project(gtree, p)

# create a polygon from the extent of the points
# note - I would expect the crs to be carried over, but it isn't, so we must specify it again
b <- as.lines(ext(gtree), "epsg:4326")

# reproject the polygons to the same projection as our raster
# crs: coordinate reference system
b2 <- project(b,crs(p))

# buffer the extent by 200m
b3 <- buffer(b2, width= 200)

# add gtree2 to plot
plot(gtree2, add = T, col = "red")
# add b2 square to plot
plot(b2, add = T)
# add b3 square to plot
plot(b3, add = T)


# use this to crop the raster layer so we
p2 <- crop(p, b3,
         filename = "20190706_SR_crop.tif", overwrite = TRUE)

# make a plot to see how it looks
plotRGB(p2, r = 3, g = 2, b = 1,
        scale = 65535,
        stretch = "lin")

# points(gtree2, col = "blue", cex = gtree2$cc.pct/50)

# calculate NDVI
ndvi <- (p2[[4]]-p2[[3]])/(p2[[4]]+p2[[3]])

# set the layer name to ndvi to avoid confusion
names(ndvi) <- "ndvi"


# create a plot of the ndvi map with sample points on top
png(filename = "ndvi_map.png",
    width = 6, height = 4, units = "in", res = 300)

plot(ndvi)
points(gtree2, col = "blue", cex = gtree2$cc.pct/50)

dev.off()


# extract NDVI values for each point
nt <- terra::extract(ndvi,gtree2, fun = mean, method = "bilinear")

# plot ndvi vs canopy cover
plot(nt$ndvi, gtree2$cc.pct, 
     pch = 16, col = "blue")

# plot again but fix the y-axis
plot(nt$ndvi, gtree2$cc.pct,
     pch = 16, col = "blue",
     xlim = c(0,1))




