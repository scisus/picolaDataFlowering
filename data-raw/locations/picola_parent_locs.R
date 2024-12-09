## code to prepare `picola_parent_locs` dataset goes here
here::i_am("data-raw/locations/picola_parent_locs.R")

library(dplyr)

pardat <- read.csv(here::here("data-raw/locations/ParentTreeExtractReport_ParentTrees_2014_05_15_13_38_17.csv"))

# parent locations and elevations
picola_parent_locs <- pardat %>%
    select(Parent.Tree.Number, contains("Latitude"), contains("Longitude"), Elevation, Seed.Plan.Zone.Code) %>%
    mutate(lat = Latitude.Degrees + Latitude.Minutes/60 + Latitude.Seconds/60^2,
           lon = -(Longitude.Degrees + Longitude.Minutes/60 + Longitude.Seconds/60^2)) %>%
    select(Clone = Parent.Tree.Number, SPU = Seed.Plan.Zone.Code, lat, lon, el = Elevation)

usethis::use_data(picola_parent_locs, overwrite = TRUE)
