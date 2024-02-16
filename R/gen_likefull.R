# Code to process and organize post-scan ratings of liking and anticipated fullness

# load packages
library(plyr)
library(dplyr)
library(stringr)

# source data organization script to generate image_ratings (dataframe of raw data)
source("R/data_org.R")

# alternatively -- import csv of image_ratings exported by "R/data_org.R"
# image_ratings <- read.csv("data/derivatives_R/fmri_image_ratings.csv")

#### Average post-scanner ratings by block ####

# Conditions:
# A = HighLarge
# B = HighSmall
# C = LowLarge
# D = LowSmall
# E = OfficeLarge
# F = OfficeSmall

# compute average liking ratings for each block procedure
# note: in grep, ^ indicates the start of the string, $ indicates the end, .+ gets everything in between

# for each block procedure
image_ratings$like_a1 <- rowMeans(image_ratings[grep('^mrivas_a1.+like$', names(image_ratings))])
image_ratings$like_a2 <- rowMeans(image_ratings[grep('^mrivas_a2.+like$', names(image_ratings))])
image_ratings$like_a3 <- rowMeans(image_ratings[grep('^mrivas_a3.+like$', names(image_ratings))])
image_ratings$like_a4 <- rowMeans(image_ratings[grep('^mrivas_a4.+like$', names(image_ratings))])
image_ratings$like_a5 <- rowMeans(image_ratings[grep('^mrivas_a5.+like$', names(image_ratings))])

image_ratings$like_b1 <- rowMeans(image_ratings[grep('^mrivas_b1.+like$', names(image_ratings))])
image_ratings$like_b2 <- rowMeans(image_ratings[grep('^mrivas_b2.+like$', names(image_ratings))])
image_ratings$like_b3 <- rowMeans(image_ratings[grep('^mrivas_b3.+like$', names(image_ratings))])
image_ratings$like_b4 <- rowMeans(image_ratings[grep('^mrivas_b4.+like$', names(image_ratings))])
image_ratings$like_b5 <- rowMeans(image_ratings[grep('^mrivas_b5.+like$', names(image_ratings))])

image_ratings$like_c1 <- rowMeans(image_ratings[grep('^mrivas_c1.+like$', names(image_ratings))])
image_ratings$like_c2 <- rowMeans(image_ratings[grep('^mrivas_c2.+like$', names(image_ratings))])
image_ratings$like_c3 <- rowMeans(image_ratings[grep('^mrivas_c3.+like$', names(image_ratings))])
image_ratings$like_c4 <- rowMeans(image_ratings[grep('^mrivas_c4.+like$', names(image_ratings))])
image_ratings$like_c5 <- rowMeans(image_ratings[grep('^mrivas_c5.+like$', names(image_ratings))])

image_ratings$like_d1 <- rowMeans(image_ratings[grep('^mrivas_d1.+like$', names(image_ratings))])
image_ratings$like_d2 <- rowMeans(image_ratings[grep('^mrivas_d2.+like$', names(image_ratings))])
image_ratings$like_d3 <- rowMeans(image_ratings[grep('^mrivas_d3.+like$', names(image_ratings))])
image_ratings$like_d4 <- rowMeans(image_ratings[grep('^mrivas_d4.+like$', names(image_ratings))])
image_ratings$like_d5 <- rowMeans(image_ratings[grep('^mrivas_d5.+like$', names(image_ratings))])

image_ratings$like_e1 <- rowMeans(image_ratings[grep('^mrivas_e1.+like$', names(image_ratings))])
image_ratings$like_e2 <- rowMeans(image_ratings[grep('^mrivas_e2.+like$', names(image_ratings))])
image_ratings$like_e3 <- rowMeans(image_ratings[grep('^mrivas_e3.+like$', names(image_ratings))])
image_ratings$like_e4 <- rowMeans(image_ratings[grep('^mrivas_e4.+like$', names(image_ratings))])
image_ratings$like_e5 <- rowMeans(image_ratings[grep('^mrivas_e5.+like$', names(image_ratings))])

image_ratings$like_f1 <- rowMeans(image_ratings[grep('^mrivas_f1.+like$', names(image_ratings))])
image_ratings$like_f2 <- rowMeans(image_ratings[grep('^mrivas_f2.+like$', names(image_ratings))])
image_ratings$like_f3 <- rowMeans(image_ratings[grep('^mrivas_f3.+like$', names(image_ratings))])
image_ratings$like_f4 <- rowMeans(image_ratings[grep('^mrivas_f4.+like$', names(image_ratings))])
image_ratings$like_f5 <- rowMeans(image_ratings[grep('^mrivas_f5.+like$', names(image_ratings))])

# compute average fullness ratings for each block procedure of the 4 food conditions (a-d)
image_ratings$full_a1 <- rowMeans(image_ratings[grep('^mrivas_a1.+full$', names(image_ratings))])
image_ratings$full_a2 <- rowMeans(image_ratings[grep('^mrivas_a2.+full$', names(image_ratings))])
image_ratings$full_a3 <- rowMeans(image_ratings[grep('^mrivas_a3.+full$', names(image_ratings))])
image_ratings$full_a4 <- rowMeans(image_ratings[grep('^mrivas_a4.+full$', names(image_ratings))])
image_ratings$full_a5 <- rowMeans(image_ratings[grep('^mrivas_a5.+full$', names(image_ratings))])

image_ratings$full_b1 <- rowMeans(image_ratings[grep('^mrivas_b1.+full$', names(image_ratings))])
image_ratings$full_b2 <- rowMeans(image_ratings[grep('^mrivas_b2.+full$', names(image_ratings))])
image_ratings$full_b3 <- rowMeans(image_ratings[grep('^mrivas_b3.+full$', names(image_ratings))])
image_ratings$full_b4 <- rowMeans(image_ratings[grep('^mrivas_b4.+full$', names(image_ratings))])
image_ratings$full_b5 <- rowMeans(image_ratings[grep('^mrivas_b5.+full$', names(image_ratings))])

image_ratings$full_c1 <- rowMeans(image_ratings[grep('^mrivas_c1.+full$', names(image_ratings))])
image_ratings$full_c2 <- rowMeans(image_ratings[grep('^mrivas_c2.+full$', names(image_ratings))])
image_ratings$full_c3 <- rowMeans(image_ratings[grep('^mrivas_c3.+full$', names(image_ratings))])
image_ratings$full_c4 <- rowMeans(image_ratings[grep('^mrivas_c4.+full$', names(image_ratings))])
image_ratings$full_c5 <- rowMeans(image_ratings[grep('^mrivas_c5.+full$', names(image_ratings))])

image_ratings$full_d1 <- rowMeans(image_ratings[grep('^mrivas_d1.+full$', names(image_ratings))])
image_ratings$full_d2 <- rowMeans(image_ratings[grep('^mrivas_d2.+full$', names(image_ratings))])
image_ratings$full_d3 <- rowMeans(image_ratings[grep('^mrivas_d3.+full$', names(image_ratings))])
image_ratings$full_d4 <- rowMeans(image_ratings[grep('^mrivas_d4.+full$', names(image_ratings))])
image_ratings$full_d5 <- rowMeans(image_ratings[grep('^mrivas_d5.+full$', names(image_ratings))])

#### make long databases ####

#subset liking and fullness data
avg_ratings_all <- image_ratings[,grep("id|^like|^full", colnames(image_ratings))]

# subset to children included for non-parametric fmri analyses}
avg_ratings <- setDT(avg_ratings_all)[id %chin% index$id]

# get list of columns that start with "like_" and have 2 characters after
byblock_like_columns <- grep("^like_[[:alnum:]]{2}$", names(avg_ratings), value = TRUE)

# get list of columns that start with "like_" and have 2 characters after
byblock_fullness_columns <- grep("^full_[[:alnum:]]{2}$", names(avg_ratings), value = TRUE)

# wide to long -- liking ratings
byblock_like_long <- reshape2::melt(avg_ratings,
                                    # ID variables - all the variables to keep but not split apart on
                                    id.vars=c("id"),
                                    # The source columns
                                    measure.vars=byblock_like_columns,
                                    # Name of the destination column that will identify the original
                                    # column that the measurement came from
                                    variable.name="block_proc",
                                    value.name="avg_liking"
)

# wide to long -- fullness ratings
byblock_full_long <- reshape2::melt(avg_ratings,
                                    # ID variables - all the variables to keep but not split apart on
                                    id.vars=c("id"),
                                    # The source columns
                                    measure.vars=byblock_fullness_columns,
                                    # Name of the destination column that will identify the original
                                    # column that the measurement came from
                                    variable.name="block_proc",
                                    value.name="avg_fullness"
)

# cond column -- to match the way conditions are labeled for onset files
byblock_like_long <- byblock_like_long %>%
  mutate(cond = case_when(
    grepl("_a", block_proc) ~ "HighLarge",
    grepl("_b", block_proc) ~ "HighSmall",
    grepl("_c", block_proc) ~ "LowLarge",
    grepl("_d", block_proc) ~ "LowSmall",
    grepl("_e", block_proc) ~ "OfficeLarge",
    grepl("_f", block_proc) ~ "OfficeSmall",
    TRUE ~ ""  # Default value if none of the conditions are met
  ))

byblock_full_long <- byblock_full_long %>%
  mutate(cond = case_when(
    grepl("_a", block_proc) ~ "HighLarge",
    grepl("_b", block_proc) ~ "HighSmall",
    grepl("_c", block_proc) ~ "LowLarge",
    grepl("_d", block_proc) ~ "LowSmall",
    TRUE ~ ""  # Default value if none of the conditions are met
  ))

# Make portion size and category columns
byblock_like_long$category <- ifelse(grepl("High", byblock_like_long$cond), "HighED",
                                     ifelse(grepl("Low", byblock_like_long$cond), "LowED", "Office"))

byblock_like_long$cuetype <- ifelse(grepl("High", byblock_like_long$cond), "food",
                                    ifelse(grepl("Low", byblock_like_long$cond), "food", "office"))

byblock_like_long$portion <- ifelse(grepl("Large", byblock_like_long$cond), "Large", "Small")

byblock_full_long$category <- ifelse(grepl("High", byblock_full_long$cond), "HighED", "LowED")

byblock_full_long$portion <- ifelse(grepl("Large", byblock_full_long$cond), "Large", "Small")

# add mri_task version
byblock_like_long <- merge(byblock_like_long, image_ratings[, c("id", "mri_version")], by="id")
byblock_full_long <- merge(byblock_full_long, image_ratings[, c("id", "mri_version")], by="id")

# make run column
## proc order by mri_version
## version 1 (A) : 1, 3, 4, 5, 2
## version 2 (B) : 2, 5, 4, 3, 1

byblock_like_long$mri_version <- as.character(byblock_like_long$mri_version)
byblock_like_long <- byblock_like_long %>%
  mutate(run = case_when(
    mri_version == "1" & grepl("1", block_proc) ~ "1",
    mri_version == "1" & grepl("2", block_proc) ~ "5",
    mri_version == "1" & grepl("3", block_proc) ~ "2",
    mri_version == "1" & grepl("4", block_proc) ~ "3",
    mri_version == "1" & grepl("5", block_proc) ~ "4",
    mri_version == "2" & grepl("1", block_proc) ~ "5",
    mri_version == "2" & grepl("2", block_proc) ~ "1",
    mri_version == "2" & grepl("3", block_proc) ~ "4",
    mri_version == "2" & grepl("4", block_proc) ~ "3",
    mri_version == "2" & grepl("5", block_proc) ~ "2",
    TRUE ~ ""  # Default value if none of the conditions are met
  ))

byblock_full_long$mri_version <- as.character(byblock_full_long$mri_version)
byblock_full_long <- byblock_full_long %>%
  mutate(run = case_when(
    mri_version == "1" & grepl("1", block_proc) ~ "1",
    mri_version == "1" & grepl("2", block_proc) ~ "5",
    mri_version == "1" & grepl("3", block_proc) ~ "2",
    mri_version == "1" & grepl("4", block_proc) ~ "3",
    mri_version == "1" & grepl("5", block_proc) ~ "4",
    mri_version == "2" & grepl("1", block_proc) ~ "5",
    mri_version == "2" & grepl("2", block_proc) ~ "1",
    mri_version == "2" & grepl("3", block_proc) ~ "4",
    mri_version == "2" & grepl("4", block_proc) ~ "3",
    mri_version == "2" & grepl("5", block_proc) ~ "2",
    TRUE ~ ""  # Default value if none of the conditions are met
  ))

