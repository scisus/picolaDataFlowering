# meta for folder `cleaning`

This folder contains scripts that read in phenology data, clean and format it, and combine phenology data from different sources.

The scripts should be run in the following order

- 1. `1.clean_pheno.R`
- 2. `2.combine_wagner_walsh.R`
- 3. `3.derive_phenophases.R`
- 4. `4.infer_implicit_phenophases.R`
- 5. `5.derive_event_data.R`

## `1.clean_pheno_functions.R`
Reads in raw data sent to me by Rita Wagner and Chris Walsh, collects it into two datasets (from Wagner or Walsh) and corrects transcription errors and does other cleaning. Uses functions from `clean_pheno_functions`. Writes out the following two files:

- `from_Rita_Wagner/data_cleaned/PGTIS_pheno_1997_2012_cleaned.csv`
- `from_Chris_Walsh/data_cleaned/walsh_pheno_2006_2011_cleaned.csv`

## `2.combine_wagner_walsh.R`
This script combines the cleaned phenology datasets from Rita Wagner and Chris Walsh and adds convenience columns for later analysis. 

Reads in 

- `PGTIS_pheno_1997_2012_cleaned.csv`
- `walsh_pheno_2006_2011_cleaned.csv`

Writes out data to `intermediate/Combined_Wagner_Walsh_pollination_phenology.csv`

## `3.derive_phenophases.R`
This script derives common phenophases for data sourced from Wagner and Walsh, since they were recorded differently.

Harmonizes data from Wagner and Walsh

Reads in

- `Combined_Wagner_Walsh_pollination_phenology.csv`

Writes out data to `intermediate/derived_phenophases.csv`

## `4.infer_implicit_phenophases.R`
This script infers phenological state in the walsh data where it is implicitly but not explicitly recorded.

Reads in

- `derived_phenophases.csv`

Writes out data to `picola_state.csv`

## `5.derive_event_data.R`
This script derives four phenological events of interest based on `picola_state.csv` 

1. before flowering - last observed
2. first flowering - first observed
3. last flowering - last observed
4. past flowering - first observed

Writes out data to `picola_event.csv`
