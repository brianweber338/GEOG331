
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
