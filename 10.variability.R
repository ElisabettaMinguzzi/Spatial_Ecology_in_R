# measurement of RS based variability 
library(imageRy)
library(terra)
library(viridis)


im.list()
sent <- im.import("sentinel.png")

# band 1 = NIR
# band 2 = red 
# band 3 = green

im.plotRGB(sent, r=1, g=2, b=3)
im.plotRGB(sent, r=2, g=1, b=3)

nir <- sent[[1]]
plot(nir)

# MOVING WINDOW TECHNIQUE <-- a window of 3x3 pixels is moving inside an image and we're going to calculate the standard deviation of the 9 pixels inside the window; then the window moves right of 1 pixel and we're going to calculate another sd. If we change the dimension of the window, the sd changes.
# focal
sd3 <- focal(nir, matrix(1/9,3,3),fun=sd)   # The matrix is composed of 9 pixels from 1 to 9, and they are distributed 3 by 3 (3,3); the function we're going to calculate is the standard deviation(sd)
plot(sd3)

viridisc <- colorRampPalette(viridis(7))(255)  # 255 is the amount of different colors used
plot(sd3, col=viridisc)

