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
p1 <- ggplot(tabout, aes(x=class, y=y1992, color=class) + geom_bar(stat="identity", fill="white")











