# USA Crime Tracker — Simplified R Shiny App

This is a simplified R Shiny re-implementation of the Python dashboard from  
https://github.com/UBC-MDS/DSCI-532_2026_13_usa-crime-tracker

The app loads two CSV files, filters crime data by year, and displays:
- A value box showing total violent crimes
- A line chart showing violent crime rate over time



## Running the App Locally

### 1. Install dependencies

This project uses **renv** for reproducible environments.

```r
install.packages("renv")
renv::restore()
