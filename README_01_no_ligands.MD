# README: AMBER tleap Preparation Script (01_prepare_no_ligands_tleap.sh)

## Overview
This script automates the preparation of molecular dynamics (MD) simulation input files using AMBER's `tleap`. It processes multiple protein variants, loads their cleaned PDB structures, solvates them, and generates topology (`.prmtop`) and coordinate (`.inpcrd`) files for further simulation steps.

## Prerequisites
To successfully run this script, ensure the following requirements are met:

1. **HPC Access**: The script is designed for execution on an HPC system using Slurm as the job scheduler.
2. **AMBER Installed**: The `tleap` utility must be installed and accessible. On MSI, tleap is available as part of the default AMBER package
3. **PyMOL Module**: The script loads `pymol`, so ensure it is available in your environment. On MSI, the default pymol module will suffice.
4. **Cleaned PDB Files**: Each variant must have a cleaned PDB file (`cleaned_<variant>.pdb`) in a subdirectory with the same name.
5. **Permissions**: Ensure you have the necessary permissions to read/write files in the specified directories.

## Script Execution

### 1. Submit the Job to Slurm
Execute the script using the following command:

```bash
sbatch -p queue_name 01_prepare_no_ligands_tleap.sh
```

### 2. Script Workflow
- Loads the `pymol` module.
- Defines a set of predefined variant names.
- Iterates through each variant:
  - Checks for the existence of the corresponding variant directory.
  - Ensures that a cleaned PDB file (`cleaned_<variant>.pdb`) is available.
  - Generates a `tleap` script for solvating and neutralizing the system.
  - Runs `tleap` to generate:
    - AMBER topology (`.prmtop`) file.
    - AMBER coordinate (`.inpcrd`) file.
    - A solvated `.pdb` structure.
  - Logs `tleap` output to a timestamped log file.

## Expected Output
For each variant, the script generates:
- `leaprc_<variant>.tleap` (tleap input file)
- `tleap_<variant>_<timestamp>.log` (tleap execution log)
- `<variant>.prmtop` (AMBER topology file)
- `<variant>.inpcrd` (AMBER coordinate file)
- `solvated_<variant>.pdb` (solvated structure)

## Troubleshooting
1. **tleap command not found**
   - Ensure AMBER is installed and properly loaded. If using a module system, try:
     ```bash
     module load amber
     ```

2. **Cleaned PDB file not found**
   - Ensure that `cleaned_<variant>.pdb` exists in each variant directory.

3. **tleap fails with errors**
   - Check the `tleap_<variant>_<timestamp>.log` for details.
   - Ensure the PDB file is properly formatted and compatible with AMBER force fields.

## Modifications
- To process additional variants, update the `variants` array.
- Modify the solvation box size by adjusting the `solvatebox` parameter.
- Customize the force field by modifying `leaprc.protein.ff14SB` and `leaprc.water.tip3p`.



