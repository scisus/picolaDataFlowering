# This script reads and cleans pollination phenology data provided by Rita Wagner and Chris Walsh

# Susannah Tysor <susannah@pobox.com>

here::i_am("data-raw/phenology/cleaning/1.clean_pheno.R")

library(plyr)
library(stringr)
library(lubridate)
library(dplyr)
library(readxl) # for reading excel files
source(here::here("data-raw/phenology/cleaning/clean_pheno_functions.R"))

# I Read in and clean Prince George Tree Improvement Station data from Rita Wagner -------------------
    # A Read in transcribed data from Rita Wagner (transcribed by Rob Johnstone) ---------
wagner <- here::here("data-raw/phenology/from_Rita_Wagner/data_transcribed/PGTIS_pheno_1997_2012.xlsx")

coltypes <-  c(Year = "numeric", Sex = "text", Clone = "numeric", Tree = "numeric", X = "text", Y = "numeric", Month = "numeric", Day = "text", Phenophase = "text", Page = "numeric") #Days are read in as text so irregular days don't get stripped

fromRW <- read_excel_tidy(path = wagner, orchard_ids = c(228, 223, 220), sheets = c(1:3), col_classes = coltypes) #read in all sheets from Wagner and remove empty rows

# drop any duplicates
fromRW <- unique(fromRW)

# add a unique record identifier for every row
fromRW$UID <- c(1:nrow(fromRW))

    # B Correct impossible records in original data ------------------------


        # 1.  Clone 1540 at P 49 in 2009 has phenophases (for males) 4,4,0. The zero should clearly be a dash. Clone 1583 at H 15 in 2010 has phenophases (for males) 0,4,0,0. I'm pretty sure the 4 should be a dash. See Lab Notebook entry 2019-01-27
fromRW[which(fromRW$Clone == 1540 & fromRW$Orchard == 228 & fromRW$Sex == "MALE" & fromRW$X == "P" & fromRW$Y == 49 & fromRW$Page == 43 & fromRW$Year == 2009 & fromRW$Day == 10 ),]$Phenophase <- '-'

fromRW[which(fromRW$Clone == 1583 & fromRW$Orchard == 228 & fromRW$Sex == "MALE" & fromRW$X == "H" & fromRW$Y == 15 & fromRW$Page == 46 & fromRW$Year == 2010 & fromRW$Day == 31 ),]$Phenophase <- 0

    # C. Add data missed during transcription --------
        # 1 Add data on non-flowering clones
nonflowering <- read.csv(here::here("data-raw/phenology/from_Rita_Wagner/data_transcribed/wb220_non-flowering_clones.csv"), header = TRUE, stringsAsFactors = FALSE)

fromRW <- add_new_records_to_df_with_UID(new_records = nonflowering, old_dataframe = fromRW, uid_col = fromRW$UID)

        # 2 Add on locations missed during transcription.

missed_locations <- read.csv(here::here("data-raw/phenology/from_Rita_Wagner/data_transcribed/cpf223_missed_locations.csv"), stringsAsFactors = FALSE, header = TRUE) #from cpf223
missed_locations <- cbind(missed_locations, Orchard = "223", Year = 1999)
#If Y, Clone, Year, and Orchard match, replace X in fromRW with cloneid data
fromRW <- dplyr::full_join(fromRW, missed_locations, by = c("Y","Clone", "Year", "Orchard", "Tree")) # merge
fromRW <- destroy_factors(fromRW) #format
fromRW <- na_colmerge(fromRW, "X.x", "X.y") #clean
colnames(fromRW)[colnames(fromRW) == "X.x"] <- "X"

        # 3. Add missed columns from wb220 p. 10
missed_columns <- read.csv(here::here("data-raw/phenology/from_Rita_Wagner/data_transcribed/wb220_missed_columns.csv"), stringsAsFactors = FALSE, header = TRUE)
missed_columns <- cbind(Orchard = 220, missed_columns)
fromRW <- add_new_records_to_df_with_UID(missed_columns)

        # 4. Add 1999 blk 228 clones from wb220 data. There are 2 ramets of clone 1464 from blk228 at the bottom of p. 10 for wb220. I don't have any other blk228 data from blk228 in that year. See lab notebook 2016-11-28 for more details.
blk_ninetynine <- read.csv(here::here("data-raw/phenology/from_Rita_Wagner/data_transcribed/blk228_1999_data.csv"), stringsAsFactors = FALSE, header = TRUE)
blk_ninetynine <- cbind(Orchard = 228, blk_ninetynine)
fromRW <- add_new_records_to_df_with_UID(blk_ninetynine)

    # D. Remove data transcribed that does not exist in original dataset ----------
        # 1 Clone 1473 at U 6 in Orchard 223 MALE in 2007 has no data record in original. Drop
fromRW <- fromRW[-which(fromRW$Page == 29 & fromRW$Clone == 1473 & fromRW$Orchard == 223 & fromRW$Sex == "MALE" & fromRW$X == 'U' & fromRW$Y == '6'),]

        # 2 Appears to be failure of excel autofill or just a weird mistake. Data doesn't appear to actually come from original datasheets. See Lab Notebook 2017-02-21

del_ind <- which(fromRW$Orchard == 220 & fromRW$Clone == 1542 & fromRW$X == "AA" & fromRW$Page == 21)
fromRW <- fromRW[-del_ind, ]
## Remove duplicates before proceeding ---------------

fromRW <- unique(fromRW)

    # E. Clean and standardize phenophases --------------
# Data for Phenophase should be whole numbers, '-', NA, or x.5.

weird_phenophase <- unique(fromRW$Phenophase) # get a list of all phenophases in the dataset

fromRW$Phenophase <- fixweird(fromRW$Phenophase, c('x', 'Z', 'X'), '-') #This is ok only because 'X' isn't actually in the data. See Notebook entry 2015-11-28 for more information
### correct fractional entries to between phenophase categories
fromRW$Phenophase <- fixweird(fromRW$Phenophase, c('4\\5', '0.8'), '4.5')
fromRW$Phenophase <- fixweird(fromRW$Phenophase, '0.75', '3.5')
fromRW$Phenophase <- fixweird(fromRW$Phenophase,'0.666666666666667', '2.5') #0.66666666666666663
fromRW$Phenophase <- fixweird(fromRW$Phenophase,"4/X", '4')
fromRW$Phenophase <- fixweird(fromRW$Phenophase,"X/5", '5')

    # F. Correct non-missing data transcription errors --------
        # 1 Phenophase Corrections. --------------
#Transcription errors for MALE flowers for clones 985 at A 27 and 1479 at F 15 on p. 39. See Lab Notebook 2017-03-07 Sixth case
fromRW[which(fromRW$Page == 39 & fromRW$Clone == 985 & fromRW$Orchard == 220 & fromRW$Day == 7 & fromRW$Sex == 'MALE' & fromRW$Y == 27),]$Phenophase <- '-'

fromRW[which(fromRW$Page == 39 & fromRW$Clone == 1479 & fromRW$Orchard == 220 & fromRW$Day == 7 & fromRW$Sex == 'MALE' & fromRW$Y == 15),]$Phenophase <- '-'

        # 2 Sex Corrections -----------
fromRW$Sex[which(fromRW$Sex == "FEAMLE")] <- "FEMALE"

        # 3 Day Corrections --------------------
# Fix a transcription error where May 31 was recorded as May 37 at Orchard 223 in 2010
fromRW[which(fromRW$Orchard == 223 & fromRW$Year == 2010 & fromRW$Day == 37),]$Day <- 31
          # a. Fix obviously weird or wrong based on original data
fromRW$Day <- fixweird(fromRW$Day, weird = as.character(5/7), replacement = 5)
fromRW$Day <- fixweird(fromRW$Day, weird = as.character(4/5), replacement = 4.5)
fromRW$Day <- fixweird(fromRW$Day, weird = "19/20", replacement = 19.5)
fromRW$Day <- fixweird(fromRW$Day, weird = "28/29", replacement = 28.5)
fromRW$Day <- fixweird(fromRW$Day, weird = "37", replacement = 27)
fromRW$Day <- as.numeric(fromRW$Day)

            # b. Correct a subtle typo where the 11th of the month was transcribed as the first

#### No collection on the first, only on the 11th that year. Correct 1st to 11th. See Lab notebook 2017-02-21 Third Case for more info.
rpl_ind <- which(fromRW$Orchard == 220 & fromRW$Year == 2000 & fromRW$Day == 1)
fromRW$Day[rpl_ind] <- 11

            # c. Dates from 2003 used for 2004 data. Replace with 2004 dates from original data. See 2017-02-21 Fourth case for more info.
rpl_ind <- which(fromRW$Orchard == 220 & fromRW$Year == 2004 & fromRW$Day < 9)
fromRW$Month[rpl_ind] <- 5 # replace incorrect months

wrongday <- c(2,4,6,9)
replday <- c(25,27,31,2)

for (i in 1:length(wrongday)) { #replace incorrect days
    index <- which(fromRW$Orchard == 220 & fromRW$Year == 2004 & fromRW$Day == wrongday[i])
    fromRW$Day[index] <- replday[i]
}


        # 4 Location Corrections ---------------
            # a. Update the locations of incorrectly transcribed wb220 clones

wb220_location_updates <- read.csv(here::here("data-raw/phenology/from_Rita_Wagner/data_transcribed/wb220_corrected_locations.csv"), stringsAsFactors = FALSE) # dataset describing corrections that need to be made

### loop through replacement data, find matches in dataset, and make replacements
for (i in 1:nrow(wb220_location_updates)) {
    tbreplaced <- which(fromRW$Orchard == 220 &
                            fromRW$Clone == wb220_location_updates$CloneID[i] &
                            fromRW$X == wb220_location_updates$X.Old[i] &
                            fromRW$Y == wb220_location_updates$Y.Old[i] &
                            fromRW$Page == wb220_location_updates$Pages[i]) # get rows where replacements should be made
    fromRW$X[tbreplaced] <- wb220_location_updates$X.New[i]
    fromRW$Y[tbreplaced] <- wb220_location_updates$Y.New[i]
}

            # b. Transcription error in Y location for individual tree - see Lab Notebook 2019-01-27
#fromRW[which(fromRW$Page == 21 & fromRW$Clone == 1542 & fromRW$Orchard == 220 & fromRW$X == 'AA' & fromRW$Y == 43),]$Y <- 25

    # G. Resolve NA observations (blanks in transcribed data) -----------------

## Resolve NA observations [Remove NA Phenophases that represent no observation. Change NAs to `-` if a tree was observed, but not flowering]

NA_criteria <- read.csv(here::here("data-raw/phenology/from_Rita_Wagner/legends/legend_decisions_data.csv"), stringsAsFactors = FALSE)
fromRW <- remove_and_replace_NAs(fromRW, NA_criteria, id = c("Orchard", "Year","Page"))


    # H Copy-paste transcription errors -------------
# The way the data was transcribed led to a kind of copy/paste error where dates and phenophases for one tree were attributed to another tree. These (and other kinds of errors) can be identified by finding trees whose phenophase record differs from the number of days observations were made in a given year

reindex <- function() {
  fromRW <- unique(fromRW)
  fromRW$Index <- group_indices(fromRW, Orchard, Year, Tree, Sex, Clone, X, Y)
  return(fromRW)
}

find_obs_day_mismatches <- function() {

  # Identify trees whose phenophase record is longer than the number of days observations were made in a given year
  observation_days <- fromRW %>% dplyr::group_by(Index) %>%
    dplyr::summarise(num_days_observed = length(unique(Day))) #number of days a tree is observed
  observations <- fromRW %>% dplyr::group_by(Index) %>%
    dplyr::summarise(num_observations = length(Phenophase)) #number of observations a tree has recorded
  obs_and_num_obs_mismatch_index <- full_join(observation_days, observations) %>%
    filter(num_days_observed != num_observations)
  return(obs_and_num_obs_mismatch_index)
}

fromRW <- reindex()
badlist <- find_obs_day_mismatches()
head(badlist)
# how many records have this problem

fromRW %>% filter(Index %in% badlist$Index) %>% nrow()

    # 1. Correction for 223 2010 May 27 ####
#All trees in Orchard 223 in 2010 have two recorded phenologies for May 27. The second should be May 31.

tbrindex <- filter(fromRW, Orchard==223, Year==2010, Month==5, Day==27) %>% # create an index of records recorded as May 27 that should actually be May 31 (these are To Be Replaced)
  group_by(Index) %>%
  mutate(count = length(Index)) %>%
  filter(count == 2) %>%
  summarise(tbr = max(UID))

fromRW$Day[which(fromRW$UID %in% tbrindex$tbr)] <- 31

    # 2. Correction for Index 3033 ####
fromRW <- reindex()
badlist <- find_obs_day_mismatches()
head(badlist)
fromRW %>% filter(Index %in% badlist$Index) %>% nrow()

filter(fromRW, Index %in% c(3033)) %>%
  arrange(UID)
# it looks like a bunch of trees from 2002 were given the wrong year. Should be 2002
wrongyear <- filter(fromRW, Page %in% c(21,22), Orchard==228, Year == 2001)

fromRW[which(fromRW$UID %in% wrongyear$UID & fromRW$Index %in% wrongyear$Index),]$Year <- 2002

# test
wy <- filter(fromRW, Page %in% c(21,22), Orchard==228, Year == 2001)
nrow(wy) == 0 #true

    # 3. Fix Index 4104 ####################
fromRW <- reindex()
badlist <- find_obs_day_mismatches()
head(badlist)
fromRW %>% filter(Index %in% badlist$Index) %>% nrow()

filter(fromRW, Index %in% c(4104)) %>%
  arrange(UID)

# one of the duplicate day obs just doesn't occur in the dataset. drop it
fromRW <- fromRW[- which(fromRW$Orchard==228 & fromRW$Year==2008 & fromRW$Sex=="FEMALE" & fromRW$Clone==983 & fromRW$X=="U" & fromRW$Y=="17" & fromRW$Day==9 & fromRW$Phenophase=="-" & fromRW$Page==39),]

#test
td <- filter(fromRW, Index %in% c(4104)) %>%
  arrange(UID)
nrow(td) == 2 #true

    # 4. Fix Index 4109 ############
fromRW <- reindex()
badlist <- find_obs_day_mismatches()
head(badlist)
fromRW %>% filter(Index %in% badlist$Index) %>% nrow()

filter(fromRW, Index %in% c(4109)) %>%
  arrange(UID)

# one of the duplicate day obs just doesn't occur in the dataset. drop it
fromRW <- fromRW[- which(fromRW$Orchard==228 & fromRW$Year==2008 & fromRW$Sex=="FEMALE" & fromRW$Clone==987 & fromRW$X=="AA" & fromRW$Y=="44" & fromRW$Day==9 & fromRW$Phenophase=="4" & fromRW$Page==39),]

#test
td <- filter(fromRW, Index %in% c(4104)) %>%
  arrange(UID)
nrow(td) == 2 #true

# drop index



    # I. Add convenience columns --------------
      # 1. Drop UID and Index used for copy paste transcription error cleanup.

#MAYBE KEEP UID THO?

fromRW <- dplyr::select(fromRW, -UID, -Index)


# 2. Make sure no dups

fromRW <- unique(fromRW)

    # J. Write out Wagner/PGTIS data ---------------
write.csv(fromRW, file = here::here("data-raw/phenology/from_Rita_Wagner/data_cleaned/PGTIS_pheno_1997_2012_cleaned.csv"), row.names = FALSE )


# II Read in and clean Operational Tree Improvement Project 0722 data from Chris Walsh --------
    # A. read in data from Chris Walsh and standardize column names---------------
walshpath <- here::here("data-raw/phenology/from_Chris_Walsh/")
walsh <- list.files(walshpath, pattern='xls', full.names = TRUE) # location of data from Chris Walsh
stopifnot(length(walsh) == 10) # make sure all files are there

# number of sheets in each workbook and associated details in LabNotebook entry 2013.06.04
# naming scheme for data: provenance abbreviation orchard number _ year. If multiple orchards in one file, site_year For more on provenances and orchards see picola_SPUs.csv or Jack Woods' FGC Business Plan

## 2007 0722 phenology orch 230.xls
stopifnot(grepl("2007 0722 phenology orch 230.xls", walsh[1]))
bvl230_2007 <- read_excel_tidy(walsh[1], sheets = 1, orchard_ids = 230)
bvl230_2007 <- standardize_colnames(bvl230_2007)

## 2007 0722 phenology orch 307.xls
stopifnot(grepl("2007 0722 phenology orch 307.xls", walsh[2]))
nl307_2007 <- read_excel_tidy(walsh[2], sheets = 1, orchard_ids = 307)
nl307_2007 <- standardize_colnames(nl307_2007)

## 2008 0722 Kalamalka data.xls
stopifnot(grepl("2008 0722 Kalamalka data.xls", walsh[3]))
kal_2008 <- read_excel_tidy(walsh[3], sheets = c(1:2), orchard_ids = c(230, 307))
kal_2008 <- standardize_colnames(kal_2008)

## 2009 0722 Kalamalka data.xlsx
stopifnot(grepl("2009 0722 Kalamalka data.xlsx", walsh[4]))
kal_2009 <- read_excel_tidy(walsh[4], sheets = c(1:2), orchard_ids = c(230, 307), n_max = 17) #avoid notes row
kal_2009 <- standardize_colnames(kal_2009)

## all pheno data 2006.xls. This spreadsheet has site data
stopifnot(grepl("all pheno data 2006.xls", walsh[5]))
all_2006 <- read_excel(walsh[5])
colnames(all_2006) <- c("Site", "Orchard", "Clone", "X", "Y", "receptive20", "pollenshed20", "receptive80", "pollenshed80", "pickdate", "total_cone_weight_kg", "thirty_cone_weight_g")

## all sites 0722 data 2011.xlsx. Many of the sheets in this file do not have any phenology data. Only reading in sheets with phenology data. For data publishing purposes, may eventually want to read in cone data
### 1. Kal orch 307
### 2. Kal orch 230
### 3. Kal orch 340
### 4. PHENO Sorrento orch 240
### 5. PHENO Kettle orch 237
### 6. PHENO VSOC orch 234
### 7. PHENO VSOC orch 222
### 8. PHENO VSOC orch 218
### 9. PRT orch 313
### 10. PRT orch 311
### 11. PHENO PRT orch 338
### 12. PHENO Tolko orch 339
### 13. PGTIS orch 220
### 14. PGTIS orch 228
stopifnot(grepl("all sites 0722 data 2011.xlsx", walsh[6]))
all_2011 <- read_excel_tidy(walsh[6], sheets = c(5:8, 11, 12), orchard_ids = c(237, 234, 222, 218, 338, 339), skip=7, n_max = 21) #n_max is necessary here because of an obscure note under the dates in the Kettle orch 237 sheet
all_2011 <- standardize_colnames(all_2011)

# Sorrento Orchard 240 is in all sites 0722 data 2011.xlsx. but has different columns and so needs to be done separately

sor240_2011 <- read_excel(walsh[6], sheet=4, skip=7)[,-c(4,5,13,14)]
sor240_2011 <- data.frame(Orchard=240, sor240_2011)
sor240_2011 <- standardize_colnames(sor240_2011)

## Kettle River 0722 stats 2010.xlsx
stopifnot(grepl("Kettle River 0722 stats 2010.xlsx", walsh[7]))
pgl237_2010 <- read_excel(walsh[7], skip = 2, col_types = c("guess", "numeric", rep("guess", 2), rep("date",5), rep("numeric", 2), rep("skip", 2))) #col_types argument necessary for proper date reading
colnames(pgl237_2010)[c(1,3,4)] <- c('Orchard', 'X', 'Y')
pgl237_2010 <- standardize_colnames(pgl237_2010)


## PRT-Pl0722 Orchard Stats 2010 data collection.xls
stopifnot(grepl("PRT-Pl0722 Orchard Stats 2010 data collection.xls", walsh[8]))
tol338_2010 <- read_excel_tidy(walsh[8], skip=6, orchard_ids = 338)[,-c(2, 6:8, 13:16, 19,20)]
colnames(tol338_2010)[5:10] <- c("receptive20", "pollenshed20", "receptive80", "pollenshed80", "total_cone_weight_kg", "thirty_cone_weight_g")

## SSO-Pl0722 Orchard Stats 2010 data collection.xls
stopifnot(grepl("SSO-Pl0722 Orchard Stats 2010 data collection.xls", walsh[9]))
bvl240_2010 <- read_excel_tidy(walsh[9], skip=6, orchard_ids = 240)[,-c(2,6:8,13:16,19:20)]
colnames(bvl240_2010)[5:10] <- c("receptive20", "pollenshed20", "receptive80", "pollenshed80", "total_cone_weight_kg", "thirty_cone_weight_g") #no pickdate

## Tolko OTIP 0722 2010.xlsx
stopifnot(grepl("Tolko OTIP 0722 2010.xlsx", walsh[10]))
tol339_2010 <- read_excel_tidy(walsh[10], skip = 8, orchard_ids = 339)[-16,-c(2,6:8,15,17)]
tol339_2010 <- standardize_colnames(tol339_2010)

    # B. Combine Walsh datasets ----------------


walsh_frames_list <- list(bvl230_2007, nl307_2007, kal_2008, kal_2009, all_2006, all_2011, pgl237_2010, tol338_2010, bvl240_2010, tol339_2010)

## change column types so joining works
for (i in 1:length(walsh_frames_list)) {
  walsh_frames_list[[i]] <- correct_walsh_col_types(as.data.frame(walsh_frames_list[[i]]))
}

## merge all walsh data

walsh_data <- dplyr::bind_rows(walsh_frames_list)

    # C add site information -----------------
orchard_info <- read.csv(here::here('data-raw/phenology/picola_SPUs.csv'), header=TRUE, stringsAsFactors = FALSE)
orchard_info <- orchard_info[c('Site', 'Orchard')]
orchard_info$Orchard <- as.character(orchard_info$Orchard)

walsh_data$Site <- NULL #drop so it can be filled in from Orchard info

walsh_data <- left_join(walsh_data, orchard_info) # there are two Orchard 218s. My data is from the Vernon Orchard, not the Quesnel Orchard.
walsh_data <- walsh_data %>%
  mutate(Site = case_when(Site== "Quesnel" ~ "Vernon",
                          Site != "Quesnel" ~ Site)) %>%
  distinct()

    # D. assign unknown clones 9000 numbers------
unknownclone <- which(is.na(walsh_data$Clone))
walsh_data[unknownclone,]$Clone <- c(9000:9000+length(unknownclone))

    # E. Correct probable recording error in all pheno data 2006.xls -----------
# I believe that the 20% pollen shed and 80% receptivity dates are reversed for clones 980 and 982 in Orchard 220 in 2006

walsh_data[which(walsh_data$Orchard == 220 & walsh_data$Clone %in% c(980, 982) & lubridate::year(walsh_data$pollenshed20) == 2006),]$pollenshed20 <- "2006-05-29"
walsh_data[which(walsh_data$Orchard == 220 & walsh_data$Clone %in% c(980, 982) & lubridate::year(walsh_data$receptive80) == 2006),]$receptive80 <- "2006-06-08"

    # F. Write out Walsh Data -------------
write.csv(walsh_data, file = here::here("data-raw/phenology/from_Chris_Walsh/data_cleaned/walsh_pheno_2006_2011_cleaned.csv"), row.names = FALSE )
