setwd("C:/Users/elisa/OneDrive/Documents/Scienze Naturali")     # set working directory 
library(terra)
naja <- rast("najafiraq_etm_2003140_lrg.jpg")     # like in im.import(), we should use the name of the image we want to download
plotRGB(naja, r=1, g=2, b=3)
# Exercise: download the second image from the same site and import it in R 
setwd("C:\Users\elisa\OneDrive\Documents\Scienze Naturali")
naja23 <- rast("najafiraq_oli_2023219_lrg.jpg")
plotRGB(naja23, r=1, g=2, b=3)

# multitemporal change detection 
najadif = naja[[1]] - naja23[[1]]
cl <- colorRampPalette(c("brown", "grey", "orange")) (100)
plot(najadif, col=cl)

# Download an image of choice
flood <- rast("pakistan_oli2_2022240_lrg.jpg")
plotRGB(flood, r=1, g=2, b=3)

par(mfrow=c(1,3))
plotRGB(flood, r=1, g=2, b=3)
plotRGB(flood, r=2, g=3, b=1)
plotRGB(flood, r=3, g=1, b=2)



