# This R project aims at analysing the impact that the Emilia-Romagna flooding of May 2023 had on the land in the Province of Ravenna. To do this, we're going to assess the differences in soil water index and vegetation cover in a time series from the end of April 2023 to the end of May 2023. 

# First, we're going to import some imagery from Copernicus relative to ssm 

# We're going to need the packages "terra" and "ncdf4"

library(terra)
library(ncdf4)

# Setting the working directory and importing the downloaded data from Copernicus 
setwd("C:/Users/elisa/OneDrive/Documents/Scienze Naturali/Spatial ecology in R/Exam Project")
swi_april <- rast("soilwaterindex_april.nc")
swi_may <- rast("soilwaterindex_may.nc")
plot(swi_april)
plot(swi_april$SWI_005)
ext <- c(10,15,42,46)
swi_aprilcrop <- crop(swi_april$SWI_005, ext)
cl <- colorRampPalette(c("yellowgreen", "violetred", "plum1")) (100)
plot(swi_aprilcrop, col=cl)
ext <- c(11.5,12.5,44,45)
swi_aprilcrop2 <- crop(swi_aprilcrop, ext)
plot(swi_aprilcrop2, col=cl)

par(mfrow=c(1,2))
plot(swi_aprilcrop2, col=cl, main="SWI_005 in April")
plot(swi_maycrop2, col=cl, main="SWI_005 in May")

# Check the difference in Soil Moisture Index 
diff_swi <- swi_maycrop2 - swi_aprilcrop2
plot(diff_swi, col=cl)


# Now let's analyse the impact on vegetation cover. The vegetation cover is mainly due to an agricultural land use.





