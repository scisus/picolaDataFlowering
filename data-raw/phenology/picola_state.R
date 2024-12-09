## code to prepare `picola_state` dataset goes here
here::i_am("data-raw/phenology/picola_state.R")

picola_state <- read.csv("data-raw/phenology/picola_state.csv", stringsAsFactors = FALSE, header = TRUE)

usethis::use_data(picola_state, overwrite = TRUE)
