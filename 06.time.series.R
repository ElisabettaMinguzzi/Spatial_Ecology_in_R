# time series is a series of data scattered in time 
library(imageRy)
library(terra)

im.list()

# import the data 
EN01 <- im.import("EN_01.png")      
EN13 <- im.import("EN_13.png")

par(mfrow = c(2,1))
im.plotRGB.auto(EN01)
im.plotRGB.auto(EN13)

dif = EN01[[1]] - EN13[[1]]        # we compare the values from january with those of march, using the first element (band) of images
dev.off()
plot(dif)

cldif <- colorRampPalette(c("blue", "white", "red"))(100) 
plot(dif, col=cldif) # the red parts are those where values were higher in January

# New example: temperature in Greenland 
im.list()
g2000 <- im.import("greenland.2000.tif")
g2000
clg <- colorRampPalette(c("blue", "white", "red"))(100) 
plot(g2000, col=clg)      # inner areas in greenland which have almost perennial ice, while there are outer areas which are melting 
# let's import all the images

g2005 <- im.import("greenland.2005.tif")
g2010 <- im.import("greenland.2010.tif")
g2015 <- im.import("greenland.2015.tif")

clg <- colorRampPalette(c("black", "blue", "white", "red"))(100)


par(mfrow=c(2,1))
plot(g2000, col=clg)
plot(g2015,col=clg)

# exercise: make the difference between the first and the final elements of the stack 
dif2 = g2000[[1]] - g2015[[1]] 
plot(dif2, col=clg)        # instead, we can write dif2 = stackg[[1]] - stackg[[4]]
# in the middle, greenland is reaching much higher temperatures 



