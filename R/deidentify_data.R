# This script removes potentially identifiable information (dob, race, ethnicity, visit1_data) from datasets
# and exported/copies de-identified data into data/raw_deidentified
#

#### Load packages ####
library(haven)


#### Remove PII ####

## Anthro data

# load data
r01_anthro <- as.data.frame(read_spss(("data/raw/anthro_data.sav")))

# overwrite identifiable data as NA
r01_anthro$v1_date <- NA
r01_anthro$dob <- NA
r01_anthro$race <- NA
r01_anthro$ethnicity <- NA

## Intake data

# load data
r01_intake <- as.data.frame(read_spss("data/raw/intake_data.sav"))

# overwrite identifiable data as NA
r01_intake$v1_date <- NA
r01_intake$dob <- NA
r01_intake$race <- NA
r01_intake$ethnicity <- NA

#### Export datasets ####
dir.create("data/raw_deidentified", recursive = TRUE)
write.table(r01_anthro, "data/raw_deidentified/anthro_data.csv", sep = "\t", row.names = FALSE, quote = FALSE, fileEncoding = "ASCII")
write.table(r01_intake, "data/raw_deidentified/intake_data.csv", sep = "\t", row.names = FALSE, quote = FALSE, fileEncoding = "ASCII")

# copy over files that do not need to be de-identified
file.copy("data/raw/visit6_data.sav", "data/raw_deidentified/visit6_data.sav")
file.copy("data/raw/dict-visit6_data.csv", "data/raw_deidentified/dict-visit6_data.csv")
file.copy("data/raw/FoodAndBrainR01DataP-Scansroar.csv", "data/raw_deidentified/FoodAndBrainR01DataP-Scansroar.csv")
file.copy("data/raw/dict-FoodAndBrainR01DataP-Scansroar.csv", "data/raw_deidentified/dict-FoodAndBrainR01DataP-Scansroar.csv")
file.copy("data/raw/dict-intake_data.csv", "data/raw_deidentified/dict-intake_data.csv")
file.copy("data/raw/dict-anthro_data.csv", "data/raw_deidentified/dict-anthro_data.csv")
