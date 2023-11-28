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







