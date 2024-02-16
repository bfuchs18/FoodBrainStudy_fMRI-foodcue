# FoodBrainStudy_fMRI-foodcue

This project contains code for the paper "Does 'portion size' matter? Neural responses to food and non-food cues presented in varying amounts (Fuchs et al.)"

\*\* this document is in progress \*\*

## Folder Structure

### R/

This folder contains .R and .Rmd files used for demographic and behavioral analyses

In this folder:

-   data_org.R: imports raw data and generates datasets for analyses. This is sourced by analyze_{}.Rmd scripts
-   gen_likefull.R: organizes post-scan liking and anticipated fullness ratings for analyses. This is sourced by analyze_likefull.Rmd
-   analyze_demo.Rmd: generate tables w/ descriptive stats for demographic and imaging covariates
-   analyze_beh.Rmd: plot and analyze in-scanner behavioral data (% wanting); prepare for paramteric analyzes with %want
-   analyze_likefull.Rmd: analyze and plot post-scan liking and anticipated fullness ratings by condition
-   analyze_intake_associaitons.Rmd: test and plot associations between extracted BOLD and laboratory intake

### data/

#### data/raw

This folder contains data raw data used as input for code in R/

-   FILE: {description}
-   visit6_data.sav: {description}

### BIDS/derivatives/

This folder contains derivative files used as input for code in R/

-   /analyses/foodcue-paper1/level2/index_all_fd-0.9_b20_3runs.txt
-   /preprocessed/fmriprep/task-foocue_byrun-censorsummary_fd-0.9.tsv
-   /preprocessed/fmriprep/task-foocue_byblock-censorsummary_fd-0.9.tsv
-   /preprocessed/fmriprep/task-foocue_avg-fd.tsv

### BIDS/code

This folder contains code to (1) process raw behavioral data and (2) process and analyze fMRI data

#### BIDS/code/foodcue_proc

This folder contains code used to generate derivatives needed for fmri analyses in AFNI (e.g., onset files, censor files).
Scripts that begin with p_ contain functions that can be run for 1 subject at a time.

- p0_getbehavial.py: defines function to generate behavioral (wanting) data from the food-cue task by block
- p1_getonsets.py: defines function to generate onset files that contain onsets for all runs (even those with high motion) 
- p2_create_censor_files.py: defines function to process -desc-confounds_timeseries.tsv files (output from fmriprep). and output regressor and censor files.
- p4a_gen_byrun_onsets.py: defines function to generate onset files that exclude runs with motion above a certain threshold
- p5_gen_onsets_PM.py: defines function to generate onset files for parametric analyses with %want
- wrapper-python.py: runs functions in p0, p1, p2, p4a, p5 for all subjects with food-cue task data in bids/raw_data

#### BIDS/code/afni/proc_scripts

This folder contains code used to process MRI data following fmriprep

-   1_smooth-scale: smooths (blurs) and scales fmri data
-   2_createmask: creates overall foodcue mask using separate foodcue run masks
-   3_3ddeconvolve: runs first-level GLM
-   3_3ddeconvolve: runs first-level GLM with p_want as a parametric modulator

#### BIDS/code/afni/groupanalyses_paper1

This folder contains code to run group-level analyses. Files starting with 'G' contain code for statistical analyses in AFNI.
wrapper-python.py must be run before statistical analyses in AFNI ('G'); this script generates index and covariate files used in analyses (index files list subjects to be included in analyses).
Files appended with .slurm and .pbs were used to run their corresponding scripts on Penn State's computing cluster.
Files prepended with sensitivity_ are the same as their 'G' counterparts but include an additional covariate (snack intake, yes/no)

-   G0_copylevel1: copies level-1 GLM files in paper-specific analysis folder
-   G1_1sampleT: conducts 1-sample t-tests on BOLD responses to cue type, amount, and energy density
-   G2_pairedT: tests differences in BOLD responses to amount (large - small) by cue type (food vs. office) and food energy density (higher vs. lower)
-   G3_2sampleT: tests differences in BOLD responses by familial risk status for obesity (high vs. low)
-   G4_1sampleT_FMI: conducts 1-sample t-tests on BOLD responses to cue type, amount, and energy density with fat mass index covariate
-   G5_parametric-analyses-1sampleT: tests whether BOLD responses are parametrically modulated by %want
-   G5_parametric-analyses-paired: tests whether parametric modulation of BOLD responses by %want differs by food amount and energy density
-   Gopt_MaskConjunction: overlays results of 1-sample t-tests generated via G1_1sampleT
-   prep_3dttest_covTable.py: defines a function to generate a csv with all covariates needed for fmri analyses
-   prep_avg_motion.py: defines a function to generate database with average motion (framewise displacement) for each subject
-   prep_index_byrun.py: defines a function to generate index files for non-parametric analyses
-   prep_index_PM.py: defines a function to generate index files for parametric analyses
-   wrapper-python.py: calls functions in prep_ files to generate index and covariate files needed for analyses

