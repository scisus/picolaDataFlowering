#' @title Interior lodgepole pine flowering events
#' @description This dataset contains pollen shed and receptivity data for lodgepole pine (*Pinus contorta* ssp. *latifolia*) grown in commercial and government seed orchards at 7 sites in British Columbia, Canada between. Trees were observed between 1997 and 2012. This dataset contains only cleaned, harmonized, and formatted pollen shed and cone receptivity phenology data. It records observations as events.
#' @format A data frame with 15707 rows and 15 variables:
#' \describe{
#'   \item{\code{Index}}{integer A unique identifier that discriminates between males and females of each tree in each year.}
#'   \item{\code{State}}{integer Phenological state 1 for not yet flowering, 2 for flowering, 3 for finished flowering. 0 indicates no flowers.}
#'   \item{\code{Year}}{integer Year of observation}
#'   \item{\code{DoY}}{integer Day of year of observation}
#'   \item{\code{Event_Label}}{character Phenological event label. Four types of phenological observations are recorded 1) not yet flowering 2) first flowering observation 3)last flowering observation and 4) flowering is over }
#'   \item{\code{Event_Obs}}{integer Phenological event coded as an integer for modeling purposes}
#'   \item{\code{Date}}{character date of observation}
#'   \item{\code{Sex}}{character whether the observation is for pollen shed (MALE) or cone receptivity (FEMALE)}
#'   \item{\code{Site}}{character Seed orchard site where observation was made}
#'   \item{\code{Orchard}}{integer Orchard identifer within a seed orchard site}
#'   \item{\code{Genotype}}{integer Genotype identifier (corresponds to "Clone" label in Seed Orchard operations)}
#'   \item{\code{Tree}}{integer Internal identifier for an individual tree (ramet in seed orchard operations). Not unique or always assigned.}
#'   \item{\code{X}}{character part of a grid identifier system for tree locations within orchards}
#'   \item{\code{Y}}{integer part of a grid identifier system for tree locations within orchards}
#'   \item{\code{Source}}{character Whether data provided by Wagner or Walsh}
#'}
#' @source Phenology data was originally collected for the Operational Tree Improvement Program as part of an effort to explain variation in seed production between orchards. Data was collated from multiple orchards and cleaned in order to build phenological models of pollen shed and cone receptivity in lodgepole pine. Raw data provided by Chris Walsh at Kalamalka Seed Orchards and Rita Wagner at Prince George Tree Improvement Station, both with the BC Ministry of Forests, Lands and Natural Resource Operations.  Data cleaned, harmonized, and formatted by C. Susannah Tysor while at the University of British Columbia. susannah at pobox.com
"picola_event"

#' @title Interior lodgepole pine flowering states
#' @description This dataset contains pollen shed and receptivity data for lodgepole pine (*Pinus contorta* ssp. *latifolia*) grown in commercial and government seed orchards at 7 sites in British Columbia, Canada. Trees were observed between 1997 and 2012. This dataset contains only cleaned, harmonized, and formatted pollen shed and cone receptivity phenology data. It records observations as states and also retains pre-harmonization coding in Phenophase_Recorded column.
#' @format A data frame with 29058 rows and 14 variables:
#' \describe{
#'   \item{\code{Index}}{integer A unique identifier that discriminates between males and females of each tree in each year.}
#'   \item{\code{DoY}}{integer Day of year of observation}
#'   \item{\code{Date}}{character date of observation}
#'   \item{\code{Phenophase_Recorded}}{character pre-harmonization state coding (from original data sheets)}
#'   \item{\code{State}}{integer harmonized phenological state coding. 1 for not yet flowering, 2 for flowering, 3 for finished flowering. 0 indicates no flowers.}
#'   \item{\code{Sex}}{character whether the observation is for pollen shed (MALE) or cone receptivity (FEMALE)}
#'   \item{\code{Year}}{integer Year of observation}
#'   \item{\code{Site}}{character Seed orchard site where observation was made}
#'   \item{\code{Orchard}}{integer Orchard identifer within a seed orchard site}
#'   \item{\code{Genotype}}{integer Genotype identifier (corresponds to "Clone" label in Seed Orchard operations)}
#'   \item{\code{Tree}}{integer Internal identifier for an individual tree (ramet in seed orchard operations). Not unique or always assigned.}
#'   \item{\code{X}}{character part of a grid identifier system for tree locations within orchards}
#'   \item{\code{Y}}{integer part of a grid identifier system for tree locations within orchards}
#'   \item{\code{Source}}{character Whether data provided by Wagner or Walsh}
#'}
#' @source Phenology data was originally collected for the Operational Tree Improvement Program as part of an effort to explain variation in seed production between orchards. Data was collated from multiple orchards and cleaned in order to build phenological models of pollen shed and cone receptivity in lodgepole pine. Raw data provided by Chris Walsh at Kalamalka Seed Orchards and Rita Wagner at Prince George Tree Improvement Station, both with the BC Ministry of Forests, Lands and Natural Resource Operations.  Data cleaned, harmonized, and formatted by C. Susannah Tysor while at the University of British Columbia. susannah at pobox.com
"picola_state"

#' @title *Pinus contorta* ssp. *latifolia* parent tree locations
#' @description Locations of genotype parents
#' @format A data frame with 2739 rows and 5 variables:
#' \describe{
#'   \item{\code{Clone}}{integer Genotype identifier / Clone label for parent tree}
#'   \item{\code{SPU}}{character Seed Planting Unit (SPU) identifier}
#'   \item{\code{lat}}{double Latitude of parent tree}
#'   \item{\code{lon}}{double Longitude of parent tree}
#'   \item{\code{el}}{integer Elevation of parent tree (meters)}
#'}
#' @details Scions and seeds for *Pinus contorta* ssp. *latifolia* were collected from parent trees located in 143 natural stands across British Columbia during the 1970s and 1980s. These trees were selected based on their suitability for various breeding and selection programs that aimed to improve tree growth and adaptation to different B.C. regions. The scions collected from these trees were grafted onto rootstock to create a genotype bank and then from there onto rootstocks in seed orchards.
#'
#' @source The geographic data (latitude, longitude, and elevation) of each genotype's parent tree was obtained from the British Columbia Ministry of Forests Seed Planning and Registry Application (https://www2.gov.bc.ca/gov/content/industry/forestry/managing-our-forest-resources/tree-seed/seed-planning-use/spar).
"picola_parent_locs"

#' @title Site locations
#' @description Locations and elevations of *Pinus contorta* ssp. *latifolia* seed orchards and comparison sites
#' @format A data frame with 9 rows and 6 variables:
#' \describe{
#'   \item{\code{Site}}{character Short symbolic name of the site}
#'   \item{\code{orchard}}{logical Whether the site is a seed orchard (TRUE) or a comparison site (FALSE)}
#'   \item{\code{longname}}{character Full descriptive name of the site}
#'   \item{\code{lat}}{double Latitude of the site}
#'   \item{\code{lon}}{double Longitude of the site}
#'   \item{\code{el}}{double Elevation of the site (meters)}
#'}
#' @source Seed Orchard latitude and longitude data identified by C.S. Tysor manually using Google Earth, and verified by Jack Woods as the locations of these seed orchards. Elevation data for sites pulled from GeoNames via `rgbif::elevation`
"picola_site_coord_elev"

#' @title Seed orchard sites and SPUs
#' @description This dataset lists all the B.C. *Pinus contorta* ssp. *latifolia* seed orchards and the target SPUs for each orchard. Also includes the number of years of data in this package for each site-SPU combination.
#' @format A data frame with 33 rows and 9 variables:
#' \describe{
#'   \item{\code{SPU_Number}}{integer SPU identifier}
#'   \item{\code{SPU_Name}}{character Short symbolic name of the SPU}
#'   \item{\code{SPU_Name_Long}}{character Full descriptive name of the SPU}
#'   \item{\code{Long_Site}}{character Full descriptive name of the site}
#'   \item{\code{Site}}{character Short symbolic name of the site}
#'   \item{\code{Orchard}}{integer Orchard identifier within the site}
#'   \item{\code{Repro_Data}}{integer Number of years of data for orchard at site}
#'   \item{\code{Elev_Min}}{integer Minimum elevation of the SPU in meters}
#'   \item{\code{Elev_Max}}{integer Maximum elevation of the SPU in meters}
#'}
#' @details This dataset lists all *Pinus contorta* ssp. *latifolia* seed orchard sites and their corresponding Seed Planning Units (SPUs). Each entry includes the orchard identifier, the SPU number, and the elevation range for the SPU. Additionally, the dataset provides the number of years of data available for each site-SPU combination.
#' Seed Planning Units (SPUs) are defined regions used for organizing breeding and seed production efforts. These units are classified by species, seed planning zone, and elevation band.
#' @source https://www2.gov.bc.ca//gov/content/industry/forestry/managing-our-forest-resources/tree-seed/seed-planning-use/seed-planning-units-species-plans
"picola_SPUs"
