# Original author: Jim Regetz
# Modified for Mosquito cases by: Jose Luis Delgado Davara - @jldelda
# 

#********************************************************************************
#*******************************PART 1*******************************************
#********************************************************************************

#                             POINTS IN POLYGON

# Script to know in which cell of a grid, each point belongs to.
#
# Input Data
#  * CSV table of all the cases of Zika, Dengue and Chikungunya in Río de Janeiro.
#    Each row is a patient with its residencial geo-referenciated with lon and lat.
#    lat-lon coordinate pair. These are derived from occurrence data
#    
#  * Polygon shapefile containing a grid of 1200 square metres.
#    It contains 2651 cells starting from 0. The is of each cell is the
#    number of it. Cell #0 is the one in the upper left corner, and cell #2651 
#    is the one in the right down corner. This file was created with Qgis.
#    Qgis > Vector > Research Tools > Vector Grid > Set same coordenates with CRS.
# 
# Workflow
#  1. Read and clean the Mosquito Borne Disease dataset and tell R to treat 
#     it as a set of spatial points.
#  2. Read in grid polygon of Río de Janeiro.
#  3. Identify which points lie within the cells.
#  4. For each point, get the name of the containing cell (if any), and
#     add it to the Mosquito Borne Disease data table.
#  5. Write results to file, in both CSV and ESRI Shapefile formats,
#     and draw a map of the Mosquitos sightings and cells.
# 
# Output
#  * CSV table similar to the input dataset, but with an additional
#    column specifying the cell (if any) in which the patient lives.
#  * Point shapefile identical to the CSV, but in a format more amenable
#    to direct manipulation in a GIS.
#  * Map visualization.

require(sp)
require(rgdal)
require(maps)

# read in Mosquito data
Mosquito <- read.csv("Mosquito.Borne.Disease.csv")
  #Clean missing values
Mosquito.clean <- Mosquito[!is.na(Mosquito$latitude), ]
Mosquito.clean <- Mosquito.clean[!is.na(Mosquito.clean$longitude), ]
Mosquito.clean <- as.data.frame(Mosquito.clean)

# Turn it into a SpatialPointsDataFrame
coordinates(Mosquito.clean) <- c("longitude", "latitude")

# read in Grid polygons (For this you need the shp, dbf, prj, qpj and shx)
Grid <- readOGR(".", "Grid1")

# tell R that Mosquito coordinates are in the same lat/lon reference system
# as the parks data -- BUT ONLY BECAUSE WE KNOW THIS IS THE CASE!
proj4string(Mosquito.clean) <- proj4string(Grid)

# combine is.na() with over() to do the containment test; note that we
# need to "demote" Grid to a SpatialPolygons object first
inside.Grid <- !is.na(over(Mosquito.clean, as(Grid, "SpatialPolygons")))

# use 'over' again, this time with Grid as a SpatialPolygonsDataFrame
# object, to determine which Cell (if any) contains each sighting, and
# store the Cell id as an attribute of the Mosquito data
Mosquito.clean$Grid <- over(Mosquito.clean, Grid)$id

# Now your Mosquito.clean dataset has a new column with the id of the cell.




#********************************************************************************
#*******************************PART 2*******************************************
#********************************************************************************

#                    Quick analysis of the dataset 

# Count number of point inside and outside the Grid
#Outside the grid
dim(Mosquito.clean[!inside.Grid, ])
# 1305 points
dim(Mosquito.clean[inside.Grid, ])
# 108851

# what fraction of sightings were inside the whole Grid?
mean(inside.Grid)
# [1] 0.9881532. 98% of the points are inside the Grid. 
# 2% is from outside Río de Janeiro.

#Our points of interes are those inside the grid
Mosquito <- Mosquito.clean[inside.Grid, ]

# write the augmented Mosquito dataset to CSV
write.csv(Mosquito, "Mosquito-by-cells.csv", row.names=FALSE)

#********************************************************************************
#*******************************PART 3*******************************************
#********************************************************************************

#                     CREATE DATASET FOR ML ALGORITHM

# With this script we are going to 
# 1.- aggregate and count the number of occurrences each cell per time period.
# 2.- create an empty cell dataset with the time periods.
# 3.- merge both dataset to have the number of occurrences in each cell.






