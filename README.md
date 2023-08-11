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

This folder contains code to run group-level analyses.

-   FILE: {description}
-   FILE: {description}
