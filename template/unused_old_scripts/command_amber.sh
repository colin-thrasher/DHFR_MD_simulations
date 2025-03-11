#!/bin/bash
#SBATCH --time=15:00:00
#SBATCH --ntasks=15
#SBATCH --mem=225g
#SBATCH --tmp=400g
#SBATCH -p v100
#SBATCH --gres=gpu:v100:1
#SBATCH --mail-type=ALL  
#SBATCH --mail-user=pier0273@umn.edu



# Define an array of scripts to execute sequentially.  Comment out this section if getting the 
scripts=(
	"1min.sh"
	"2md.sh"
	"3md.sh"
	"4md.sh"
	"5min.sh"
	"6md.sh"
 	"7md.sh"
	"8md.sh"
	"9md.sh"
	"10md_prod_500_ns.sh"    

    # Add more scripts here if needed
)

### OPTIONAL:  Get a list of files in the directory without having to specify the individual names of the files/variants

# Directory containing the scripts
script_dir="/path/to/scripts/directory"

# Output file for logging
output_file="script_execution.log"

# Get a list of files in the directory
#scripts=("$script_dir"/*)

### End optional section


# Loop through each script in the array
for script in "${scripts[@]}"; do
    echo "Executing $script"
    # Execute the script
    bash "$script"
    # Check the exit status of the script
    if [ $? -eq 0 ]; then
        echo "$script executed successfully" >> "$output_file"
    else
        echo "$script failed to execute"  >> "$output_file"
        exit 1  # Exit the main script if any of the scripts fail
    fi
done

echo "All scripts executed successfully"  >> "$output_file"

