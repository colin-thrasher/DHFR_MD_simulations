# README: Ligand Minimization and Preparation Script (02_minimize_ligands.sh)

## Overview
This script automates the preparation and minimization of ligand-bound molecular systems for molecular dynamics (MD) simulations. It sets up the necessary directories, copies input files from a template, and executes a series of predefined minimization and equilibration scripts sequentially.

## Prerequisites
To successfully run this script, ensure the following requirements are met:

1. **HPC Access**: The script is designed for execution on an HPC system using Slurm as the job scheduler.
2. **AMBER Installed**: The required AMBER tools must be installed and accessible.
3. **GPU Access**: The script requests GPU resources (`--gres=gpu`) for MD simulations.
4. **Template Directory Exists**: The template files for ligand preparation must be available at `/users/3/pier0273/amber/template/prep_md_ligands`.
5. **Variant Directories Exist**: The ligand-bound protein variants must be located in `/users/3/pier0273/amber/ligand_MD/`.
6. **Permissions**: Ensure you have read/write access to the necessary directories.

## Script Execution

### 1. Submit the Job to Slurm
Execute the script using the following command:

```bash
sbatch -p GPU_queue_name 02_minimize_ligands.sh
```

### 2. Script Workflow
- Defines the base directory for ligand MD preparation.
- Loads a predefined list of ligand-bound protein variants (`variant_dirs`).
- Defines the set of scripts to be executed sequentially for each variant.
- Iterates through each variant:
  - Ensures that the required directory structure exists.
  - Copies the `prep_md` directory from the template location if it doesn't already exist.
  - Updates script and input files by replacing placeholders (`variant_name`) with the actual variant name.
  - Runs each script in order, logging progress and checking for errors.
  - Exits immediately if any script fails to prevent corrupted MD preparation.

## Expected Output
For each variant, the script:
- Creates a `prep_md` directory (if missing) and copies required files.
- Updates input files with the correct variant name.
- Runs the following AMBER MD preparation scripts in sequence:
  - `1min1.sh` (First minimization step)
  - `1min2.sh` (Second minimization step)
  - `1min3.sh` (Third minimization step)
  - `2mdheat.sh` (Heating phase)
  - `3md.sh` to `9md.sh` (Equilibration and initial MD runs)
- Logs execution details to `script_execution.log` in the base directory.

## Troubleshooting
1. **Script execution halts**
   - Check `script_execution.log` for error messages.
   - Ensure all required scripts exist in the template directory.
   - Verify that all paths and permissions are correctly set.

2. **Scripts fail to execute**
   - Confirm that AMBER is properly installed and accessible.
   - Try loading required modules if necessary:
     ```bash
     module load amber
     ```

3. **Variant directory not found**
   - Ensure the variant directory exists in `/users/3/pier0273/amber/ligand_MD/`.
   - If missing, verify that the variant name is correctly listed in the script.

4. **Incorrect file replacements**
   - Check that `variant_name` is being correctly replaced in `.sh` and `.in` files.
   - Run the following command manually inside `prep_md/` to verify:
     ```bash
     grep "variant_name" *
     ```

## Modifications
- To process additional variants, update the `variant_dirs` array.
- To adjust minimization and MD parameters, modify the individual scripts inside `prep_md`.
- Add or remove script steps as needed by editing the `scripts` array.
