# remote sensing for ecosystems monitoring 

install.packages("devtools")    # CRAN = comprehensive R archive network 
library(devtools)
install_github("ducciorocchini/imageRy")     # you install a package directly from Github 

install.packages("terra")
im.list
# sentinel has images of the whole planet with a 10ms resolution. The images have different bands (one for red, one for blue, one for green, one for infrared among the others)
b2 <- im.import("sentinel.dolomites.b2.tif")
b2    # to get the informations of the layer 

cl <- colorRampPalette (c("black", "grey", "light grey")) (100)
plot(b2, col=cl)
# let's do the same with b3, b4 and b8

# Comparing all the images in a multiframe 
par(mfrow = c(2,2))
plot(b2,col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

# stack images 
stacksent <- c(b2, b3, b4, b8)
stacksent 
plot(stacksent, col=cl)
dev.off()
plot(stacksent[[4]], col=cl)

# Exercise : plot in a multiframe the bands with different color ramps 
c2 <- colorRampPalette(c("dodgerblue3", "blue4", "cyan3")) (100)
plot(b2, col=c2)

c3 <- colorRampPalette(c("chartreuse4", "palegreen", "forestgreen")) (100)
plot(b3, col=c3)

c4 <- colorRampPalette(c("brown2", "firebrick4", "black")) (100)
plot(b4, col=c4)

c8 <- colorRampPalette (c("black", "gold1", "oldlace")) (100)
plot(b8, col=c8)

par(mfrow = c(2,2))
plot(b2,col=c2)
plot(b3, col=c3)
plot(b4, col=c4)
plot(b8, col=c8)

# RGB space
# stacksent : 
band2  blue element 1, stacksent[[1]]
band3 green element 2, stacksent[[2]]
band4 red element 3, stacksent[[3]]
band8 nir element 4, stacksent[[4]]
im.plotRGB(stacksent, r=3, g=2, b=1)






