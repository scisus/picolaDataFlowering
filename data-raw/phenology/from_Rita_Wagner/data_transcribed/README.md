# Metadata for files in `data_transcribed` directory

*blk228_1999_data.csv*
2 ramets of clone 1464 were included at the bottom of page 10 of the wb 220 phenology data. They were not originally transcribed with the PGTIS_pheno_1997_2012.xlsx data, but were found and added later.

*cpf223_missed_locations.csv*
The X locations for some trees in cpf223 were missed, likely because of a scanning cutoff on one page. This file contains a transcription of those X locations along with identifying information.

*notes.md*
Transcription of notes from the PGTIS data sent to Susannah Tysor by Rita Wagner on 2012.12.18. Notes were transcribed by Susannah Tysor, not the main data transcriber, Rob Johnstone.

*PGTIS_pheno_1997-2012.xlsx*
Original data was collected at the Prince George Tree Improvement Station and sent to Susannah Tysor by Rita Wagner on 2012.12.18		
Data in these sheets was transcribed from that PGTIS dataset by Rob Johnstone for Susannah Tysor		
		
Individual sheet names refer to SPU names and orchard numbers		
Data is for Pinus contorta ssp. latifolia

Field names	Field descriptions	Data type
Year	Survey year	4 digit number between 1997 and 2012
Sex	The type of strobilus being examined	"""male"" or ""female"""
Clone	Unique clone identifier	3 or 4 digit number
Tree	Tree identifier	2 digit number
X	x coordinate of tree in orchard	capital letter
Y	y coordinate of tree	integer
Month	Month of survey	Integer between 1 and 12
Day	Day of survey	Integer between 1 and 31
Phenophase	The phenological phase of the strobilus	Integers between 0 and 7. Typically 3 or 4. X represents days trees were checked, but were not at a recordable phenophase
Page	The page number of the pdf data was scanned into	Integers > 0

*wb220_corrected_locations.csv*
In 2000, they kept the same clones but used different ramets for some of the trees at the last minute. The new location information was not correctly transcribed, so it's corrected here.

*wb220_missed_columns.csv*
On p. 10 of the wb220 data (for year 1999), there are several ad-hoc columns in the original dataset that were not transcribed into `PGTIS_pheno_1997-2012.xlsx`. They are transcribed here instead.

*wb220_non_flowering_clones*
On page 34 for the original wb220 data, there is data for non-flowering clones that were not transcribed into `PGTIS_pheno_1997-2012.xlsx`. They are transcribed here instead.

