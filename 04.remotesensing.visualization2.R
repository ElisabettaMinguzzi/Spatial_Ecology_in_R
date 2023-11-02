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



