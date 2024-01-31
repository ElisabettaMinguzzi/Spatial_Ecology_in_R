# Final script including all the different scripts during lectures 

#------------------------------------------
# Summary: 
# 01 Beginning 
# 02.1 Population density 
# 02.2 Population distribution
# 03.1 Community multivariate analysis
# 03.2 Community overlap 
# 04 Remote sensing data visualization
# 05 Spectral indices 
# 06 Time series
# 07 External data
# 08 Copernicus data
# 09 Classification
# 10 Variability 
# 11 Principal Component Analysis 
#------------------------------------------

# Here I can write anything I want !! 
# R as a calculator 
2+3 

# Assign to an object 
zima <- 2+3
zima

duccio <- 5+3
duccio

final <- zima * duccio 
final

final^2

#array
sophi <- c(10,20,30,50,70) # microplastics 

paula <- c(100,500,600,1000,2000) # people

plot(paula, sophi)

plot(paula, sophi, xlab="number of people", ylab="microplastics") 

people <- paula
microplastics <- sophi

plot(people, microplastics)
plot (people, microplastics, pch=19)

plot (people, microplastics, pch=19, cex=2)
plot (people, microplastics, pch=19, cex=2, col="blue")

#------------------------------------------
# 02.01 Population density 

# Code related to population ecology 
# A package is needed for point pattern analysis 
install.packages("spatstat")
install.packages("Rtools")

# let’s use the bei data 
# data description: 
# https://CRAN.R-project.org/package=spatstat

# plotting the data 
plot(bei)
plot(bei, cex=.5)
plot(bei, cex=.2)

# additional dataset 
bei.extra
plot(bei.extra)

# let's use only part of the dataset: elev 
bei.extra$elev
plot(bei.extra$elev)
elevation <- bei.extra$elev 
plot(elevation)

# second method to select elements 
elevation2 <- bei.extra[[1]]
bei.extra[[1]]
plot(elevation2)

library(spatstat)

# let's build a density map 
# passing from points to a continuous surface 
densitymap <- density(bei) 

densitymap
plot(densitymap)
points(bei)
cl <- colorRampPalette (c("black"), "red", "orange", "yellow"))(100)
# The 100 indicates the number of shades present in the map. if you put 4 instead of 100 colors will me much more defined and less continuous. 

 cl <- colorRampPalette(c("lavender", "deepskyblue3", "plum1", "orchid4")) (100)
> plot(densitymap, col=cl)

# we'll add additional variables, which are called "auxiliary variables", which explain other variables.
plot(bei.extra)

# the extras are gradient and elevation, if we want to select the first element: 
# The quadratic parentheses with 1 indicate the first element of bei.extra
elev <- bei.extra[[1]] # or bei.extra$elev
plot(elev)

# mf = multiframe, so on the left we can have the density map and on the right the elevation map, so we'll have two panels in one row and two columns
par(mfrow = c(1,2))
plot(densitymap)
plot(elev)

# if we want to put one panel on the top and one on the bottom, we'll have 2 rows and 1 column
par(mfrow=c(2,1))

# we want to make 3 panels
par(mfrow=c(1,3))
plot(bei)
plot(densitymap)
plot(elev)
    
#------------------------------------------
# 02.2 Population distribution 

# why do populations desperse over the landscape in a certain manner? 
library(sdm)    # species distribution models (sdm)
library(terra)  # predictors
# Gdal package is now inside the terra package. 

system.file # to search for a file in the library 
file <- system.file("external/species.shp", package="sdm") 

# external is a folder which has been installed with the package sdm. Inside external there's the "species.shp" file. 

file   # it expressed the path in my computer to the file
# external.shp is a vector file, which deals with points in space with vector coordinates 
rana <- vect(file)   # vect(name) is a function from the terra package 
rana    # you can see the structure of the file 

rana$Occurrence    # It appears a series of 0 which indicates absence of Rana temporaria, and 1 indicates presence. In Ecology these are called "presence-absence data", where you just record the presence of a species, and not the abundance
# The 0 is an uncertain data, because you may have missed the rana, but it could have been there. The 0 could be real or not. Here we'll take the 0 as real absence.

plot(rana)
plot(rana, cex=0.5)

# we can now select the presences or the absences in the plot. 

# Selecting presences (all the points which indicate 1)
rana[rana$Occurrence==1,]
pres <- rana[rana$Occurrence==1,]    # pres = presence
pres$Occurrence
plot(pres, cex=.5)


# == : equal 
# != : unequal 
# , : the comma closes the query 


# Exercise : select absence and call them abse
abse <- rana[rana$Occurrence == 0,]      # You can also write !=1,]
abse$Occurrence
plot(abse, cex=.5)

# Two plots beside each other, one which is pres and one which is abse
par(mfrow=c(1,2))
plot(pres)
plot(abse)

# We can plot all the points in the same plot, with different colors 
dev.off ()    # to close off graphs if you have graphical problems or you want to change graph

plot(pres, col="maroon2")
plot(abse, col="darkseagreen2")

# Predictors (environmental variables) : look at the path 
elev <- system.file("external/elevation.asc", package="sdm")
elev

# Rasters are images. 
# Asc = is a type of file (like jpg, gif)
# Elevation is the name of the file. We import it 

elevmap <- rast(elev)  # rast is a function from the terra package 
plot(elevmap)
points(pres, cex=0.5)

# The rana temporaria is recorded in sites which have medium elevations --> it's not distributed in the lower elevations which are too hot nor in the upper elevations which are too cold

# Temperature predictor
temp <- system.file("external/temperature.asc", package="sdm")
tempmap <- rast(temp)  
plot(tempmap)
points(pres, cex=0.5)


# Vegetation cover predictor 
vege <- system.file("external/vegetation.asc", package="sdm")
vegemap <- rast(vege)
plot(vegemap)
points(pres, cex=0.5)

prec <- system.file("external/precipitation.asc", package="sdm")
precmap <- rast(prec)
plot(precmap)
points(pres, cex=0.5)

# Let's plot all these together in a multiframe
par(mfrow = c(2,2))
plot(elevmap)
points(pres, cex=0.5)
plot(tempmap)
points(pres, cex=0.5)
plot(vegemap)
points(pres, cex=0.5)
plot(precmap)
points(pres, cex=0.5)

#------------------------------------------
# 03 Community multivariate analysis

library(vegan)

data(dune)
head(dune)

ord <- decorana(dune)

ldc1 =  3.7004 
ldc2 =  3.1166 
ldc3 = 1.30055
ldc4 = 1.47888

total = ldc1 + ldc2 + ldc3 + ldc4

pldc1 = ldc1 * 100 / total
pldc2 = ldc2 * 100 / total
pldc3 = ldc3 * 100 / total
pldc4 = ldc4 * 100 / total

pldc1
pldc2

pldc1 + pldc2

plot(ord) 

#------------------------------------------
# 03.2 Community overlap 

# relation among species in time

library(overlap)

data(kerinci)
summary(kerinci)

kerinci$timeRad <- kerinci$Time * 2 * pi

tiger <- kerinci[kerinci$Sps=="tiger",]

timetig <- tiger$timeRad
densityPlot(timetig, rug=TRUE)

# exercise: select only the data on macaque individuals
macaque <- kerinci[kerinci$Sps=="macaque",]
head(macaque)

timemac <- macaque$timeRad
densityPlot(timemac, rug=TRUE)

overlapPlot(timetig, timemac)

#------------------------------------------
# 04 Remote sensing data visualization 

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

#------------------------------------------
# 05 Spectral indices 

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

#------------------------------------------
# 06 Time series 

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

# stacking the data
stackg <- c(g2000, g2005, g2010, g2015)
plot(stackg, col=clg)

# exercise: make the difference between the first and the final elements of the stack 
dif2 = g2000[[1]] - g2015[[1]] 
plot(dif2, col=clg)        # instead, we can write dif2 = stackg[[1]] - stackg[[4]]
# in the middle, greenland is reaching much higher temperatures 

# We're gonna put the image of 2000 in the R channel, the second one in the G channel and the last one in the B channel. 
# If we have high values in 2000 they'll become red, if we have high values in 2005 they'll become green, ecc. 
# Exercise: make RGB plot using different years 
im.plotRGB(stackg, r=1, g=2, b=3)

#------------------------------------------
# 07 External data 

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

#------------------------------------------
# 08 Copernicus data 

# https://land.copernicus.vgt.vito.be/PDF/portal/Application.html

library(ncdf4)
library(terra)

setwd("C:/Users/elisa/Downloads")
soilmoisture2023 <- rast("c_gls_SSM1km_202311100000_CEURO_S1CSAR_V1.2.1.nc")
soilmoisture2023
plot(soilmoisture2023)

# there are two elements, let's use the first one!
plot(soilmoisture2023[[1]])

colorRampPalette(c("red", "orange", "yellow")) (100)

# crop the image 
ext <- c(22,26,55,57)     # min longitude, max longitude, min latitude, max latitude
soilm2023crop <- crop(soilmoisture2023, ext)
plot(soilm2023crop[[1]], col=cl)

soilmoisture2020 <- rast("c_gls_SSM1km_202010010000_CEURO_S1CSAR_V1.1.1.nc")
plot(soilmoisture2020)
soilm2020crop <- crop(soilmoisture2020, ext)
plot(soilm2020crop[[1]],col=cl)




# if I visualize for example burnt areas they're little areas on the planet, so i should crop the image to visualize it better 
# I can upload another image and do a comparison 


#------------------------------------------
# 09 Classification 

# Classifying satellite images and estimate the amount of change 

library(terra)
library(imageRy)
imlist()

sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
sunc <- im.classify(sun, num_clusters=3)
plot(sunc)

# classify satellite data
m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")

m1992c <- im.classify(m1992, num_clusters=2)
plot(m1992c)     # classes: forest=1, human related=2

m2006c <- im.classify(m2006, num_clusters=2)
plot(m2006c)   # classes: forest=1, human related=2

par(mfrow=c(1,2))
plot(m1992c[[1]])
plot(m2006c[[1]])

# let's calculate the proportion of the two classes
f1992 <- freq(m1992c[[1]])

tot1992 <- ncell(m1992c)    # ncell gives the total amount of pixels 
# percentage
p1992 <- f1992 * 100 / tot1992 
p1992     # we are interested in the values under "count" --> forest:83%, human=17%

f2006 <- freq(m2006c[[1]])
tot2006 <- ncell(m2006c)
p2006 <- f2006 * 100 / tot2006
p2006    # forest:45%, human=55%

# building the final table 
class <- c("forest, human")
y1992 <- c(83, 17)
y2006 <- c(45, 55)

tabout <- data.frame(class, y1992, y2006)
tabout

library(ggplot2)
# final output 
p1 <- ggplot(tabout, aes(x=class, y=y1992, color=class) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p2 <- ggplot(tabout, aes(x=class, y=y2006, color=class) + geom_bar(stat="identity", fill="white") + ylim(c(0,100))
p1 + p2

        
#------------------------------------------
# 10 Variability 


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

viridisc <- colorRampPalette(viridis(7))(255)  # 255 is the amount of different nuances of the 7 colors used.
plot(sd3, col=viridisc)     # the part with the highest variability is the upper left

# let's calculate the variability in a 7x7 pixels moving window
sd7 <- focal(nir, matrix(1/49, 7,7), fun=sd)
plot(sd7, col=viridisc)

# Exercise: plot via par(mfrow()) the 3x3 and the 7x7 standard deviation
par(mfrow=c(1,2))
plot(sd3, col=viridisc) 
plot(sd7, col=viridisc)    # if we enlarge the moving window (49 pixels instead of 9), we have a higher variability. 

# original image plus the 7x7 sd
im.plotRGB(sent, r=1, g=2, b=3) 
plot(sd7, col=viridisc)    # in the upper left part we can see a lot of white, which indicates a high geological variability (or species variability in some cases), so it discriminates between snow/clouds and bare soil. 

# How can we decide which layer we should apply/calculate the standard deviation to? With multivariate analysis.

#------------------------------------------
# 11 Principal Component Analysis 


#We'll perform the PCA and use the PC1 to make the calculation of sd. 
library(imageRy)
library(terra)
library(viridis)

im.list()

sent <- im.import("sentinel.png")

pairs(sent)
# sentinel_2 and sentinel_3 are correlated with each other very well. Sentinel_4 is just a control layer, we can ignore it. 
# perform PCA on sent 
sentpc <- im.pca2(sent)
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

#------------------------------------------
12_pluto_final_example.R

setwd("~/Documents/lectures_and_seminars/images")

library(terra)
library(imageRy)
library(viridis)

pluto <- rast("pluto_New_Horizons_spacecraft.png")
plot(pluto)
plotRGB(pluto, 3, 2, 1)
plutovar <- focal(pluto, matrix(1/25, 5, 5), fun=sd)

viridisc <- colorRampPalette(viridis(7))(255)
plot(plutovar[[1]], col=viridisc)

makoc <- colorRampPalette(mako(7))(255)
plot(plutovar[[1]], col=makoc)

par(mfrow=c(1,2))
plot(pluto)
plotRGB(pluto, 3, 2, 1)
plot(plutovar[[1]], col=viridisc)
plot(plutovar[[1]], col=makoc)



