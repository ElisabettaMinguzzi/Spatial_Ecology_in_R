# This R project aims at analysing the impact that the Emilia-Romagna flooding of May 2023 had on the land in the Province of Ravenna. To do this, we're going to assess the differences in soil water index and vegetation cover from the end of April 2023 to the end of May 2023. 

# First, we're going to import some imagery from Copernicus relative to swi

# We're going to need the packages "terra" and "ncdf4"

library(terra)
library(ncdf4)
library(ggplot2)
library(imageRy)
library(patchwork)

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

plot(swi_may)
plot(swi_may$SWI_005)
ext <- c(10,15,42,46)
swi_maycrop <- crop(swi_may$SWI_005, ext)
plot(swi_maycrop, col=cl)
ext <- c(11.5,12.5,44,45)
swi_maycrop2 <- crop(swi_maycrop, ext)
plot(swi_maycrop2, col=cl)

par(mfrow=c(1,2))
plot(swi_aprilcrop2, col=cl, main="SWI_005 in April")
plot(swi_maycrop2, col=cl, main="SWI_005 in May")

# Check the difference in Soil Moisture Index 
diff_swi <- swi_maycrop2 - swi_aprilcrop2
plot(diff_swi, col=cl)    # From April to May the SWI decreased in value in the province of Ferrara, while the province of Ravenna saw a big increase. 


# Now let's analyse the impact on vegetation cover. The vegetation cover is mainly due to an agricultural land use.

# Let's import the dataset 
tc_april <- rast("tc_april.jpg") # true color image from April 
fc_april <- rast("fc_april.jpg") # false color image from April 

tc_may <- rast("tc_may.jpg") # true color image from May 
fc_may <- rast("fc_may.jpg") # false color image from May 

tc_june <- rast("tc_june.jpg") # true color image from June
fc_june <- rast("fc_june.jpg") # false color image from June

tc_april  # The True color RGB images have r=1, g=2, b=3. In Sentinel-2 L1C B4=red, B3=green, B2=blue.
fc_april  # The False color RGB images have B8=1, B4=2, B3=3, where B8=NIR. 
tc_may
fc_may
tc_june
fc_june

# Let's plot them 
par(mfrow=c(2,2))
plot(tc_april, main="True colors in April")
plot(fc_april, main="False colors in April")
plot(tc_may, main="True colors in May")
plot(fc_may, main="False colors in May")

plot(tc_may, main="True colors in May")
plot(fc_may, main="False colors in May")
plot(tc_june, main= "True colors in June")
plot(fc_june, main= "False colors in June")

dev.off()

# Let's change the bands to see what differs
plotRGB(tc_april, r=1, g=2, b=3)
plotRGB(tc_april, r=3, g=2, b=1)   # By interchanging the red and the blue bands, the cultivated fields appear blueish, while the water appears yellow-brownish.

# Let's analyze the bands and plot them in different colors palettes

c2 <- colorRampPalette(c("black", "blue3", "cyan3")) (100)
c3 <- colorRampPalette(c("black","forestgreen", "palegreen")) (100)
c4 <- colorRampPalette(c("black","firebrick4","brown2")) (100)
c8 <- colorRampPalette(c("black", "gold1", "oldlace")) (100)

par(mfrow=c(2,2))
plot(tc_april[[1]], col=c4) # red
plot(tc_april[[2]], col=c3) # green
plot(tc_april[[3]], col=c2) # blue
plot(fc_april[[1]], col=c8) # NIR

par(mfrow=c(2,2))
plot(tc_may[[1]], col=c4) # red
plot(tc_may[[2]], col=c3) # green
plot(tc_may[[3]], col=c2) # blue
plot(fc_may[[1]], col=c8) # NIR

par(mfrow=c(2,2))
plot(tc_june[[1]], col=c4) # red
plot(tc_june[[2]], col=c3) # green
plot(tc_june[[3]], col=c2) # blue
plot(fc_june[[1]], col=c8) # NIR

# Let's crop the April and May images to the same extent as the June ones
ext <- c(0,2500,0,1536)
tc_april_ext <- crop(tc_april, ext)
fc_april_ext <- crop(fc_april, ext)
tc_may_ext <- crop(tc_may, ext)
fc_may_ext <- crop(fc_may, ext)

# Plot the difference in the NIR band reflectance from April and the May images
diff_NIR <- fc_april_ext[[1]] - fc_may_ext[[1]]
plot(diff_NIR)

# Let's do the same with the May and June images
diff_NIR2 <- fc_may_ext[[1]] - fc_june[[1]]
plot(diff_NIR2)

# Let's change the palette
install.packages("RColorBrewer")
library(RColorBrewer)
cl <- brewer.pal(8,"YlOrRd")
plot(diff_NIR, col=cl)   # The reflectance in the NIR band decreased a lot in May in the areas that got flooded, which means that the vegetation was entirely covered by water.

plot(diff_NIR2, col=cl)   # The reflectance in the NIR increased again in the former flooded areas, which means that they dried off, and at the rivers' mouths due to sediments and especially vegetation matter being released in the sea; while it decreased somewhat homogeneously everywhere else, and this could be due to the fact that the climate got hotter and drier and the vegetation suffered in this sense.   

# Let's calculate the DVI = NIR - RED, using the bands from the false color images
dviapril = fc_april_ext[[1]] - fc_april_ext[[2]]
plot(dviapril)

cdvi <- colorRampPalette(c("maroon", "rosybrown1", "olivedrab4")) (100)
plot(dviapril, col=cdvi)

dvimay = fc_may_ext[[1]] - fc_may_ext[[2]]
plot(dvimay, col=cdvi)

dvijune = fc_june[[1]] - fc_june[[2]]
plot(dvijune, col=cdvi)

# Let's calculate now the NDVI = (NIR - RED)/(NIR + RED)

ndviapril = dviapril/(fc_april_ext[[1]] + fc_april_ext[[2]])
ndvimay = dvimay/(fc_may_ext[[1]] + fc_may_ext[[2]])
ndvijune = dvijune/(fc_june[[1]] + fc_june[[2]])
cndvi <- colorRampPalette(c("mintcream", "lightsteelblue2", "mediumorchid3"))(100)
plot(ndviapril, col=cndvi, main="NDVI of April", cex.main=.8)
plot(ndvimay, col=cndvi, main="NDVI of May", cex.main=.8) 
plot(ndvijune, col=cndvi, main="NDVI of June", cex.main=.8)
stacksent <- c(ndviapril, ndvimay, ndvijune)    
plot(stacksent, col=cndvi, main= "NDVI")
# The NDVI obviously decreased in the flooded area to 0 or negative values, while they actually increased a bit in other parts of the fields, but this could be just due to a slightly greater cloud coverage in the april imagery. In June there was a 0.5 increase in the NDVI in the former flooded areas, which fluctuated around the 0 value, indicating that the soil there was bare.

pairs(stacksent, main="NDVI pairs plot")       
# We can see that the Pearson correlation coefficient is much higher between the NDVI in May and the NDVI in April, while between May and June, and especially April and June, there is little correlation, as we can see that most of the NDVI values in June are concentrated in the neighbourhood of 0.5.



# CLASSIFICATION OF THE LAND

fc_april_class <- im.classify(fc_april_ext, num_clusters=3)
class_names <- c("fields", "water", "soil/cities")   # DIPENDE DAI COLORI CHE TI ESCONO
plot(fc_april_class[[1]], main = "Classes from April", type = "classes", levels = class_names)

fc_may_class <- im.classify(fc_may_ext, num_clusters=3)
plot(fc_may_class[[1]], main = "Classes from May", type = "classes", levels = class_names)

fc_june_class <- im.classify(fc_june_ext, num_clusters=3)
plot(fc_june_class[[1]], main= "Classes from May", type = "classes", levels = class_names)

par(mfrow=c(3,1))
plot(fc_april_class[[1]], main = "April Classes ", type = "classes", levels = class_names)
plot(fc_may_class[[1]], main = "May Classes", type = "classes", levels = class_names)
plot(fc_june_class[[1]], main = "June Classes", type = "classes", levels = class_names)















