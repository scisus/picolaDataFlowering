## code to prepare `picola_site_coord_elev` dataset goes here
here::i_am("data-raw/locations/picola_site_coord_elev.R")

library(rgbif)

site_coord <- read.csv(here::here("data-raw/locations/picola_site_coord.csv"), header = TRUE, stringsAsFactors = FALSE)

siteelevs <- rgbif::elevation(latitude= site_coord$lat, longitude = site_coord$lon, elevation_model = "srtm1", username="susannah2")
colnames(siteelevs) <- c("lat", "lon", "el")
picola_site_coord_elev <- dplyr::full_join(site_coord, siteelevs)

usethis::use_data(picola_site_coord_elev, overwrite = TRUE)
