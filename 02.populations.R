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
    


