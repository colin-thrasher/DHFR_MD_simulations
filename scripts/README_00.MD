# README: PDB Cleaning Script with pdb4amber (00_clean_pdb_files.sh)

## Overview
This script automates the cleaning of PDB files for multiple protein variants using `pdb4amber`. Each variant is stored in its respective directory, and the script checks for the existence of both the directory and the input PDB file before processing.

## Prerequisites
To successfully run this script, ensure the following:

1. **AMBER Installed**: The `pdb4amber` tool must be installed and available in your environment.
2. **Variant Directories Exist**: Each variant directory should be present in the current working directory.
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
  - Checks if the directory exists.
  - Checks if the input PDB file (`<variant>.pdb`) exists inside the directory.
  - Runs `pdb4amber` to clean the PDB file and outputs it as `cleaned_<variant>.pdb`.
- Displays messages if a directory or PDB file is missing.

## Expected Output
For each variant, the script generates:
- `cleaned_<variant>.pdb` inside the respective variant directory.
- Console messages indicating the progress and any errors encountered.

## Troubleshooting
1. **`pdb4amber: command not found`**
   - Ensure AMBER is installed and properly loaded. If using a module system, try:
     ```bash
     module load amber
     ```

2. **Variant directory not found**
   - Ensure the variant directories are correctly named and located in the current directory.

3. **Input PDB file not found**
   - Ensure each variant directory contains a properly named PDB file.

## Modifications
- To process additional variants, update the `variants` array.
- Modify the input/output file naming scheme if needed.
