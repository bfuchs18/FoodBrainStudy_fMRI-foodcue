# This script will generate a bids-compliant participants.tsv file

library(labelled)
library(jsonlite)
library(tibble)

# Source data org to load demographic/anthropometric data
source("R/data_org.R")


############ Select variables ###########

bids_pardat <- anthro_data[c('id', 'sex', 'age_yr', 'bmi_percentile', 'ethnicity', 'race', 'risk_status_mom' )]

############ Prepare .tsv for export ###########

# rename variables to be bids compliant
names(bids_pardat)[names(bids_pardat) == "id"] <- "participant_id"
names(bids_pardat)[names(bids_pardat) == "age_yr"] <- "age"

# Convert participant_id to strings padded with zeros and add "sub_"
bids_pardat$participant_id <- sprintf("sub-%03d", bids_pardat$participant_id)

# use labels
bids_pardat$sex <- haven::as_factor(bids_pardat$sex)
bids_pardat$race <- haven::as_factor(bids_pardat$race)
bids_pardat$ethnicity <- haven::as_factor(bids_pardat$ethnicity)
bids_pardat$risk_status_mom <- haven::as_factor(bids_pardat$risk_status_mom)

# export participants.tsv
write.table(bids_pardat, 'data/compiled/participants.tsv', sep='\t', row.names = FALSE, quote=FALSE)
