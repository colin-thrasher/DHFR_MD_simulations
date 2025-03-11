# README: Ligand-Protein Complex Preparation Script (01_prepare_ligands_tleap.sh)


## Overview
This script automates the preparation of molecular dynamics (MD) simulation input files for ligand-bound protein variants using AMBER's `tleap`. It processes multiple protein variants by aligning structures, adding ligands (NADPH and DHF), solvating the complex, and generating topology (`.prmtop`) and coordinate (`.inpcrd`) files.

## Prerequisites
To successfully run this script, ensure the following requirements are met:

1. **HPC Access**: The script is designed for execution on an HPC system using Slurm as the job scheduler.
2. **AMBER Installed**: The `tleap` utility must be installed and accessible. On MSI, tleap is available as part of the default AMBER package
3. **PyMOL Module**: The script loads `pymol`, so ensure it is available in your environment. On MSI, the default pymol module will suffice.
4. **Cleaned PDB Files**: Each variant must have a cleaned PDB file (`cleaned_<variant>.pdb`) in a subdirectory with the same name.
5. **Reference Files must be stored in a directory that is defined by the variable "reference_dir"**:
   - `cleaned_min_1rx2.pdb`: Reference structure for alignment.
   - `min_NADPH.mol2` and `min_DHF.mol2`: Ligand structure files.
   - `min_NADPH.frcmod` and `min_DHF.frcmod`: Force field parameters for ligands.
6. **Permissions**: Ensure you have read/write access to the directories involved.

## Script Execution

### 1. Submit the Job to Slurm
Execute the script using the following command:

```bash
sbatch -p queue_name 01_prepare_ligands_tleap_prep.sh
```

### 2. Script Workflow
- Loads the `pymol` module.
- Defines a set of predefined variant names.
- Iterates through each variant:
  - Ensures the corresponding directory exists.
  - Copies the cleaned PDB file from the base directory to the variant directory.
  - Calls `align_variant_pymol.py` to align the protein structure to a reference (`cleaned_min_1rx2.pdb`).
  - Generates a `tleap` script for complex preparation.
  - Loads NADPH and DHF ligand structures and parameters.
  - Combines the protein and ligands into a single complex.
  - Solvates the system and adds counterions.
  - Runs `tleap` to generate:
    - AMBER topology (`.prmtop`) file.
    - AMBER coordinate (`.inpcrd`) file.
    - A solvated `.pdb` structure.
  - Logs `tleap` output to a timestamped log file.

## Expected Output
For each variant, the script generates:
- `aligned_<variant>.pdb` (aligned protein structure)
- `leaprc_<variant>.tleap` (tleap input file)
- `tleap_<variant>_<timestamp>.log` (tleap execution log)
- `<variant>.prmtop` (AMBER topology file)
- `<variant>.inpcrd` (AMBER coordinate file)
- `solvated_<variant>.pdb` (solvated ligand-protein complex)

## Troubleshooting
1. **tleap command not found**
   - Ensure AMBER is installed and properly loaded. If using a module system, try:
     ```bash
     module load amber
     ```

2. **align_variant_pymol.py script missing or failing**
   - Ensure the script is in the working directory and executable.
   - Check the script output for alignment errors.

3. **Missing ligand files**
   - Ensure `min_NADPH.mol2`, `min_DHF.mol2`, and their `.frcmod` parameter files exist in the reference directory.

4. **tleap errors**
   - Check `tleap_<variant>_<timestamp>.log` for error messages.
   - Ensure the ligand and protein structures are correctly formatted.

## Modifications
- To process additional variants, update the `variants` array.
- Modify the solvation box size by adjusting the `solvatebox` parameter.
- Change ligand parameters or load different force fields as needed.
