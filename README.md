# Location-Prediction-algorithm

Location Prediction Algorithm is an algorithm that aims to predict the next Zika outbreak in Río de Janeiro (City level).

This Repository is not finished. This is just the data preparation part. Feel free to clone it and keep working with your data to create a better algorithm.

## Methodology

I have created a grid of 1,200 squares meters to identify every cell of the city and give them different characteristics. The grid has exactly 2651 cells that overlay the city of Rio de Janeiro.

The following image helps you to undertand the concept. 
![Algo Grid](/Explanations/map grid.png)

This may also help to understand the labels.
![Algo Grid2](/Explanations/map grid with labels.png)

## The datasets
The datasets I provide in this repo is:
* Shapefile of the grid with 2651 cells.
* Shapefile of Rio de Janeiro city.

**I don´t provide the Mosquito.Borne.Disease.csv dataset because I don't own the rights to do so. However, if you have that dataset, you can run the R script in Points in grid.R.**

## Next steps to build the algorithm (To do list)
* Create a "master" dataset with as many rows as cells multiplied by time periods. Example: I we are analysing per week, we will need each cell repeated as many weeks in our study period.
* Aggregate the Mosquito Borne Disease dataset in a way it has a common id with the previous dataset.
* Merge both datasets.

## Understanding this repository
This repository is just a methodology proposed for the participants of the [Alert Zika!](www.alerta-zika.org) Data Expedition event.

Anyone should be free to use this methodology or any other for the event.
