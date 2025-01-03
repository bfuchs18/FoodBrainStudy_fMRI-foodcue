library(stringr)

# import files
neurovault <- read.csv("data/mega_analysis/input/neurovault_download.csv")
snack <- read.csv("data/mega_analysis/input/V6_covariates.csv")
anthro <- read.delim("data/raw_deidentified/anthro_data.csv")

# prep for merge
neurovault$id <- as.numeric(substr(neurovault$name, 5, 7))
anthro_subset <- anthro[c("id", "age_yr", "sex", "bmi")]

# merge
neurovault_update <- merge(neurovault, anthro_subset, by = "id")
neurovault_update <- merge(neurovault_update, snack[c("id", "snack_intake")], by = "id")

# put variables into orig columns
neurovault_update$hours_since_last_meal <- ifelse(neurovault_update$snack_intake == "yes", 1, ifelse(neurovault_update$snack_intake == "no", 2, NA)) # code hours variable based on snack intake
neurovault_update$gender <- ifelse(neurovault_update$sex == 0, "Male", ifelse(neurovault_update$sex == 1, "Female", NA))
neurovault_update$BMI <- neurovault_update$bmi
neurovault_update$age <- neurovault_update$age_yr

# overall dataset meta-data
## subject mean age

# reorder to match orig
neurovault_update <- neurovault_update[match(neurovault$name, neurovault_update$name),]

# export -- note: it is not possible to upload the CSV to NeuroVault -- will have to copy and paste data into spreadsheet on website
write.csv(neurovault_update, 'data/mega_analysis/neurovault_update.csv', row.names = FALSE, quote=FALSE)
