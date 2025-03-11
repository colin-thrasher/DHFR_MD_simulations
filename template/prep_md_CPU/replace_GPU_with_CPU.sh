#!/bin/bash

# Directory containing the .sh files
DIRECTORY="/users/3/pier0273/amber/template/prep_md_CPU"

# Loop through each .sh file in the directory, excluding "replace_GPU_with_CPU.sh"
for file in "$DIRECTORY"/*.sh; do
    # Skip the specified file
    if [[ "$(basename "$file")" == "replace_GPU_with_CPU.sh" ]]; then
        continue
    fi

    # Check if the file exists to avoid errors with non-matching patterns
    if [[ -f "$file" ]]; then
        # Remove lines containing "module load cuda cuda-sdk"
        sed -i '/module load cuda cuda-sdk/d' "$file"
        
        # Replace "pmemd" with "sander"
        sed -i 's/pmemd/sander/g' "$file"
        
        echo "Processed $file"
    fi
done

