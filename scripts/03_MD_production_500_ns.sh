#!/bin/bash

#SBATCH --time=12:00:00               # Maximum time the job is allowed to run
#SBATCH --ntasks=50                   # Number of tasks (cores) to be used
#SBATCH --mem=200gb                   # Total memory allocated for the job
#SBATCH --gres=gpu             
#SBATCH --mail-type=ALL               # Send email notifications for all job events
#SBATCH --mail-user=pier0273@umn.edu  # Email address to receive notifications

# Description:
# This script automates the execution of molecular dynamics production runs for
# multiple variants. Each variant has its own subdirectory under the base directory.
# The MD production input file is copied from a template directory and used for
# each variant before running the simulation.

# Base directory
base_dir="/users/3/pier0273/amber"

# Template directory for the production MD input file
template_dir="/users/3/pier0273/amber/template"

# MD production input file name
md_input_file="10md_prod_500_ns.in"

# Define the directories for the variants
variant_dirs=(
	  "1rx2"
          "s102_2n4s"
          "s144_2n4s"
)

# Output file for logging
output_file="$base_dir/md_production_log.txt"
touch "$output_file"
chmod 664 "$output_file"

# Function to log messages with date and time
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$output_file"
}

# Loop through each variant directory
for variant_dir in "${variant_dirs[@]}"; do
    variant_path="$base_dir/$variant_dir"

    # Check if the variant directory exists
    if [[ ! -d "$variant_path" ]]; then
        log "Variant directory not found: $variant_path"
        continue
    fi

    # Ensure the production input file is copied to the variant directory
    if [[ ! -f "$variant_path/$md_input_file" ]]; then
        log "Copying $md_input_file to $variant_dir"
        cp "$template_dir/$md_input_file" "$variant_path/"
        if [[ $? -eq 0 ]]; then
            log "$md_input_file copied successfully to $variant_dir"
        else
            log "Failed to copy $md_input_file to $variant_dir"
            exit 1
        fi
    else
        log "$md_input_file already exists in $variant_dir, skipping copy."
    fi

    # Navigate to the variant directory
    cd "$variant_path" || { log "Directory not found: $variant_path"; exit 1; }

    log "Processing $variant_dir for MD production"

    # Run the production MD simulation for 500 ns
    for i in {1..3}; do
        log "Running replicate ${i} for $variant_dir"

        pmemd.cuda -O -i "$md_input_file" -p "${variant_dir}.prmtop" \
            -c prep_md/9md.rst7 -ref prep_md/9md.rst7 \
            -inf "10md_prod_500_ns_${variant_dir}_rep${i}.info" \
            -o "10md_prod_500_ns_${variant_dir}_rep${i}.out" \
            -r "10md_prod_500_ns_${variant_dir}_rep${i}.rst7" \
            -x "mdcrd_${variant_dir}_rep${i}.10nc_500ns"

        # Check the exit status of the command
        if [[ $? -eq 0 ]]; then
            log "MD production rep${i} executed successfully for $variant_dir"
        else
            log "MD production rep${i} failed for $variant_dir"
            exit 1  # Exit if any of the simulations fail
        fi
    done

    log "MD production simulations completed for $variant_dir"
    
    # Return to the base directory for the next variant
    cd "$base_dir"
done

log "All MD production simulations completed for all variants"

