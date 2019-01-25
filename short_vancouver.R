library(maps)
library(rgdal)
library(raster)

#boundaries for which background data will be extracted
vancouver_x_lims <- c(-129, -123) 
vancouver_y_lims <- c(48, 51)

vancouver <- map(ylim=vancouver_y_lims, xlim=vancouver_x_lims, col='gray90', fill=TRUE)  

#building polygon by vertices in order to extract precisely Vancouver island points and not other territories
xs <- min(vancouver_x_lims) + c(5.6, 5.5, 5.1, 3.9, 3.5, 2.2, 0.5, 0.8, 3.4, 5.4, 5.8)
ys <- min(vancouver_y_lims) + c(0.7, 0.7, 1.2, 1.95, 2.35, 2.6, 3, 1.9, 0.8, 0.2, 0.5)

for (i in seq_along(xs)){
  points(x = xs[i], y = ys[i], pch = 10)
}
#adding the polygon to define the area for which data will be extracted
polygon(x = xs, y = ys, col = 'grey90')

#generating the set of coordinates that spans all the plotting areas 

#creating table of latitude and longitude for locations of interest
Latitude_vancouver <- seq(from = vancouver_y_lims[1], to = vancouver_y_lims[2], by = 0.062) #approx 2'
Longitude_vancouver <- seq(from = vancouver_x_lims[1], to = vancouver_x_lims[2], by = 0.062) #approx 2'
lat_long_vancouver <- expand.grid(Latitude = Latitude_vancouver, Longitude = Longitude_vancouver) #making pairs of latitude and longitude

#Which of these fall within the polygon?
#Data for Vancouver hold points outside the island; those needs to be deleted

inds <- which(point.in.polygon(point.x = lat_long_vancouver$Longitude, point.y = lat_long_vancouver$Latitude, pol.x = xs, pol.y = ys)==1)
lat_long_in_polygons <- lat_long_vancouver[inds, ]

dim(lat_long_in_polygons) #1541 points
table(complete.cases(lat_long_in_polygons)) #No NAs here 



#loading Bioclim database data 
setwd('/home/jane/Документы/Misha/sheludkov/crimea_vs_vancouver_sdms/wc2.0_2.5m_bio/')
#for some reason the code below only work is i navigate to the directory where tif files are stored


worldclim_world <- dir('/home/jane/Документы/Misha/sheludkov/crimea_vs_vancouver_sdms/wc2.0_2.5m_bio/', pattern = '*tif')

worldclim_world_raster_stack <- raster::stack(worldclim_world)

dim(worldclim_world_raster_stack); class(worldclim_world_raster_stack)

#how can I get a set of raster/rasterStack obejct for my region of interest exclusively subsetting by `lat_long_in_polygons` coordinates?
