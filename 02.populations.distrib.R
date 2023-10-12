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






