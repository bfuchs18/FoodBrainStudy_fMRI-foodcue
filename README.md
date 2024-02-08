# FoodBrainStudy_fMRI-foodcue

This project contains code for the paper "Does 'portion size' matter? Neural responses to food and non-food cues presented in varying amounts (Fuchs et al.)"

\*\* this document is in progress \*\*

## Folder Structure

### R/

This folder contains .R and .Rmd files used for demographic and behavioral analyses

In this folder:

-   data_org.R : {description. This is sourced by beh_analyses.Rmd and demo.Rmd }
-   beh_analyses.Rmd: {description}
-   demo.Rmd: {description}

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

This folder contains code used to ....

#### BIDS/code/afni/proc_scripts

This folder contains code used to process MRI data following fmriprep

-   1_smooth-scale: smooths (blurs) and scales fmri data
-   2_createmask: creates overall foodcue mask using separate foodcue run masks
-   3_3ddeconvolve: runs first-level GLM
-   3_3ddeconvolve: runs first-level GLM with p_want as a parametric modulator

#### BIDS/code/afni/groupanalyses_paper1

This folder contains code to run group-level analyses. Files starting with 'G' contain code for statistical analyses in AFNI.
wrapper-python.py must be run before statistical analyses in AFNI ('G'); this script generates index and covariate files used in analyses (index files list subjects to be included in analyses)
Files appended with .slurm and .pbs were used to run their corresponding scripts on Penn State's computing cluster
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

