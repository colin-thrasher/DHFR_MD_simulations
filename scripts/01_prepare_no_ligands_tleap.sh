#!/bin/bash

#SBATCH --time=00:25:00                # Maximum time the job is allowed to run
#SBATCH --ntasks=15                    # Number of tasks (cores) to be used
#SBATCH --mem=60g                      # Total memory allocated for the job
#SBATCH --mail-type=ALL                # Send email notifications for all job events
#SBATCH --mail-user=pier0273@umn.edu   # Email address to receive notifications

module load pymol


# Set base directory
base_dir="/users/3/pier0273/amber"

# Predefined variants (add more as needed)
variants=("mod_s12_2n4s"
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

# Create a timestamp for this run
timestamp=$(date +%Y%m%d_%H%M%S)


# Loop through each variant
for variant in "${variants[@]}"
do
    echo "Processing $variant for scenario: $scenario..."

    # Define directories and file paths
    variant_dir="${base_dir}/${variant}"
    cleaned_pdb_source="${variant_dir}/cleaned_${variant}.pdb"
    cleaned_pdb="${variant_dir}/cleaned_${variant}.pdb"

    # Ensure the variant directory exists
    if [ ! -d "$variant_dir" ]; then
        echo "Directory $variant_dir does not exist. Creating..."
        mkdir -p "$variant_dir"
    fi

    # Check if the cleaned PDB file exists in the source directory
    if [ ! -f "$cleaned_pdb_source" ]; then
        echo "Error: Cleaned PDB file $cleaned_pdb_source does not exist. Skipping $variant..."
        continue
    fi

    prmtop_file="${variant_dir}/${variant}.prmtop"
    inpcrd_file="${variant_dir}/${variant}.inpcrd"

    cat > "${variant_dir}/leaprc_${variant}.tleap" <<EOF
source leaprc.protein.ff14SB
source leaprc.water.tip3p

# Load the protein structure
protein = loadpdb "${variant_dir}/cleaned_${variant}.pdb"

# Solvate and neutralize the system
solvatebox protein TIP3PBOX 10.0
charge protein
addions protein Na+ 0
addions protein Cl- 0

# Save files
saveamberparm protein ${prmtop_file} ${inpcrd_file}
savepdb protein ${variant_dir}/solvated_${variant}.pdb

quit
EOF

    # Run tleap
    tleap -s -f "${variant_dir}/leaprc_${variant}.tleap" > "${variant_dir}/tleap_${variant}_${timestamp}.log"

done

# Summary
echo "Pipeline summary:"
for variant in "${variants[@]}"; do
    prmtop_file="${variant_dir}/${variant}.prmtop"
    inpcrd_file="${variant_dir}/${variant}.inpcrd"

done

echo "Preparation completed for scenario: $scenario!"

