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


############ Load Data (except intake) ###########

# anthropometric data
anthro_data <- read_sav("data/raw/anthro_data.sav")

# visit 6 database
V6 <- read_sav("data/raw/visit6_data.sav")

# visit notes
visit_notes <- read_sav("data/raw/visit_notes.sav")

# scan status redcap form
scanning <- read.csv("data/raw/FoodAndBrainR01DataP-Scansroar.csv")

# motion summary
mot_sum <- read.delim("BIDS/derivatives/preprocessed/fmriprep/task-foodcue_avg-fd.tsv")

# import index file that specifies children included in analyses
index_wide <- read.table("BIDS/derivatives/analyses/foodcue-paper1/level2/index_all_fd-0.9_b20_3runs.txt", quote="\"", comment.char="")

# censor summary
censor_sum <- read.delim("BIDS/derivatives/preprocessed/fmriprep/task-foodcue_byrun-censorsummary_fd-0.9.tsv")

############ Prep Data (except intake) ###########

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

V6_notes <- visit_notes[,c("id", "v6_childnotes")]

image_ratings <- V6[,grep("id|^mrivas|mri_version", colnames(V6))]

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

# isolate subjects who attended visit 6
V6_compiled <- setDT(V6_compiled)[id %chin% V6$id]

############ Load and process intake data ###########

r01_intake <- as.data.frame(read_spss("data/raw/intake_data.sav"))

# pad with zeros
#r01_intake$sub <- sprintf("%03d", r01_intake$id)

r01_intake_labels <- lapply(r01_intake, function(x) attributes(x)$label)

#remove 2 that were removed for ADHD
r01_intake <- r01_intake[r01_intake$id != 31 & r01_intake$id != 34, ]

# make numeric
r01_intake[c(606, 652, 698, 744, 607, 653, 699, 745, 115, 477, 116, 478, 166, 528, 167, 529)] <- sapply(r01_intake[c(606, 652, 698, 744, 607, 653, 699, 745, 115, 477, 116, 478, 166, 528, 167, 529)], FUN = as.numeric)

## b) Get Variable Labels and Re-Level ####

# risk status
r01_intake$risk_status_mom <- droplevels(as_factor(r01_intake$risk_status_mom))
r01_intake$risk_status_both <- droplevels(as_factor(r01_intake$risk_status_both))
r01_intake$sex <- as_factor(r01_intake$sex)

# income
r01_intake$income <- ifelse(is.na(r01_intake$income), NA, ifelse(r01_intake$income < 3, '< $51,000', ifelse(r01_intake$income < 5, "$51,000 - $100,000", '>$100,000')))

# parental ed
r01_intake$mom_ed <- ifelse(r01_intake$measured_parent == 0, ifelse(r01_intake$parent_ed == 0, 'High School/GED', ifelse(r01_intake$parent_ed < 3, 'AA/Technical Degree', ifelse(r01_intake$parent_ed == 3, 'Bachelor Degree', ifelse(r01_intake$parent_ed < 8, '> Bachelor Degree', 'Other/NA')))), ifelse(r01_intake$partner_ed == 0, 'High School/GED', ifelse(r01_intake$partner_ed < 3, 'AA/Technical Degree', ifelse(r01_intake$partner_ed == 3, 'Bachelor Degree', ifelse(r01_intake$partner_ed < 8, '> Bachelor Degree', 'Other/NA')))))

r01_intake$dad_ed <- ifelse(r01_intake$measured_parent == 1, ifelse(r01_intake$parent_ed == 0, 'High School/GED', ifelse(r01_intake$parent_ed < 3, 'AA/Technical Degree', ifelse(r01_intake$parent_ed == 3, 'Bachelor Degree', ifelse(r01_intake$parent_ed < 8, '> Bachelor Degree', 'Other/NA')))), ifelse(r01_intake$partner_ed == 0, 'High School/GED', ifelse(r01_intake$partner_ed < 3, 'AA/Technical Degree', ifelse(r01_intake$partner_ed == 3, 'Bachelor Degree', ifelse(r01_intake$partner_ed < 8, '> Bachelor Degree', 'Other/NA')))))

## average VAS across all foods
r01_intake[c("ps1_vas_mac_cheese","ps1_vas_chkn_nug", "ps1_vas_broccoli","ps1_vas_grape", "ps2_vas_mac_cheese","ps2_vas_chkn_nug", "ps2_vas_broccoli","ps2_vas_grape", "ps3_vas_mac_cheese","ps3_vas_chkn_nug", "ps3_vas_broccoli","ps3_vas_grape", "ps4_vas_mac_cheese","ps4_vas_chkn_nug", "ps4_vas_broccoli","ps4_vas_grape")] <- sapply(r01_intake[c("ps1_vas_mac_cheese","ps1_vas_chkn_nug", "ps1_vas_broccoli","ps1_vas_grape", "ps2_vas_mac_cheese","ps2_vas_chkn_nug", "ps2_vas_broccoli","ps2_vas_grape", "ps3_vas_mac_cheese","ps3_vas_chkn_nug", "ps3_vas_broccoli","ps3_vas_grape", "ps4_vas_mac_cheese","ps4_vas_chkn_nug", "ps4_vas_broccoli","ps4_vas_grape")], FUN = as.numeric)

r01_intake[['ps1_avg_vas']] <- rowMeans(r01_intake[c("ps1_vas_mac_cheese","ps1_vas_chkn_nug", "ps1_vas_broccoli","ps1_vas_grape")])
r01_intake[['ps2_avg_vas']] <- rowMeans(r01_intake[c("ps2_vas_mac_cheese","ps2_vas_chkn_nug", "ps2_vas_broccoli","ps2_vas_grape")])
r01_intake[['ps3_avg_vas']] <- rowMeans(r01_intake[c("ps3_vas_mac_cheese","ps3_vas_chkn_nug", "ps3_vas_broccoli","ps3_vas_grape")])
r01_intake[['ps4_avg_vas']] <- rowMeans(r01_intake[c("ps4_vas_mac_cheese","ps4_vas_chkn_nug", "ps4_vas_broccoli","ps4_vas_grape")])

#get portion order
r01_intake[['ps1_visit']] <- ifelse(is.na(r01_intake[['v2_meal_ps']]), NA, ifelse(r01_intake[['v2_meal_ps']] == 0, 1, ifelse(r01_intake[['v3_meal_ps']] == 0, 2, ifelse(r01_intake[['v4_meal_ps']] == 0, 3, 4))))

r01_intake[['ps2_visit']] <- ifelse(is.na(r01_intake[['v2_meal_ps']]), NA, ifelse(r01_intake[['v2_meal_ps']] == 1, 1, ifelse(r01_intake[['v3_meal_ps']] == 1, 2, ifelse(r01_intake[['v4_meal_ps']] == 1, 3, 4))))

r01_intake[['ps3_visit']] <- ifelse(is.na(r01_intake[['v2_meal_ps']]), NA, ifelse(r01_intake[['v2_meal_ps']] == 2, 1, ifelse(r01_intake[['v3_meal_ps']] == 2, 2, ifelse(r01_intake[['v4_meal_ps']] == 2, 3, 4))))

r01_intake[['ps4_visit']] <- ifelse(is.na(r01_intake[['v2_meal_ps']]), NA, ifelse(r01_intake[['v2_meal_ps']] == 3, 1, ifelse(r01_intake[['v3_meal_ps']] == 3, 2, ifelse(r01_intake[['v4_meal_ps']] == 3, 3, 4))))

# make high and low ED intake variables
r01_intake[['ps1_led_g']] <- rowSums(r01_intake[c("ps1_consumed_grapes_g", "ps1_consumed_broccoli_g")])
r01_intake[['ps2_led_g']] <- rowSums(r01_intake[c("ps2_consumed_grapes_g", "ps2_consumed_broccoli_g")])
r01_intake[['ps3_led_g']] <- rowSums(r01_intake[c("ps3_consumed_grapes_g", "ps3_consumed_broccoli_g")])
r01_intake[['ps4_led_g']] <- rowSums(r01_intake[c("ps4_consumed_grapes_g", "ps4_consumed_broccoli_g")])

r01_intake[['ps1_hed_g']] <- rowSums(r01_intake[c("ps1_consumed_chkn_nug_g", "ps1_consumed_mac_cheese_g")])
r01_intake[['ps2_hed_g']] <- rowSums(r01_intake[c("ps2_consumed_chkn_nug_g", "ps2_consumed_mac_cheese_g")])
r01_intake[['ps3_hed_g']] <- rowSums(r01_intake[c("ps3_consumed_chkn_nug_g", "ps3_consumed_mac_cheese_g")])
r01_intake[['ps4_hed_g']] <- rowSums(r01_intake[c("ps4_consumed_chkn_nug_g", "ps4_consumed_mac_cheese_g")])

r01_intake[['ps1_led_kcal']] <- rowSums(r01_intake[c("ps1_consumed_grapes_kcal", "ps1_consumed_broccoli_kcal")])
r01_intake[['ps2_led_kcal']] <- rowSums(r01_intake[c("ps2_consumed_grapes_kcal", "ps2_consumed_broccoli_kcal")])
r01_intake[['ps3_led_kcal']] <- rowSums(r01_intake[c("ps3_consumed_grapes_kcal", "ps3_consumed_broccoli_kcal")])
r01_intake[['ps4_led_kcal']] <- rowSums(r01_intake[c("ps4_consumed_grapes_kcal", "ps4_consumed_broccoli_kcal")])

r01_intake[['ps1_hed_kcal']] <- rowSums(r01_intake[c("ps1_consumed_chkn_nug_kcal", "ps1_consumed_mac_cheese_kcal")])
r01_intake[['ps2_hed_kcal']] <- rowSums(r01_intake[c("ps2_consumed_chkn_nug_kcal", "ps2_consumed_mac_cheese_kcal")])
r01_intake[['ps3_hed_kcal']] <- rowSums(r01_intake[c("ps3_consumed_chkn_nug_kcal", "ps3_consumed_mac_cheese_kcal")])
r01_intake[['ps4_hed_kcal']] <- rowSums(r01_intake[c("ps4_consumed_chkn_nug_kcal", "ps4_consumed_mac_cheese_kcal")])

# average VAS by ED
r01_intake[['ps1_led_vas']] <- rowMeans(r01_intake[c("ps1_vas_broccoli","ps1_vas_grape")])
r01_intake[['ps2_led_vas']] <- rowMeans(r01_intake[c("ps2_vas_broccoli","ps2_vas_grape")])
r01_intake[['ps3_led_vas']] <- rowMeans(r01_intake[c("ps3_vas_broccoli","ps3_vas_grape")])
r01_intake[['ps4_led_vas']] <- rowMeans(r01_intake[c("ps4_vas_broccoli","ps4_vas_grape")])

r01_intake[['ps1_hed_vas']] <- rowMeans(r01_intake[c("ps1_vas_mac_cheese","ps1_vas_chkn_nug")])
r01_intake[['ps2_hed_vas']] <- rowMeans(r01_intake[c("ps2_vas_mac_cheese","ps2_vas_chkn_nug")])
r01_intake[['ps3_hed_vas']] <- rowMeans(r01_intake[c("ps3_vas_mac_cheese","ps3_vas_chkn_nug")])
r01_intake[['ps4_hed_vas']] <- rowMeans(r01_intake[c("ps4_vas_mac_cheese","ps4_vas_chkn_nug")])

## c) Make Data Long ####
intake_long <- reshape2::melt(r01_intake[c(1, 8:12, 21, 606, 652, 698, 744)], id.vars = names(r01_intake)[c(1, 8:12, 21)])
names(intake_long)[8:9] <- c('PortionSize', 'grams')
intake_long$PortionSize <- ifelse(intake_long$PortionSize == 'ps4_total_g', 'PS-4', ifelse(intake_long$PortionSize == 'ps3_total_g', 'PS-3', ifelse(intake_long$PortionSize == 'ps2_total_g', 'PS-2', 'PS-1')))
intake_long$grams <- as.numeric(intake_long$grams)

intake_kcal_long <- reshape2::melt(r01_intake[c(1, 607, 653, 699, 745)], id.vars = 'id')
intake_long$kcal <- intake_kcal_long$value

intake_vas_long <- reshape2::melt(r01_intake[c(1, 748:751)], id.vars = 'id')
intake_long$avg_vas <- intake_vas_long$value

intake_preFF_long <- reshape2::melt(r01_intake[c(1, 563, 609, 655, 701)], id.vars = 'id')
intake_long$preFF <- as.numeric(intake_preFF_long$value)

intake_postFF_long <- reshape2::melt(r01_intake[c(1, 564, 610, 656, 702)], id.vars = 'id')
intake_long$postFF <- as.numeric(intake_postFF_long$value)

intake_date_long <- reshape2::melt(r01_intake[c(1, 562, 608, 654, 700)], id.vars = 'id')
intake_long$date <- intake_date_long$value

intake_order_long <- reshape2::melt(r01_intake[c(1, 752:755)], id.vars = 'id')
intake_long$meal_order <- intake_order_long$value

intake_meal_dur_long <- reshape2::melt(r01_intake[c(1, 576, 622, 668, 714)], id.vars = 'id')
intake_long$meal_dur <- intake_meal_dur_long$value

#low ed
intake_led_grams_long <- reshape2::melt(r01_intake[c(1, 756:759)], id.vars = 'id')
intake_long$led_grams <- intake_led_grams_long$value

intake_led_kcal_long <- reshape2::melt(r01_intake[c(1, 764:767)], id.vars = 'id')
intake_long$led_kcal <- intake_led_kcal_long$value

vas_led_long <- reshape2::melt(r01_intake[c(1, 772:775)], id.vars = 'id')
intake_long$led_vas <- vas_led_long$value

#hed ed
intake_hed_grams_long <- reshape2::melt(r01_intake[c(1, 760:763)], id.vars = 'id')
intake_long$hed_grams <- intake_hed_grams_long$value

intake_hed_kcal_long <- reshape2::melt(r01_intake[c(1, 768:771)], id.vars = 'id')
intake_long$hed_kcal <- intake_hed_kcal_long$value

vas_hed_long <- reshape2::melt(r01_intake[c(1, 776:779)], id.vars = 'id')
intake_long$hed_vas <- vas_hed_long$value


#continuous approach:
intake_long$ps_prop <- ifelse(intake_long[['PortionSize']] == 'PS-1', 0, ifelse(intake_long[['PortionSize']] == 'PS-2', 0.33, ifelse(intake_long[['PortionSize']] == 'PS-3', 0.66, 0.99)))


############ Export ##########
write.csv(V6_compiled, 'data/derivatives_R/demographics_compiled.csv', row.names = FALSE)
write.csv(image_ratings, 'data/derivatives_R/fmri_image_ratings.csv', row.names = FALSE)
write.csv(censor_sum, 'data/derivatives_R/censor_sum.csv', row.names = FALSE)


