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

dev.off() 

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
plot(stacksent, col=cndvi, main= c("NDVI of April", "NDVI of May", "NDVI of June"))
# The NDVI obviously decreased in the flooded area to 0 or negative values, while they actually increased a bit in other parts of the fields, but this could be just due to a slightly greater cloud coverage in the april imagery. In June there was a 0.5 increase in the NDVI in the former flooded areas, which fluctuated around the 0 value, indicating that the soil there was bare.

pairs(stacksent, main="NDVI pairs plot")       
# We can see that the Pearson correlation coefficient is much higher between the NDVI in May and the NDVI in April, while between May and June, and especially April and June, there is little correlation, as we can see that most of the NDVI values in June are concentrated in the neighbourhood of 0.5.



# CLASSIFICATION OF THE LAND

fc_april_class <- im.classify(fc_april_ext, num_clusters=3)
class_names <- c("fields", "water", "soil/cities")  
plot(fc_april_class[[1]], main = "Classes from April", type = "classes", levels = class_names)

fc_may_class <- im.classify(fc_may_ext, num_clusters=3)
plot(fc_may_class[[1]], main = "Classes from May", type = "classes", levels = class_names)

fc_june_class <- im.classify(fc_june, num_clusters=3)
plot(fc_june_class[[1]], main= "Classes from May", type = "classes", levels = class_names)

par(mfrow=c(3,1))
plot(fc_april_class[[1]], main = "April Classes ", type = "classes", levels = class_names)
plot(fc_may_class[[1]], main = "May Classes", type = "classes", levels = class_names)
plot(fc_june_class[[1]], main = "June Classes", type = "classes", levels = class_names)


# Calculation of the proportion of the classes 
fapril <- freq(fc_april_class[[1]])
fapril
fmay <- freq(fc_may_class[[1]])
fmay
fjune <- freq(fc_june_class[[1]])
fjune

# Total number of pixels 
totpixels <- ncell(fc_april_class[[1]])
totpixels   # It's the same also for May and June, of course

# Percentage of the classes
papril <- fapril * 100 / totpixels   
papril                                # April percentages : fields = 48,1% , water = 11,1% ,  soil/cities = 40,9%
pmay <- fmay * 100 / totpixels       
pmay                                  # May percentages : fields = 57,9% , water = 16% , soil/cities = 26,1%
pjune <- fjune * 100 / totpixels 
pjune                                 # June percentages : fields = 43,6% , water = 10,3% , soil/cities = 46,1%

# Let's build a barplot representing the frequencies of the classes in the three months 
class <- c("fields", "water", "soil/cities")
april <- c(48, 11, 41)
may <- c(58, 16, 26)
june <- c(44, 10, 46)

tabout <- data.frame(class, april, may, june)
tabout

p1 <- ggplot(tabout, aes(x=class, y=april, fill = class)) + 
  geom_bar(stat="identity", color = "black") + 
  ggtitle("Land in April") + xlab("Class") + ylab("Values") +
  geom_text(aes(label=april), vjust=2, color="black", size=4.5) + 
  scale_fill_brewer(palette="Pastel2") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5)) + ylim(c(0,60))

p2 <- ggplot(tabout, aes(x=class, y=may, fill = class)) + 
  geom_bar(stat="identity", color = "black") + 
  ggtitle("Land in May") + xlab("Class") + ylab("Values") +
  geom_text(aes(label=may), vjust=2, color="black", size=4.5) + 
  scale_fill_brewer(palette="Pastel2") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5)) + ylim(c(0,60))

p3 <- ggplot(tabout, aes(x=class, y=june, fill = class)) + 
  geom_bar(stat="identity", color = "black") + 
  ggtitle("Land in June") + xlab("Class") + ylab("Values") +
  geom_text(aes(label=june), vjust=2, color="black", size=4.5) + 
  scale_fill_brewer(palette="Pastel2") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", hjust = 0.5)) + ylim(c(0,60))

p1+p2+p3

df2 <- data.frame(month=rep(c("april", "may", "june"), each=3), 
       classes=c("fields", "soil/cities", "water"), 
       percentages=c(48,41,11,58,26,16,44,46,10))

# Let's build a stacked barchart 

ggplot(data=df2, aes(x=classes, y=percentages, fill=month)) +
  geom_bar(stat="identity", color = "black")+
  geom_text(aes(label=percentages), vjust=0.5, color="black",
  position = position_stack(vjust =0.5), size=4.5)+
  scale_fill_brewer(palette="Pastel2") + 
  ggtitle("Change in land classes") + xlab("Class") + ylab("Values")+
  theme_minimal()+
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

# Combined barchart 

ggplot(data=df2, aes(x=classes, y=percentages, fill=month)) +
  geom_bar(stat="identity", color = "black", position=position_dodge())+
  geom_text(aes(label=percentages), vjust=1.6, color="black",
  position = position_dodge(0.9), size=4.5)+
  scale_fill_brewer(palette="Pastel2") + 
  ggtitle("Change in land classes") + xlab("Class") + ylab("Values")+
  theme_minimal()+
  theme(plot.title = element_text(face = "bold", hjust = 0.5))     

# We can clearly see that May had the highest percentage of the fields class, in spite of the flooding, which obviously increased the percentage of water, but the precipitations could have also aided the vegetation far away from the rivers. Furthermore, there is little difference between April and June. 

dev.off()

# Variability assessment through the moving window technique 

# 3x3 window --> the window stops for every pixel and calculates a summary statistics for the neighbourhood and then moves on to the next pixel. The standard deviation is calculated for all values within this window and assigned to the corresponding centre pixel of a new raster file. In the new file each pixel contains now information about its sorroundings.
# Let's first calculate the sd on the NIR band

clsd <- colorRampPalette(c( "olivedrab", "floralwhite", "cornsilk")) (100)

sd3_april <- focal(fc_april_ext[[1]], matrix(1/9,3,3), fun=sd)
plot(sd3_april)
plot(sd3_april, col=clsd, main = "Variability of the land in April (NIR)", cex.main = .8) 

sd3_may <- focal(fc_may_ext[[1]], matrix(1/9,3,3), fun=sd)
plot(sd3_may)
plot(sd3_may, col=clsd, main = "Variability of the land in May (NIR)", cex.main = .8) 

sd3_june <- focal(fc_june[[1]], matrix(1/9,3,3), fun=sd)
plot(sd3_june)
plot(sd3_june, col=clsd, main = "Variability of the land in June (NIR)", cex.main = .8) 

par(mfrow=c(3,1))
plot(sd3_april, col=clsd, main = "Variability of the land in April (NIR)", cex.main = .8) 
plot(sd3_may, col=clsd, main = "Variability of the land in May (NIR)", cex.main = .8) 
plot(sd3_june, col=clsd, main = "Variability of the land in June (NIR)", cex.main = .8) 


library(RStoolbox)
pcaapril <- rasterPCA(fc_april_ext)
summary(pcaapril$model)     # PC1 represents the 75% of the variability, while PC2 represents the 24%. PC3 contains much lesser information. 
loadings(pcaapril$model)    # The NIR band contributes for the total of the PC1, the red band is correlated most with PC2, while the green one with PC3. 

pcmay <- rasterPCA(fc_may_ext)
summary(pcmay$model)     # PC1 represents the 74% of the variability, while PC2 represents the 25%. 
loadings(pcmay$model)    # The NIR band is almost exclusively correlated with PC1.

pcjune <- rasterPCA(fc_june)
summary(pcjune$model)     # The PC1 represents the 71% of the variability, while PC2 represents the 28%.
loadings(pcjune$model)    # The same as above.

# It's reasonable that I calculate the sd in a 3x3 moving window on the PC1, since it's the most important PC. 


pc1april <- pcaapril$map$PC1
pc1aprilsd3 <- focal(pc1april, matrix(1/9, 3, 3), fun=sd)
plot(pc1aprilsd3, col=clsd, main="Variability in June (PC1)")

pc1may <- pcmay$map$PC1
pc1maysd3 <- focal(pc1may, matrix(1/9, 3, 3), fun=sd)
plot(pc1maysd3, col=clsd, main="Variability in May (PC1)")

pc1june <- pcjune$map$PC1
pc1junesd3 <- focal(pc1june, matrix(1/9, 3, 3), fun=sd)
plot(pc1junesd3, col=clsd, main="Variability in June (PC1)")


# Stack them all together to assess variability
sdstack <- c(sd3_april, sd3_may, sd3_june, pc1aprilsd3, pc1maysd3, pc1junesd3)
names(sdstack) <- c("April sd3", "May sd3", "June sd3", "PC1 April sd3", "PC1 May sd3", "PC1 June sd3")
plot(sdstack, col=clsd)

# The biggest variability is found along the streets and by cities and at the border between the coast and the sea, where the variability is obviously null. 
# The three months have similar variability, if it weren't for the values corresponding to the flooded areas in May, where the water made those quite homogeneous, while the variability at the edge between the flooded fields and the rest of the area increased. 
# Moreover, the difference between the sd calculated on the NIR band and one calculated on the PC1 is not so noticeable. 











