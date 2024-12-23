#!/bin/tcsh
#
#useage: singularity exec /storage/group/klk37/default/sw/afni-24.2.01.simg tcsh /extract_contrasts.sh

# The purpose of this script is to extract contrasts from level-1 output to share on Neurovault for a mega-analysis

#go to and set BIDS main directory
cd ../../../
set bidsdir = "$cwd"

# set shared level 1 dir
set lev1_shared =  $bidsdir/derivatives/afni-level1

#set output_dir
set output_dir =  $bidsdir/derivatives/afni-level1/smeets_megaanalysis

mkdir -p "$output_dir"

# get list of subs based on subject folders in lev1_shared 
set subs = ( `basename -a $lev1_shared/sub*` )

# for each subject
foreach sub ($subs)
	

	set input_file = "$lev1_shared/$sub/ped_fd-0.9_b20_noGSR/stats.$sub+tlrc"
	set food_no_food_beta_map = "$output_dir/${sub}_beta_foodnofood.nii.gz"
	set high_low_ed_beta_map = "$output_dir/${sub}_beta_high_low_ed.nii.gz"
	set food_no_food_t_map = "$output_dir/${sub}_t_foodnofood.nii.gz"
	set high_low_ed_t_map = "$output_dir/${sub}_t_highlowed.nii.gz"

	if (-e "$input_file.BRIK") then

		echo "extracting for $sub"

		# extract high_low_ed_beta_map - subbrick 34
		if ( ! -f $high_low_ed_beta_map ) then
			3dTcat -prefix "$high_low_ed_beta_map" "${input_file}[34]"
		endif

		# extract high_low_ed_t_map - subbrick 35
		if ( ! -f $high_low_ed_t_map ) then
			3dTcat -prefix "$high_low_ed_t_map" "${input_file}[35]"
		endif

		# extract food_no_food_beta_map - subbrick 37
		if ( ! -f $food_no_food_beta_map ) then
			3dTcat -prefix "$food_no_food_beta_map" "${input_file}[37]"
		endif

		# extract food_no_food_t_map - subbrick 38
		if ( ! -f $food_no_food_t_map ) then
			3dTcat -prefix "$food_no_food_t_map" "${input_file}[38]"
		endif

	else
		echo "no level-1 stats file found for $sub"
	endif
end