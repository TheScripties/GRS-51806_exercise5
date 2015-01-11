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
  ## write the railwaysdf and placesRD to different files (as KML/kmz(larger files) files for Google Earth? or as .grd)?
  writeOGR(railwaysdf, file.path("output","railways.kml"), "railways", driver="KML", overwrite_layer=TRUE) # output or data?
  writeOGR(placesRD, file.path("output","places.kml"), "places", driver="KML", overwrite_layer=TRUE) # output or data?
  #Warning message:
  #In writeOGR(placesRD, file.path("data", "places.kml"), "places",  :
  #Projected coordinate reference system: for KML driver should be geographical
  SDF <- list("railways" = railwaysdf, "places" = placesRD) #SDF as abbreviation of SpatialDataFrame, SDF$railways = railwaysdf, SDF$places = placesRD
  print (SDF) #R does print SDF but
  return (list(SDF)) #R does not return SDF 
}

# Buffer the industrial railway -------------------------------------------
buffer <- function(SDF) { 
  railwaysBuffer <- gBuffer (SDF$railways[1,] , width = 1000 , quadsegs = 0 , byid = TRUE) 
  return (railwaysBuffer)
}

# Find the place that intersects with the railway -------------------------
intersect <- function(SDF, railwaysBuffer) { #Find the place (i.e. a city) that intersects with this buffer.
  intersectPlaces <- intersect(SDF$places , railwaysBuffer)
  placeName <- intersectPlaces$name
  placePopulation <- intersectPlaces$population
  return (intersectPlaces , placeName , placePopulation)
}

# Create a plot that shows the buffer, points and name of the city --------
visualization <- function(railwaysBuffer , intersectPlaces , SDF , placeName) { #placeName as argument when used for legend
  plot(railwaysBuffer , col = "gray80")
  plot(intersectPlaces , add = TRUE , col = "blue") 
  plot(SDF$railways , add = TRUE , col = "purple") 
  box()
  grid()
  scalebar(d = 1000 , below = "kilometers" , lwd = 2) # below should give tect below the scalebar, but doesn't funciton on my pc
  # insert placeName as legend?
  # add x-axis, y-axis, title
  
  # alternative spplot, but it doen't work as of yet, error code of invalid greaphic state and warning messages for min (x) and max(x)
  #spplot(railwaysBuffer, zcol="name", col.regions="gray60", 
  #       sp.layout=list(list("sp.points", intersectPlaces, col="red", pch=19, cex=1.5), 
  #                      list("sp.lines", SDF$railways, lwd=1.5)))
  
}

# Name and population of this city ----------------------------------------
## Placename: Utrecht #placeName
## Population: 100000 #placePopulation

# To do -------------------------------------------------------------------
# create distinct functions (the return statements don't work as of yet, but most of the code should work seperately)
# write explanatory comments
# description, names, date, above each script
# warning message at writeOGR in preprocessing function (comment below writeOGR function