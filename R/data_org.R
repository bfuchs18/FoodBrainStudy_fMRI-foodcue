# data_org: generates the following databases for analyses:
#
# demographics_compiled.csv -- contains demographic and visit 6 variables (e.g., fullness, scan status)
#                               for participants who attended visit 6
# fmri_image_ratings.csv -- contains liking and fullness ratings from post-fmri behavioral assessment (300 ratings per child)
# censor_sum.csv -- long database that contains the percent of TRs censored from food/office blocks for each run


# load packages
library(haven)
library(data.table)
library(haven)


############ Load Data ###########

# anthropometric data
anthro_data <- read_sav("data/raw/anthro_data.sav")

# visit 6 database
V6 <- read_sav("data/raw/visit6_data.sav")

# scan status redcap form
scanning <- read.csv("data/raw/FoodAndBrainR01DataP-Scansroar_DATA_2023-01-12_1521.csv")

# motion summary
mot_sum <- read.delim("BIDS/derivatives/preprocessed/fmriprep/task-foodcue_avg-fd.tsv")

# import index file that specifies children included in analyses
index_wide <- read.table("BIDS/derivatives/analyses/foodcue-paper1/level2/index_all_fd-0.9_b20_3runs.txt", quote="\"", comment.char="")

# censor summary
censor_sum <- read.delim("BIDS/derivatives/preprocessed/fmriprep/task-foodcue_byrun-censorsummary_fd-0.9.tsv")

############ Prep Data ###########

# transpose index_wide to long dataframes
index <- as.data.frame(t(index_wide))

# change subject/participant id columns to 'id'
names(scanning)[names(scanning) == "par_id"] <- "id" # change par_id column to 'id'
names(censor_sum)[names(censor_sum) == "sub"] <- "id" # change sub column to 'id'
names(index) <- "id" # add column name

############ Reduce dataframes to needed variables ###########

anthro_data_reduced <- anthro_data[,c("id","sex","age_yr", "race", "ethnicity" ,"risk_status_mom", "height_avg", "dxa_total_fat_mass",
                        "bmi_percentile", "income", "parent_respondent", "parent_ed", "parent_ed_other",
                        "partner_ed", "partner_ed_other", "parent_bmi", "sr_mom_bmi")]

V6_reduced <- V6[,c("id", "ff_premri_snack", "ff_postmri_snack", "ff_postmri_snack2", "cams_pre_mri")]

image_ratings <- V6[,grep("id|^mrivas", colnames(V6))]

scanning_reduced <- scanning[,c("id", "fmri_pp_complete", "fmri_pp_scans_roar___2","fmri_pp_scans_roar___3", "fmri_pp_scans_roar___4","fmri_pp_scans_roar___5","fmri_pp_scans_roar___6" )]

mot_sum_reduced <- mot_sum[,c("id", "fd_avg_allruns")]

############ Merge dataframes ###########

# create database will all subjects in anthro_data_reduced
concat <- merge(x = anthro_data_reduced, y = V6_reduced, by = "id", all.x = TRUE)
concat <- merge(x = concat, y = scanning_reduced, by = "id", all.x = TRUE)
V6_compiled <- merge(x = concat, y = mot_sum_reduced, by = "id", all.x = TRUE)

# add column based on index file to indicate inclusion
V6_compiled$included <- as.integer(V6_compiled$id %in% index$id)

############ Subset dataframes by visit status ###########

# isolate subjects who attened visit 6
V6_compiled <- setDT(V6_compiled)[id %chin% V6$id]

############ Export ##########
write.csv(V6_compiled, 'data/derivatives_R/demographics_compiled.csv', row.names = FALSE)
write.csv(image_ratings, 'data/derivatives_R/fmri_image_ratings.csv', row.names = FALSE)
write.csv(censor_sum, 'data/derivatives_R/censor_sum.csv', row.names = FALSE)


