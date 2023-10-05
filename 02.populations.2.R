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
