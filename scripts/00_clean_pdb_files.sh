#!/bin/bash

# Array of variant directories
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
          "mod_s153_2n4s")

# Loop through each variant
for variant in "${variants[@]}"; do
    echo "Processing $variant..."
    
    # Check if the directory exists
    if [ -d "$variant" ]; then
        input_pdb="${variant}/${variant}.pdb"  # Input file
        output_pdb="${variant}/cleaned_${variant}.pdb"  # Output file

        # Check if the input PDB file exists
        if [ -f "$input_pdb" ]; then
            # Run pdb4amber to clean the PDB file
            pdb4amber -i "$input_pdb" -o "$output_pdb" --reduce
            echo "Cleaned PDB file created: $output_pdb"
        else
            echo "Input PDB file not found: $input_pdb"
        fi
    else
        echo "Directory not found: $variant"
    fi
done

