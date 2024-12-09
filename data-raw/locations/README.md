# Site location data

Contains location information for 7 seed orchard sites and 2 more northerly sites used for phenology predictions. 

Elevation data for sites pulled from GeoNames via `rgbif::elevation` in R using [srtm1](https://doi.org/10.5066/F7PR7TFT) (USGS EROS Archive - Digital Elevation - Shuttle Radar Topography Mission (SRTM) Global). Sampled at a resolution of 2 arc-second by 1 arc-second (~60m x 30m).

Elevation data for grid squares pulled from GeoNames via `rgbif::elevation` in R using [gtopo30](https://doi.org/10.5066/F7DF6PQS)(USGS EROS Archive - Digital Elevation - Global 30 Arc-Second Elevation (GTOPO30)). Sampled at a resolution of 30 arc seconds (~1 km)

- `picola_site_coord.kml` Seed Orchard latitude and longitude data collected by CS Tysor manually using Google Earth, and verified by Jack Woods as the locations of the BC seed orchards used in the phenology datasets in `../phenology`, specifically those from Chris Walsh and Rita Wagner.

- `picola_site_coord.csv` Site lat and lon coordinates extracted from `picola_site_coord.kml`, with additional comparison sites "trench" and "border", with lat and lon coordinates from ClimateBC. Built by `picola_site_coord.R`.

- `picola_site_coord_elev.R` Augments site lat and lon with elevation from `rgbif` and publishes `picola_site_coord_elev` dataset.

- `ParentTreeExtractReport_ParentTrees_2014_05_15_13_38_17.csv` Parent tree info extracted from BC Ministry of Forests SPAR on 2014-05-15. 

- `picola_parent_locs.csv` latitude, longitude and elevations of parent tree locations extracted from `ParentTreeExtractReport_ParentTrees_2014_05_15_13_38_17.csv`.


