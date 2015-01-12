# Michiel Blok and Madeleine van Winkel (TheScripties)
# 2015-09-01


# Industrial Railway function --------------------------------------------
# Creates a plot of the buffer, points and name of the intersecting city
industrialRailway <- function() {
  SDF <- preprocessing()
  railwaysBuffer <- buffer(SDF)
  intersectObjects <- intersect(SDF, railwaysBuffer)
  visualization(railwaysBuffer, SDF, intersectObjects)
}

# Preprocessing function --------------------------------------------------
preprocessing <- function(){
  # Download and unzip the files ------------------------------------------
  download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip" , destfile = "data/netherlands-places-shape.zip")
  download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip" , destfile = "data/netherlands-railways-shape.zip")
  railwaysFiles <- unzip(zipfile = "data/netherlands-railways-shape.zip" , exdir = "data." , overwrite = TRUE)
  placesFiles <- unzip(zipfile = "data/netherlands-places-shape.zip" , exdir = "data." , overwrite = TRUE)
  
  # Reference to railways and places files --------------------------------
  dsnRailways <- railwaysFiles[railwaysFiles == "data./railways.shp"] 
  dsnPlaces <- placesFiles[placesFiles == "data./places.shp"]
  
  # Read shapefiles ------------------------------------------------------
  railways <- readOGR(dsnRailways, layer = ogrListLayers(dsnRailways)) 
  places <- readOGR(dsnPlaces, layer = ogrListLayers(dsnPlaces)) 
  
  # Transform files into RD projection ------------------------------------
  # Define CRS object for RD projection
  prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")
  # Perform the coordinate transformation from WGS84 to RD
  railwaysRD <- spTransform(railways, prj_string_RD) 
  placesRD <- spTransform(places, prj_string_RD) 
  
  # Selects the “industrial” (type == "industrial") railways ----------------
  railwaysdf <- railwaysRD[railwaysRD$type == "industrial",]
  writeOGR(railwaysdf, file.path("output","railways.kml"), "railways", driver = "KML", overwrite_layer = TRUE) 
  writeOGR(placesRD, file.path("output","places.kml"), "places", driver = "KML", overwrite_layer = TRUE) 
  #Warning message:
  #In writeOGR(placesRD, file.path("data", "places.kml"), "places",  :
  #Projected coordinate reference system: for KML driver should be geographical
  SDF <- list("railways" = railwaysdf, "places" = placesRD) #SDF as abbreviation of SpatialDataFrame
  return(SDF) 
}

# Buffer the industrial railway -------------------------------------------
buffer <- function(SDF) { 
  railwaysBuffer <- gBuffer(SDF$railways[1,], width = 1000, quadsegs = 0, byid = TRUE) 
  return(railwaysBuffer)
}

# Find the place that intersects with the railway buffer ------------------
intersect <- function(SDF, railwaysBuffer) {
  intersectPlaces <- gIntersection(SDF$places, railwaysBuffer)
  i <- gIntersects(SDF$places, railwaysBuffer, byid = TRUE)
  city <- SDF$places@data[i]
  
  placeName <- city[2]
  placePopulation <- city[4]
  intersectObjects <- c(intersectPlaces, placeName, placePopulation)
  return(intersectObjects)
}

# Create a plot that shows the buffer, points and name of the city --------
visualization <- function(railwaysBuffer, SDF, intersectObjects) { 
  plot(railwaysBuffer, col = "gray80", main = "City intersected by railwaybuffer", axes=T)
  plot(intersectObjects[[1]], add = TRUE, col = "blue") 
  plot(SDF$railways, add = TRUE, col = "purple") 
  box()
  grid()
  scalebar(d = 1000, label = "1000 kilometers", lwd = 1) 
  legend("topright", legend = intersectObjects[2], bty = "n", title = "City Name")
}

# Name and population of this city ----------------------------------------
## Placename: Utrecht #intersectObjects[2]
## Population: 100000 #intersectObjects[3]