#!/bin/bash
#SBATCH --job-name=master_rmsf_workflow
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=25
#SBATCH --mem=100GB

# Load modules
module load amber/20
source activate mdenv
module load R

# Set variables
BASE_DIR="/home/schmidtd/pier0273/amber/ligand_MD"
VARIANTS=("min_1rx2")

# Step 1: Convert .nc to .dcd
echo "Converting .nc to .dcd..."
bash convert_nc_to_dcd.sh "$BASE_DIR" "${VARIANTS[@]}"

# Step 2: Calculate RMSF
echo "Calculating RMSF..."
python calculate_rmsf.py "$BASE_DIR" "${VARIANTS[@]}"

# Step 3: Analyze and plot
echo "Analyzing and plotting RMSF data..."
Rscript analyze_and_plot_rmsf.R "$BASE_DIR" "${VARIANTS[@]}"

echo "Workflow complete!"

