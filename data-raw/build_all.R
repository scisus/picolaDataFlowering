here::i_am("data-raw/build_all.R")

# Run the scripts that clean and format the phenology data.
callr::rscript(here::here("data-raw/phenology/cleaning/run_all.R"))

# Run the scripts that publish phenology state and event data as R data objects.
callr::rscript(here::here("data-raw/phenology/picola_state.R"))
callr::rscript(here::here("data-raw/phenology/picola_event.R"))
callr::rscript(here::here("data-raw/phenology/picola_SPUs.R"))

# Run the scripts that derive and publish location data as R data objects.
callr::rscript(here::here("data-raw/locations/picola_site_coord.R"))
callr::rscript(here::here("data-raw/locations/picola_site_coord_elev.R"))
callr::rscript(here::here("data-raw/locations/picola_parent_locs.R"))

