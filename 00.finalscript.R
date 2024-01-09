# Final script including all the different scripts during lectures 

#------------------------------------------
# Summary: 
# 01 Beginning 
# 02.1 Population density 
# 02.2 Population distribution
# 03 Community multivariate analysis
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






