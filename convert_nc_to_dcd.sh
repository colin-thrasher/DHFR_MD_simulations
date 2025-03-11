#!/bin/bash
# Script: convert_nc_to_dcd.sh
# Converts NetCDF (.nc) files to DCD format using cpptraj.

module load amber/20

# Input: List of directories
BASE_DIR=$1
echo "Base directory: $BASE_DIR"
VARIANTS=("${@:2}")

# Loop through variants
for VARIANT in "${VARIANTS[@]}"; do
    echo "Varaint: %VARIANT"
    VARIANT_DIR="$BASE_DIR/$VARIANT"
    echo "Variant directory: %VARIANT_DIR"
    TOPOLOGY="$VARIANT_DIR/${VARIANT}.prmtop"
    echo "Topology file path: $TOPOLOGY"

    if [[ -f "$TOPOLOGY" ]]; then
        for file in "$VARIANT_DIR"/*500{ns,_ns}*rep[0-9]*.nc "$VARIANT_DIR"/*.10nc_500ns; do
            if [[ -f "$file" ]]; then
                rep_num=$(echo "$file" | grep -o 'rep[0-9]')
                output_dcd="${VARIANT_DIR}/traj_${VARIANT}_${rep_num}.dcd"
                echo -e "trajin $file\ntrajout $output_dcd dcd" | cpptraj -p "$TOPOLOGY"
                echo "Converted $file to $output_dcd"
            fi
        done
    else
        echo "Topology file $TOPOLOGY not found for $VARIANT."
    fi
done

