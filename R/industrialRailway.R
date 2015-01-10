# Description
# Michiel Blok and Madeleine van Winkel (TheScripties)
# 2015-09-01


# IndustrialRailway function ----------------------------------------------
# Creates a plot of the buffer, points and name of the intersecting city
industrialRailway <- function() {
  preprocessing()
  buffer()
  intersect()
  visualization()
}

# Preprocessing function --------------------------------------------------
preprocessing <- function(){
  # Download and unzip files ------------------------------------------------
  download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip" , destfile = "data/netherlands-places-shape.zip")
  download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip" , destfile = "data/netherlands-railways-shape.zip")
  railwaysFiles <- unzip(zipfile = "data/netherlands-railways-shape.zip" , exdir = "data." , overwrite = TRUE)
  placesFiles <- unzip(zipfile = "data/netherlands-places-shape.zip" , exdir = "data." , overwrite = TRUE)
  
  # Reference to railways and places files ----------------------------------
  dsnRailways <- railwaysFiles[railwaysFiles == "data./railways.shp"] 
  dsnPlaces <- placesFiles[placesFiles == "data./places.shp"] 
  
  # Read shape files --------------------------------------------------------
  railways <- readOGR(dsnRailways, layer = ogrListLayers(dsnRailways)) 
  places <- readOGR(dsnPlaces, layer = ogrListLayers(dsnPlaces)) 
  
  # Transform files into RD projection --------------------------------------
  # Define CRS object for RD projection
  prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
  # Perform the coordinate transformation from WGS84 to RD
  railwaysRD <- spTransform(railways, prj_string_RD) ## SPatialLinesDataFrame
  placesRD <- spTransform(places, prj_string_RD) ## SPatialPointsDataFrame
  
  # Selects the “industrial” (type == "industrial") railways ----------------
  railwaysdf <- railwaysRD[railwaysRD$type == "industrial",]
  # here, we could either 
  ## return the railwaysdf and placesRD 
  ### railwaysPlaces <- cbind(railwaysdf, placesRD)
  ### return (railwaysPlaces) # this unfortunately doen's work yet
  ## or write the railwaysdf and placesRD to different files (as KML/kmz(larger files) files for Google Earth? or as .grd)?
  writeOGR(railwaysdf, file.path("data","railways.kml"), "railways", driver="KML", overwrite_layer=TRUE)
  writeOGR(placesRD, file.path("data","places.kml"), "places", driver="KML", overwrite_layer=TRUE)
  #Warning message:
  #In writeOGR(placesRD, file.path("data", "places.kml"), "places",  :
  #Projected coordinate reference system: for KML driver should be geographical
}

buffer <- function(railwaysPlaces) {
  # Buffer the industrial railway -------------------------------------------
  #Buffers the “industrial” railways with a buffer of 1000m (hint: gBuffer with byid=TRUE)
  ## gBuffer(byid = TRUE)
}

intersect <- function() {
  # Find the place that intersects with the railway -------------------------
  #Find the place (i.e. a city) that intersects with this buffer.
  ## ?intersect
}

visualization <- function() {
  # Create a plot that shows the buffer, points and name of the city --------
  #Create a plot that shows the buffer, the points, and the name of the city
  ## plot() / spplot() , add = TRUE
  ## placeName <- places$name
}
  
  
# Name and population of this city ----------------------------------------
#write down the name of the city and the population of that city as one comment at the end of the script.
## Placename: 
## Population: 


# To do -------------------------------------------------------------------
#create distinct functions 
# write explanatory comments
# description, names, date, above each script
# warning message at writeOGR in preprocessing function (comment below writeOGR function 