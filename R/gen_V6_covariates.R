# pre_mri_fullness:
#

# load packages
library(haven)
library(data.table)
library(haven)
library(mice) # for imputing missing pre-mri fullness value

#### Setup ####
# source data organization script
source("R/data_org.R")

# make a copy of 'compiled' database to append variables to
compiled <- V6_compiled

#### generate pre_mri fullness values ####
compiled$pre_mri_ff <- NA
compiled$pre_mri_snack <- NA

for (i in 1:nrow(compiled)) {
  if(!is.na(compiled$ff_postmri_snack2[i])){
    compiled$pre_mri_ff[i] <- compiled$ff_postmri_snack2[i]
    compiled$pre_mri_snack[i] <- "yes"
  }
  else if(!is.na(compiled$ff_postmri_snack[i])) {
    compiled$pre_mri_ff[i] <- compiled$ff_postmri_snack[i]
    compiled$pre_mri_snack[i] <- "yes"
  }
  else if(!is.na(compiled$ff_premri_snack[i])) {
    compiled$pre_mri_ff[i] <- compiled$ff_premri_snack[i]
    compiled$pre_mri_snack[i] <- "no"
  }
}

#### impute missing pre_mri fullness value ####

impute_data <- compiled[,c('id','sex', 'age_yr', 'bmi_percentile', 'pre_mri_ff')]

# assess percent of missing values
p_missing <- unlist(lapply(impute_data, function(x) sum(is.na(x))))/nrow(impute_data)

# Run the mice code with 0 iterations
imp_template <- mice(impute_data, maxit=0)

# Extract predictorMatrix and methods of imputation
predM <- imp_template$predictorMatrix
meth <- imp_template$method

# Setting values of ID variable to 0 in the predictor matrix to leave out of imputation
predM[, c("id")] <- 0

# Impute the impute_data data, create 3 datasets, use predM as the predictor matrix and don't print the imputation process
## m is the number of imputations
## maxit is the max number of iterations for each imputation

impute <- mice(impute_data, maxit = 5, m = 3,
               predictorMatrix = predM,
               method = meth, print =  FALSE, seed = 1)

# assess values
impute$imp$pre_mri_ff

max(as.numeric(impute$imp$pre_mri_ff)) # max
min(as.numeric(impute$imp$pre_mri_ff)) # min
median(as.numeric(impute$imp$pre_mri_ff)) # median

# make df of imputed values
imputed_df <- as.data.frame(t(impute$imp$pre_mri_ff))
colnames(imputed_df) <- "imputed_value"
imputed_df <- cbind(imputed_df, imputation=c(1,2,3))

# plot imputed values amongst observed datapoints
stripplot(impute, pre_mri_ff, pch = 19, xlab = "Imputation number")

# make df of imputed values
imputed_df <- as.data.frame(t(impute$imp$pre_mri_ff))
colnames(imputed_df) <- "imputed_value"
imputed_df <- cbind(imputed_df, imputation=c(1,2,3))

imp_med = which(imputed_df$imputed_value == median(imputed_df$imputed_value))
imp_max = which(imputed_df$imputed_value == max(imputed_df$imputed_value))
imp_min = which(imputed_df$imputed_value == min(imputed_df$imputed_value))

# save complete datasets with ID and pre_mri_ff
ff_missing <- compiled[,c('id','pre_mri_ff')]

ff_complete_med <- complete(impute, imp_med)[,c('id', 'pre_mri_ff')]
colnames(ff_complete_med) <- c('id', 'imp_med')

ff_complete_max <- complete(impute, imp_max)[,c('id', 'pre_mri_ff')]
colnames(ff_complete_max) <- c('id', 'imp_max')

ff_complete_min <- complete(impute, imp_min)[,c('id', 'pre_mri_ff')]
colnames(ff_complete_min) <- c('id', 'imp_min')

# merge
ff_concat <- NA
ff_concat <- merge(x = ff_missing, y = ff_complete_med, by = "id", all.x = TRUE)
ff_concat <- merge(x = ff_concat, y = ff_complete_max, by = "id", all.x = TRUE)
ff_concat <- merge(x = ff_concat, y = ff_complete_min, by = "id", all.x = TRUE)

#### Add pre-mri CAMS value ####
CAMS_data <- compiled[,c('id','cams_pre_mri')]
V6_covar <- merge(x = ff_concat, y = CAMS_data, by = "id", all.x = TRUE)

#### Add snack intake ####
V6_covar$snack_intake <- compiled$pre_mri_snack[match(V6_covar$id, compiled$id)]

#### Export database for use in imaging analyses ####
#write.csv(V6_covar, 'data/derivatives_R/V6_covariates.csv', row.names = FALSE)
write.csv(V6_covar, 'BIDS/derivatives/analyses/foodcue-paper1/R/V6_covariates.csv', row.names = FALSE)


