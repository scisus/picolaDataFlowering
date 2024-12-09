#Derive common phenophases for Wagner and Walsh data

here::i_am("data-raw/phenology/cleaning/3.derive_phenophases.R")
library(dplyr)

# Read in cleaned and combined phenology data. This data was generated with
# clean_pheno.R
# combine_wagner_walsh.R

phenology_data <- read.csv(here::here('data-raw/phenology/intermediate/Combined_Wagner_Walsh_pollination_phenology.csv'), header = TRUE, stringsAsFactors = FALSE)

# derive phenophases that can be compared between sources -----------

# categorize phenophases as
#stage 1 - not yet flowering,
#stage 2 - flowering, or
#stage 3 - done flowering

no_flowers <- '0'
before_flowering <- c('1', '2.5', '-') #stage 1
flowering <- c('3', '3.5', '4', '4.5', '5', 'pollenshed20', 'receptive20') #stage 2
after_flowering <- c('-', 'receptive80', 'pollenshed80') #stage 3


# Calculate bounds on flowering period based on first and last observed flowering day --------------
phen <- phenology_data %>%
    group_by(Index)

first_recorded_flowering <- phen %>%
    filter(Phenophase %in% flowering) %>%
    dplyr::summarise(First_RF = min(DoY)) # this is the first date we have a record of active for each tree/sex/orchard/year. it is not necessarily the true start date.
assertthat::assert_that(all(!is.na(first_recorded_flowering$First_RF)))
phen <- left_join(phen, first_recorded_flowering)

last_recorded_flowering <- phen %>%
    filter(Phenophase %in% flowering) %>%
    dplyr::summarise(Last_RF = max(DoY)) # this is the last date we have a record of active for each tree/sex/orchard/year. it is not necessarily the true end date.
phen <- left_join(phen, last_recorded_flowering)

    #TEST that no data got dropped or added ---------
assertthat::are_equal(nrow(phen), nrow(phenology_data))
    #TEST that all the trees with NA First/Last recorded flowering days have 0 or - phenophases
assertthat::assert_that(all(unique(phen[which(is.na(phen$First_RF)),]$Phenophase) %in% c("0", "-")))
assertthat::assert_that(all(unique(phen[which(is.na(phen$Last_RF)),]$Phenophase) %in% c("0", "-")))



# Assign a phenological stage 1, 2, or 3 (or 0 if didn't flower at all) -----------
temp_phen_derived <- phen %>%
    mutate(Phenophase_Derived =
               case_when(Phenophase %in% before_flowering & DoY < First_RF ~ 1,
                         DoY >= First_RF & DoY <= Last_RF ~ 2,
                         Phenophase %in% after_flowering & DoY > Last_RF ~ 3,
                         is.na(First_RF) & is.na(Last_RF) ~ 0))

#TEST that the last recorded flowering date is always after the first
foo <- filter(temp_phen_derived, !(is.na(First_RF) | is.na(Last_RF)))
assertthat::assert_that(all(foo$First_RF <= foo$Last_RF))
#TEST that all phenophases are 0,1,2 or 3
assertthat::assert_that(all(temp_phen_derived$Phenophase_Derived %in% c(0,1,2,3)))
#TEST that no tree with a 0 in the original data has anything other than 0s as phenophase now
assertthat::assert_that(all(which(temp_phen_derived$Phenophase==0) %in%
which(temp_phen_derived$Phenophase_Derived == 0)))

phen_derived <- temp_phen_derived %>%
    dplyr::rename(Phenophase_Recorded = Phenophase, State = Phenophase_Derived)

# write out dataset with derived phenophases
write.csv(phen_derived, here::here('data-raw/phenology/intermediate/derived_phenophases.csv'), row.names = FALSE)


