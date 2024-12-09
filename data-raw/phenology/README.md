# phenology

- `cleaning` Contains scripts that read in phenology data, clean and format it, and combine phenology data from different sources. See [cleaning/README.md](cleaning/README.md)

- `intermediate` Contains cleaned and formatted phenology datasets, sometimes with data derived from original data - like indexes and phenophase symbols that are unifed across data from multiple sources. See [intermediate/README.md](intermediate/README.md).

- `from_Chris_Walsh` Raw data from Chris Walsh.

- `from_Rita_Wagner` Raw data from Rita Wagner. See [from_Rita_Wagner/README.md](from_Rita_Wagner/README.md)

- `picola_SPUs.csv` Summarizes info on lodgepole SPUs from the BC orchard
  summary. Units for elevation are meters. Information from Forest Genetics
  Council of British Columbia Business Plan & BC orchard summary information
  compiled by Jack Woods in 2011. 

- `picola_state.csv` Built by `infer_implicit_phenophases.csv`. 

This file contains the same columns as `intermediate/derived_phenophases.csv`,
but also contains inferred phenological state data for many trees contained in the
data provided by Chris Walsh.

Data provided by Chris Walsh (6/7 Sites) only explicitly records the first day a
tree is observed flowering and the first day a tree is observed not flowering.
However, they implicitly record a great deal more information and this script
extracts it.

- `picola_event.csv` The three phenological states

1. Not yet flowering
2. Actively flowering
3. Finished flowering

Are translated into four phenological observations 

1. Last observed before flowering
2. First observed flowering
3. Last observed flowering
4. First observed not flowering

Corresponding to events of interest

1. Last day before flowering
2. First day flowering
3. Last day flowering
4. First day flowering complete
