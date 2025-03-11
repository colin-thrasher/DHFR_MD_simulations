#!/bin/bash

#SBATCH --time=00:15:00                # Maximum time the job is allowed to run
#SBATCH --ntasks=15                    # Number of tasks (cores) to be used
#SBATCH --mem=60g                     # Total memory allocated for the job
#SBATCH --gres=gpu:a100
#SBATCH --mail-type=ALL                # Send email notifications for all job events
#SBATCH --mail-user=pier0273@umn.edu   # Email address to receive notifications

# Description:
# This script automates the execution of 9 molecular dynamics preparation steps
# (minimization, equilibration, heating, etc.) for multiple variants. Each variant has its
# own subdirectory under the base directory (/users/3/pier0273/amber), and each step
# is executed sequentially within the 'prep_md' subdirectory of each variant.
# 
# Input Files:
# - Each variant's directory contains template .sh and .in files with placeholders 
#   that are replaced with the specific variant name during execution.
# - The base variant subdirectories are listed in the `variant_dirs` array, and each variant 
#   directory must have the necessary topology and parameter files for the MD preparation steps.
# - A template directory (`/users/3/pier0273/amber/template/prep_md`) contains the `prep_md`
#   folder with the 9 .sh scripts that are copied to each variant's directory, if not already present.
#
# Output Files:
# - Log files are written to each variant's `prep_md` directory as the scripts are executed, 
#   recording the progress of each preparation step.
# - A master log file (`script_execution.log`) is created in the base directory to track the 
#   overall execution status for all variants.
# - If any script fails, the error is logged in `script_execution.log` and the job terminates.
#


# Base directory
base_dir="/users/3/pier0273/amber"

# Template directory
template_dir="/users/3/pier0273/amber/template/prep_md"

# Define the directories for the variants here
variant_dirs=(
          "mod_s12_2n4s"
          "mod_s20_2n4s"
          "mod_s26_2n4s"
          "mod_s26_2zaj"
          "mod_s43_2n4s"
          "mod_s55_2n4s"
          "mod_s63_2n4s"
          "mod_s80_2n4s"
          "mod_s102_2n4s"
          "mod_s115_2n4s"
          "mod_s127_2n4s"
          "mod_s144_2n4s"
          "mod_s144_2zaj"
          "mod_s153_2n4s"
)

# Define an array of scripts to execute sequentially for each variant
scripts=(
    "1min.sh"
    "2mdheat.sh"
    "3md.sh"
    "4md.sh"
    "5min.sh"
    "6md.sh"
    "7md.sh"
    "8md.sh"
    "9md.sh"
)

# Output file for logging
output_file="$base_dir/script_execution.log"
touch "$output_file"
chmod 664 "$output_file"

# Function to log messages with date and time
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$output_file"
}

# Loop through each variant directory
for variant_dir in "${variant_dirs[@]}"; do
    variant_path="$base_dir/$variant_dir"

    # Check if variant directory exists
    if [[ ! -d "$variant_path" ]]; then
        log "Variant directory not found: $variant_path"
        continue
    fi

    # Fix permissions to ensure user has write access
    chmod -R u+w "$variant_path/prep_md"

    # Copy the 'prep_md' directory from the template if it doesn't already exist in the variant directory
    if [[ ! -d "$variant_path/prep_md" ]]; then
        log "Copying 'prep_md' directory to $variant_dir"
        cp -r "$template_dir" "$variant_path/prep_md"
    else
        log "'prep_md' directory already exists in $variant_dir, skipping copy."
    fi

    # Navigate to the 'prep_md' directory of the variant
    cd "$variant_path/prep_md" || { log "Directory not found: $variant_path/prep_md"; exit 1; }

    log "Processing $variant_dir"

    # Replace 'variant_name' with the actual variant name in both .sh and .in files
    for file in *.sh *.in; do
        if [[ -f "$file" ]]; then
            log "Updating $file for $variant_dir by replacing placeholders."
            sed -i "s|variant_name|$variant_dir|g" "$file"
        fi
    done

    # Loop through each script in the array for the current variant
    for script in "${scripts[@]}"; do
        if [[ -f "$script" ]]; then
            log "Executing $script in $variant_dir"
            bash "$script"

            # Check the exit status of the script
            if [[ $? -eq 0 ]]; then
                log "$script executed successfully in $variant_dir"
            else
                log "$script failed to execute in $variant_dir"
                exit 1  # Exit the main script if any of the scripts fail
            fi
        else
            log "$script not found in $variant_dir"
        fi
    done

    # Return to the base directory
    cd "$base_dir"
done

log "All scripts executed successfully for all variants"

