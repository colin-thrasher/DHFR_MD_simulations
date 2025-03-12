#!/bin/bash

#SBATCH --time=00:30:00                # Maximum time the job is allowed to run
#SBATCH --ntasks=15                    # Number of tasks (cores) to be used
#SBATCH --mem=60g                      # Total memory allocated for the job
#SBATCH --mail-type=ALL                # Send email notifications for all job events
#SBATCH --mail-user=pier0273@umn.edu   # Email address to receive notifications

module load pymol

base_dir="/users/3/pier0273/amber"
reference_dir="${base_dir}/ligand_MD/reference_files"

# Predefined variants (add more as needed)
variants=("1rx2"
	  "3d80"
	  "6a7e"
	  "s12_2n4s"
          "s20_2n4s"
          "s26_2n4s"
          "s26_2zaj"
          "s43_2n4s"
          "s55_2n4s"
          "s63_2n4s"
          "s80_2n4s"
          "s102_2n4s"
          "s115_2n4s"
          "s127_2n4s"
          "s144_2n4s"
          "s144_2zaj"
          "s153_2n4s"
          )

# Create a timestamp for this run
timestamp=$(date +%Y%m%d_%H%M%S)


# Loop through each variant
for variant in "${variants[@]}"
do
    echo "Processing $variant"

    # Define directories and file paths
    variant_dir="${base_dir}/ligand_MD/${variant}"
    cleaned_pdb_source="${base_dir}/${variant}/cleaned_${variant}.pdb"
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

    # Copy the cleaned PDB file to the variant directory
    echo "Copying $cleaned_pdb_source to $variant_dir..."
    cp "$cleaned_pdb_source" "$cleaned_pdb"

    # Step 1: Align structures if ligands are present
     echo "Aligning structure for ligands..."
     reference_file="${reference_dir}/cleaned_min_1rx2.pdb"
     aligned_file="${variant_dir}/aligned_${variant}.pdb"

     python align_variant_pymol.py "$variant" "$reference_file"

    # Validate the aligned PDB file

    # Step 2: Generate topology and coordinates with tleap
    prmtop_file="${variant_dir}/${variant}.prmtop"
    inpcrd_file="${variant_dir}/${variant}.inpcrd"

    cat > "${variant_dir}/leaprc_${variant}.tleap" <<EOF
source leaprc.protein.ff14SB
source leaprc.gaff
source leaprc.water.tip3p

# Load NADPH and DHF if ligands are present
NADPH = loadmol2 "/users/3/pier0273/amber/ligand_MD/reference_files/min_NADPH.mol2"
loadamberparams "/users/3/pier0273/amber/ligand_MD/reference_files/min_NADPH.frcmod"

DHF = loadmol2 "/users/3/pier0273/amber/ligand_MD/reference_files/min_DHF.mol2"
loadamberparams "/users/3/pier0273/amber/ligand_MD/reference_files/min_DHF.frcmod"


# Load the protein structure
protein = loadpdb "${aligned_file}"

# Combine components (protein and ligands if present)
complex = combine { protein NADPH DHF }

# Solvate and neutralize the system
solvatebox complex TIP3PBOX 10.0
charge complex
addions complex Na+ 0
addions complex Cl- 0

# Save files
saveamberparm complex ${prmtop_file} ${inpcrd_file}
savepdb complex ${variant_dir}/solvated_${variant}.pdb

quit
EOF

    # Run tleap
    tleap -s -f "${variant_dir}/leaprc_${variant}.tleap" > "${variant_dir}/tleap_${variant}_${timestamp}.log"

done

# Summary
echo "Pipeline summary:"
for variant in "${variants[@]}"; do
    aligned_file="${base_dir}/ligand_MD/${variant}/aligned_${variant}.pdb"
    prmtop_file="${base_dir}/ligand_MD/${variant}/${variant}.prmtop"
    inpcrd_file="${base_dir}/ligand_MD/${variant}/${variant}.inpcrd"

    if [ -f "$aligned_file" ] && [ -f "$prmtop_file" ] && [ -f "$inpcrd_file" ]; then
        echo "$variant: Preparation completed successfully."
    else
        echo "$variant: Preparation failed. Check logs."
    fi
done



