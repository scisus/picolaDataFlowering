## code to prepare `picola_event` dataset goes here
here::i_am("data-raw/phenology/picola_event.R")

picola_event <- read.csv(here::here("data-raw/phenology/picola_event.csv"), stringsAsFactors = FALSE, header = TRUE)

usethis::use_data(picola_event, overwrite = TRUE)

