# Walsh data only recorded one begin (2) and one finished flowering dates (3) for each tree. Because all trees were observed every observation day in an orchard, states on dates other than the recorded dates are implicit in the data. For example if Tree A was recorded as
# Start: Wednesday
# End: Friday
# and Tree B was recorded as
# Start: Monday
# End: Thursday
# We can infer that Tree A was in state 1 on Monday and Tree B was in state 2 on Wednesday.

#This script makes those implicitly recorded states explicit.

here::i_am("data-raw/phenology/cleaning/4.infer_implicit_phenophases.R")
library(dplyr)
library(lubridate)

phenology_data <- read.csv(here::here('data-raw/phenology/intermediate/derived_phenophases.csv'), header=TRUE, stringsAsFactors = FALSE) %>%
    mutate(Date =lubridate::date(Date)) # make dates dates for nice merges

# TEST that dates didn't get scrambled
assertthat::assert_that(all(!is.na(phenology_data$Date)))

# infer phenophases for walsh
walsh <- filter(phenology_data, Source == "Chris Walsh")

# add a column for the first recorded done flowering day
donerf <- walsh %>%
    filter(State == 3) %>%
    group_by(Index) %>%
    dplyr::summarise(Done_RF = min(DoY))

walsh <- left_join(walsh, donerf)

## build a dataframe with all possible dates for Walsh data given Site/Year/Orchard observations

### dates observations were made at a site in an orchard in a given year
doys <- walsh %>%
    select(Site, Year, Orchard, DoY, Date) %>%
    distinct()

### observation metadata (individual tree and where/when they are)
individualmeta <- walsh %>%
    select(-DoY, -Date, -Phenophase_Recorded, -State) %>%
    distinct()

### full observation matrix (observations hidden in First and Last RF)
walsh_grid <- full_join(doys, individualmeta) %>%
    arrange(Index, DoY, Date)

### fill in observations
inferred_walsh <- walsh_grid %>%
    mutate(Phenophase_Inferred = case_when(DoY < First_RF ~ 1,
                                           First_RF <= DoY & DoY < Done_RF ~ 2,
                                           First_RF == Last_RF & is.na(Done_RF) ~ 2, # cases where receptive80 was not recorded
                                           Done_RF <= DoY ~ 3)) %>%
    select(-contains("_RF"))

# TEST that there are no NA inferences
assertthat::are_equal(which(is.na(inferred_walsh$Phenophase_Inferred)),integer(0))

## merge in observations

full_walsh <- left_join(inferred_walsh, walsh)

# TEST that inferred phenophases always match derived phenophases
inf <- dplyr::filter(full_walsh, State %in% c(1,2,3)) %>%
    dplyr::filter(Phenophase_Inferred != State)
assertthat::assert_that(nrow(inf) == 0)

# rename columns
full_walsh <- full_walsh %>%
    select(-State) %>%
    dplyr::rename(State = Phenophase_Inferred)

# merge back into full phenology dataset
phendf <- full_join(phenology_data, full_walsh) %>% # this is a fully inferred dataset.
    select(-contains("_RF")) %>%
    select(Index, DoY, Date, Phenophase_Recorded, State, Sex, Year, Site, Orchard, Clone, Tree, X, Y, Source) #nicely order columns

# TEST for obvious data drop
assertthat::assert_that(nrow(phenology_data) < nrow(phendf))

#test that all years match date
tyear <- lubridate::year(phendf$Date)
assertthat::are_equal(length(which(tyear != phendf$Year)), 0) #TRUE

# Rename column Clone to preferred term Genotype
phendf <- phendf %>% dplyr::rename(Genotype = Clone)

# write
write.csv(phendf, here::here('data-raw/phenology/picola_state.csv'), row.names = FALSE, quote = FALSE)

