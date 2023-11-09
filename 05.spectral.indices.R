# vegetation indices

library(imageRy)
library(terra)

im.list()

m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")   
# bands: 1=NIR, 2=RED, 3=GREEN
im.plotRGB(m1992, r=1, g=2, b=3)
im.plotRGB(m1992, 1, 2, 3)
im.plotRGB(m1992, r=2, g=1, b=3)
im.plotRGB(m1992, r=2, g=3, b=1)

# import the recent image
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
im.plotRGB(m2006, r=2, g=3, b=1)

# make a multiframe with the 2006 and 1992 images
par(mfrow=c(1,2))
im.plotRGB(m1992, r=2, g=3, b=1)
im.plotRGB(m2006, r=2, g=3, b=1)

dev.off()
plot(m1992[[1]])

# DVI = NIR - RED
# bands: 1=NIR, 2=RED, 3=GREEN

dvi1992 = m1992[[1]] - m1992[[2]]
plot(dvi1992)

#the plot shows the amount of earthy vegetation which was present in 1992. the green is forest, the rest is bare soil or suffering forest. 

# let's change the palette
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi1992, col=cl)
# everything which is dark red is ok, while towards the yellow it's not.

# exercise: calculate dvi of 2006
dvi2006 = m2006[[1]] - m2006[[2]]
plot(dvi2006)
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)
plot(dvi2006, col=cl)

# let's calculate NDVI
ndvi1992 = dvi1992/ (m1992[[1]] + m1992[[2]])
plot(ndvi1992, col=cl)

ndvi2006 = dvi2006/ (m2006[[1]] + m2006[[2]])
plot(ndvi2006)

# the ndvi can be calculated more rapidly with the specific function on imageRy 










