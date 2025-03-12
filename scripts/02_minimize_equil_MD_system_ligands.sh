#!/bin/bash

#SBATCH --time=00:10:00                # Maximum time the job is allowed to run
#SBATCH --ntasks=15                    # Number of tasks (cores) to be used
#SBATCH --mem=60g                      # Total memory allocated for the job
#SBATCH --gres=gpu:a100
#SBATCH --mail-type=ALL                # Send email notifications for all job events
#SBATCH --mail-user=pier0273@umn.edu   # Email address to receive notifications

# Base directory
base_dir="/users/3/pier0273/amber/run_MD_sims/ligand_MD"

# Template directory
template_dir="/users/3/pier0273/amber/run_MD_sims/template/prep_md_ligands"

# Define the directories for the variants here
variant_dirs=(
    "mod_s144_2n4s"
    "mod_s144_2zaj"
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
output_file="${base_dir}/script_execution.log"
touch "$output_file"
chmod 664 "$output_file"

# Function to log messages with date and time
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$output_file"
}

# Loop through each variant directory
for variant_dir in "${variant_dirs[@]}"; do
    variant_path="${base_dir}/${variant_dir}"
    prep_md_path="${variant_path}/prep_md"

    # Check if the variant directory exists
    if [[ ! -d "$variant_path" ]]; then
        log "Variant directory not found: $variant_path"
        continue
    fi

    # Ensure the 'prep_md' directory exists for the variant
    if [[ ! -d "$prep_md_path" ]]; then
        log "Creating 'prep_md' directory in $variant_path and copying template files."
        mkdir -p "$prep_md_path"
        cp -r "${template_dir}/"* "$prep_md_path/"
    else
        log "'prep_md' directory already exists in $variant_path, skipping template copy."
    fi

    log "Processing $variant_dir"

    # Replace 'variant_name' with the actual variant name in both .sh and .in files
    for file in "$prep_md_path"/*.sh "$prep_md_path"/*.in; do
        if [[ -f "$file" ]]; then
            log "Updating $file for $variant_dir by replacing placeholders."
            sed -i "s|variant_name|$variant_dir|g" "$file"
        fi
    done

    # Loop through each script in the array for the current variant
    for script in "${scripts[@]}"; do
        script_path="${prep_md_path}/${script}"
        if [[ -f "$script_path" ]]; then
            log "Executing $script in $prep_md_path"
            bash "$script_path"

            # Check the exit status of the script
            if [[ $? -eq 0 ]]; then
                log "$script executed successfully in $prep_md_path"
            else
                log "$script failed to execute in $prep_md_path"
                exit 1  # Exit the main script if any of the scripts fail
            fi
        else
            log "$script not found in $prep_md_path"
        fi
    done
done

log "All scripts executed successfully for all variants."

