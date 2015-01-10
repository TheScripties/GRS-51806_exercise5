# Description
# Michiel Blok and Madeleine van Winkel (TheScripties)
# 2015-09-01

# Download and unzip files ------------------------------------------------
#Bonus (optional!): if you can also download and unzip this within the script.
download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip" , destfile = "data/netherlands-places-shape.zip")
download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip" , destfile = "data/netherlands-railways-shape.zip")
railwaysFiles <- unzip(zipfile = "data/netherlands-railways-shape.zip" , exdir = "data." , overwrite = TRUE)
placesFiles <- unzip(zipfile = "data/netherlands-places-shape.zip" , exdir = "data." , overwrite = TRUE)
# Reference to railways and places files
dsnRailways <- railwaysFiles[railwaysFiles == "data./railways.shp"] ## possibly change to string formatting, otherwise --> dsnRailways <- "data./railways.shp"
dsnPlaces <- placesFiles[placesFiles == "data./places.shp"] ## possibly change to string formatting, otherwise  --> dsnPlaces <- "data./places.shp"
#dir.create("data", showWarnings = FALSE)
#dsn_rail = file.path("data", railwaysFile)
#dsn = file.path("data","route.kml")

# Read shape files --------------------------------------------------------
#ogrListLayers(dsn) ## to find out what the layers are
railways <- readOGR(dsnRailways, layer = ogrListLayers(dsnRailways)) ## = SpatialLinesDataFrame
places <- readOGR(dsnPlaces, layer = ogrListLayers(dsnPlaces)) ## = SpatialPointDataFrame

# Transform files into RD projection --------------------------------------
# Define CRS object for RD projection
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")

# Perform the coordinate transformation from WGS84 to RD
railwaysRD <- spTransform(railways, prj_string_RD) ## SPatialLinesDataFrame
placesRD <- spTransform(places, prj_string_RD) ## SPatialPointsDataFrame

# put both in single data frame
#proj4string(myroute) <- prj_string_WGS

# Select "industrial"
#  Selects the “industrial” (type == "industrial") railways
railwaysIndustrial <- railwaysRD$type == "industrial" ## It returns a TRUE/FALSE list, with 1 TRUE statement, I forgot how to get this right...
for (i in length(railwaysIndustrial)){
     if(railwaysIndustrial == TRUE) iIndustrial <- i
}
railwaysIndustrial[iIndustrial]
iIndustrial

# Buffer the industrial railway -------------------------------------------
#Buffers the “industrial” railways with a buffer of 1000m (hint: gBuffer with byid=TRUE)

# Find the place that intersects with the railway -------------------------
#Find the place (i.e. a city) that intersects with this buffer.

# Create a plot that shows the buffer, points and name of the city --------
#Create a plot that shows the buffer, the points, and the name of the city

# Name and population of this city ----------------------------------------
#write down the name of the city and the population of that city as one comment at the end of the script.


# To do -------------------------------------------------------------------
#create distince functions 
# write explanatory comments
# description, names, date, above each comment

# exercise ---------------------------------------------------------------- 
## (the line above is created with Code --> IOnsert Section)
##Second, create a clear and documented script as part of a new Rstudio Project (set-up as descriped in lesson 3) that: