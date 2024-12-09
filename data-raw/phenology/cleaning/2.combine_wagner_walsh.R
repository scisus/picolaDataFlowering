# Combine Wagner and Walsh data
# This script transforms the Walsh data into a format like that of the Wagner data and combines the two sets together. Pulls in datasets created by clean_pheno.R

here::i_am("data-raw/phenology/cleaning/2.combine_wagner_walsh.R")

library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)


#read in data
rw <- read.csv(here::here('data-raw/phenology/from_Rita_Wagner/data_cleaned/PGTIS_pheno_1997_2012_cleaned.csv'), header = TRUE, stringsAsFactors = FALSE) #data from Rita Wagner
cw <- read.csv(here::here('data-raw/phenology/from_Chris_Walsh/data_cleaned/walsh_pheno_2006_2011_cleaned.csv'), header = TRUE, stringsAsFactors = FALSE) #data from Chris Walsh


# prepare rw and cw for combining ------------------
rw_prep <- rw %>% # data from Rita Wagner
    mutate(Site = "PGTIS") %>% #Add site col
    mutate(Source = "Rita Wagner") %>% #Add source col
    mutate(Date = paste(Year, Month, Day, sep = "-")) %>% # Add date col to match cw
    select(-Month, -Day, -Page) #drop unneeded cols

# add columns to cw to match rw data
cw_prep <- cw %>%
    select(Orchard, Clone, X, Y, starts_with("receptive"), starts_with("pollen"), Site) %>% #drop unneeded cols
    mutate(Source = "Chris Walsh") %>% #add source col
    mutate(Clone = as.numeric(Clone)) %>%
    gather(starts_with("receptive"), starts_with('pollen'), key = "Phenophase", value = "Date") %>% # gather date cols into phenophase and date like in rw %>%
   # filter(!is.na(Date)) %>% # drop days without an observation
    mutate(Sex = case_when(str_detect(Phenophase, "receptive") ~ "FEMALE",
                           str_detect(Phenophase, "pollen") ~ "MALE")) %>% #add sex column
    mutate(Year = year(Date)) %>%
    filter(!is.na(Year)) # drop NAs

# combine data  and add useful columns --------------
phenology_data <- full_join(rw_prep, cw_prep) %>%
    #add day of year
    mutate(DoY = yday(Date)) %>%
    # add empty Index column
    mutate(Index = NA) %>%
    #order columns for readability
    select(Index, DoY, Phenophase, Sex, Year, Site, Orchard, Clone, Tree, X, Y, Date, Source)

# add an index that uniquely identifies a given tree's male or female pollination phenology record in each year and orchard
phenology_data$Index <- group_indices(phenology_data, Site, Orchard, Year, Tree, Sex, Clone, X, Y)

# write data to file ---------------

write.csv(phenology_data, here::here('data-raw/phenology/intermediate/Combined_Wagner_Walsh_pollination_phenology.csv'), row.names=FALSE)






