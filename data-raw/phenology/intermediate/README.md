# meta for folder `intermediate`

Contains processed phenology data.

## `intermediate/Combined_Wagner_Walsh_pollination_phenology.csv`
Combined, cleaned phenology datasets from Rita Wagner and Chris Walsh with convenience columns for later analysis. Output of `cleaning/2.combine_wagner_walsh.R`. Input to `cleaning/3.derive_phenophases.R`.

Columns
- Index: unique identifier for a particular tree of a particular clone in a particular year of a particular sex at a given site in a given orchard.
- DoY: day of year
- Phenophase: phenological state, as recorded or corrected 
- Sex: observation for a male or female strobili
- Year: year of observation
- Site: seed orchard site name
- Orchard: id number of seed orchard at a seed orchard site
- Clone: clone id
- Tree: tree id (not all trees have them)
- X,Y: tree location in orchard. unique at a given site.
- Date: date of observation
- Source: whether the data was provided by Rita Wagner or Chris Walsh

## `intermediate/derived_phenophases.csv`

Built by `cleaning/3.derive_phenophases.R`. This file contains all phenological observations and adds an additional `State` column containing harmonized The `Phenophase_Recorded` column, which cannot be compared across sites (or sometimes even within sites) is transformed into the `Phenophase_Derived` column using the following harmonization rules:

```
no_flowers <- '0'
before_flowering <- c('1', '2.5', '-') #stage 1
flowering <- c('3', '3.5', '4', '4.5', '5', 'pollenshed20', 'receptive20') #stage 2
after_flowering <- c('-', 'receptive80', 'pollenshed80') #stage 3
```

Columns
- Index: unique identifier for a particular tree of a particular clone in a particular year of a particular sex at a given site in a given orchard.
- DoY: day of year
- Phenophase_Recorded: phenological state, as recorded or corrected 
- Sex: observation for a male or female strobili
- Year: year of observation
- Site: seed orchard site name
- Orchard: id number of seed orchard at a seed orchard site
- Clone: clone id
- Tree: tree id (not all trees have them)
- X,Y: tree location in orchard. unique at a given site.
- Date: date of observation
- Source: whether the data was provided by Rita Wagner or Chris Walsh
- First_RF: Date an individual tree in a given year for a given sex was recorded flowering for the first time
- Last_RF: Date an individual tree in a given year for a given sex was recorded flowering for the last time
- State: Phenological states on a harmonized scale 0 (no flowers), 1 (not yet flowering), 2 (flowering), and 3 (finished flowering).



