#We'll perform the PCA and use the PC1 to make the calculation of sd. 
library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

pairs(sent)
# sentinel_2 and sentinel_3 are correlated with each other very well. Sentinel_4 is just a control layer, we can ignore it. 
# perform PCA on sent 
sentpc <- im.pca(sent)
# we can isolate the first component 
sentpc 
pc1 <- sentpc$PC1

viridisc <- colorRampPalette(viridis(7))(255)
plot(pc1, col=viridisc)

# calculating sd on top of pc1 
pc1sd3 <- focal(pc1, matrix(1/9, 3,3), fun=sd)
plot(pc1sd3, col=viridisc)    # This is similar to the nir, but this is objectively calculated on a specific chosen layer. We can make the calculation obviously on a 7x7 pixels window. 

pc1sd7 <- focal(pc1, matrix(1/49, 7,7), fun=sd)
plot(pc1sd7, col=viridisc)      # So we can plot the original image sentinel, the sd3x3, the sd7x7, the pc1, the pc1 sd3x3 and the pc1 sd7x7.

par(mfrow=c(2,3))
im.plotRGB(sent, 2, 1, 3)
# sd from the variability script:
plot(sd3, col=viridisc)
plot(sd7, col=viridisc)
plot(pc1, col=viridisc)
plot(pc1sd3, col=viridisc)
plot(pc1sd7, col=viridisc)

# we can stack the data (single layers: sd3, sd7, pc1sd3, pc1sd7) in a single object instead of using par(mfrow)
sdstack <- c(sd3, sd7, pc1sd3, pc1sd7)
plot(sdstack, col=viridisc)   
# we can change the names of the plots with the function names()
names(sdstack) <- c("sd3", "sd7", "pc1sd3", "pc1sd7")
plot(sdstack, col=viridisc)

#the sd represents the amount of variability in a certain moving window; the function focal() can be used to calculate other statistics, like mean, etc., on a single layer.









