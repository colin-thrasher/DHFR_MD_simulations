#!/bin/bash

# Set base directory
base_dir="/users/3/pier0273/amber/run_MD_sims"

# Array of variant directories
variants=("s12_2n4s"
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
          "s153_2n4s")

# Loop through each variant
for variant in "${variants[@]}"; do
    echo "Processing $variant..."
    
    variant_dir="$base_dir/$variant"
    input_pdb="$variant_dir/${variant}.pdb"  # Input file
    output_pdb="$variant_dir/cleaned_${variant}.pdb"  # Output file

    # Check if the directory exists
    if [ -d "$variant_dir" ]; then
        # Check if the input PDB file exists
        if [ -f "$input_pdb" ]; then
            # Run pdb4amber to clean the PDB file
            pdb4amber -i "$input_pdb" -o "$output_pdb" --reduce
            echo "Cleaned PDB file created: $output_pdb"
        else
            echo "Input PDB file not found: $input_pdb"
        fi
    else
        echo "Directory not found: $variant_dir"
    fi
done

