# Extract "Orchard Sites" layer from picola_site_coord.kml and write out picola_site_coord.csv
here::i_am("data-raw/locations/picola_site_coord.R")

library(sf)
library(dplyr)

kml <- sf::read_sf(here::here('data-raw/locations/picola_site_coord.kml'), layer = "Orchard Sites")
coords <- sf::st_coordinates(kml)

# Augment the long names in the kml file with short names and indicate
# that they are orchards
shortnames <- dplyr::tribble(
    ~Site, ~orchard, ~longname,
    "Sorrento",TRUE,"Sorrento Seed Orchard",
    "Kalamalka",TRUE,"Kalamalka Seed Orchard",
    "Vernon",TRUE,"Vernon Seed Orchard Company",
    "PRT",TRUE,"Pacific Regeneration Technologies",
    "PGTIS",TRUE,"Prince George Tree Improvement Station",
    "Tolko",TRUE,"TOLKO",
    "KettleRiver",TRUE,"Kettle River Seed Orchards",
)

# Add two more comparison sites not in the kml file,
# which are not orchards
comparison_sites <- dplyr::tribble(
    ~Site, ~orchard, ~longname, ~lat, ~lon,
    "Border",FALSE,"Yukon-BC border",59.532,-127.791,
    "Trench",FALSE,"Rocky Mountain Trench",56.155,-124.108,
)

picola_site_coord <- data.frame(longname = kml$Name, lat = coords[,2], lon = coords[,1]) %>%
    right_join(shortnames, by="longname") %>%
    bind_rows(comparison_sites) %>%
    select(Site, orchard, longname, lat, lon)

write.csv(picola_site_coord, here::here('data-raw/locations/picola_site_coord.csv'), row.names = FALSE, quote = FALSE)
