## code to prepare `picola_SPUs` dataset goes here
here::i_am("data-raw/phenology/picola_SPUs.R")

picola_SPUs <- read.csv("data-raw/phenology/picola_SPUs.csv", stringsAsFactors = FALSE, header = TRUE)

usethis::use_data(picola_SPUs, overwrite = TRUE)
