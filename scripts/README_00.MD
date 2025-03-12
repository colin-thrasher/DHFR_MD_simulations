# README: PDB Cleaning Script with pdb4amber (00_clean_pdb_files.sh)

## Overview
This script automates the cleaning of PDB files for multiple protein variants using `pdb4amber`. Each variant is stored in its respective directory within the base directory `/users/3/pier0273/amber/run_MD_sims`, and the script checks for the existence of both the directory and the input PDB file before processing.

## Prerequisites
To successfully run this script, ensure the following:

1. **AMBER Installed**: The `pdb4amber` tool must be installed and available in your environment.
2. **Variant Directories Exist**: Each variant directory should be present in the base directory `/users/3/pier0273/amber/run_MD_sims`.
3. **PDB Files Exist**: Each variant directory should contain a corresponding PDB file named `<variant>.pdb`.
4. **Permissions**: Ensure you have the necessary permissions to read/write files in these directories.

## Script Execution

### 1. Run the Script
Execute the script in the terminal as:

```bash
bash clean_pdb.sh
```

### 2. Script Workflow
- Defines an array of variant directories to process.
- Loops through each variant:
  - Checks if the directory exists within `/users/3/pier0273/amber/run_MD_sims`.
  - Checks if the input PDB file (`<variant>.pdb`) exists inside the directory.
  - Runs `pdb4amber` to clean the PDB file and outputs it as `cleaned_<variant>.pdb`.
- Displays messages if a directory or PDB file is missing.

## Expected Output
For each variant, the script generates:
- `cleaned_<variant>.pdb` inside the respective variant directory within `/users/3/pier0273/amber/run_MD_sims`.
- Console messages indicating the progress and any errors encountered.

## Troubleshooting
1. **`pdb4amber: command not found`**
   - Ensure AMBER is installed and properly loaded. If using a module system, try:
     ```bash
     module load amber
     ```

2. **Variant directory not found**
   - Ensure the variant directories are correctly named and located in `/users/3/pier0273/amber/run_MD_sims`.

3. **Input PDB file not found**
   - Ensure each variant directory contains a properly named PDB file.

## Modifications
- To process additional variants, update the `variants` array in the script.
- Modify the input/output file naming scheme if needed.

