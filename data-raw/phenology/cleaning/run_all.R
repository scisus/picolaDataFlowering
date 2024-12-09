here::i_am("data-raw/phenology/cleaning/run_all.R")
 
# Run all phenology data cleaning and formatting scripts

# Read in and clean all data from Wagner and Walsh
source(here::here('data-raw/phenology/cleaning/1.clean_pheno.R'))

    # writes to
        # "data-raw/phenology/from_Chris_Walsh/data_cleaned/walsh_pheno_2006_2011_cleaned.csv"
        # "data-raw/phenology/from_Rita_Wagner/data_cleaned/PGTIS_pheno_1997_2012_cleaned.csv"

# Combine Wagner and Walsh datasets
source(here::here('data-raw/phenology/cleaning/2.combine_wagner_walsh.R'))

    # writes to 'data-raw/phenology/intermediate/Combined_Wagner_Walsh_pollination_phenology.csv'

# Harmonize phenophases across datasets
source(here::here('data-raw/phenology/cleaning/3.derive_phenophases.R'))

    # writes to /data-raw/phenology/intermediate/derived_phenophases.csv

# Infer implicit phenophases in Walsh dataset.

source(here::here('data-raw/phenology/cleaning/4.infer_implicit_phenophases.R'))

    # writes to 'data-raw/phenology/picola_state.csv'

# Derive event data

source(here::here('data-raw/phenology/cleaning/5.derive_event_data.R'))

    # writes to 'data-raw/phenology/picola_event.csv'
