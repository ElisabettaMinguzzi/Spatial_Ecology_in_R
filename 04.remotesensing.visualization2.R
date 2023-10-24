# remote sensing for ecosystems monitoring 

install.packages("devtools")    # CRAN = comprehensive R archive network 
library(devtools)
install_github("ducciorocchini/imageRy")     # you install a package directly from Github 

install.packages("terra")
im.list
# sentinel has images of the whole planet with a 10ms resolution. The images have different bands (one for red, one for blue, one for green, one for infrared among the others)
b2 <- im.import("sentinel.dolomites.b2.tif")
b2    # to get the informations of the layer 
