# README: Molecular Dynamics Production Run Script

## Overview

This script automates the execution of molecular dynamics (MD) production runs for multiple enzyme variants using AMBER. Each variant has its own subdirectory, and the script ensures that the required production input file is copied from a template directory before executing the simulations.

## Prerequisites

To successfully run this script, ensure the following requirements are met:

1. **HPC Access**: The script is designed for use on an HPC cluster using Slurm as the job scheduler.
2. **AMBER Installed**: The `pmemd.cuda` executable must be available for running GPU-accelerated MD simulations. 
3. **Template Input File**: A properly configured AMBER input file (`10md_prod_500_ns.in`) should exist in the template directory.
4. **Topology Files**: Each variant directory should contain the respective topology file (`<variant>.prmtop`).
5. **Checkpoint Files**: The restart and reference files (`prep_md/9md.rst7`) must be present in each variant directory.i
6. Ensure that sufficient resources are available, typically 12 hours of runtime per variant where each variant has 3 reps
7. **Permissions**: Ensure you have the necessary permissions to run the script and modify files in the target directories.
8. Set user's email address in the SLURM header



## Script Execution

### 1. Submit the Job to Slurm

The script should be submitted as a Slurm job using the following command:

```bash
sbatch -p GPU_queue_name 03_MD_production_500_ns.sh
```

### 2. Script Breakdown

- **Slurm Directives:**

  - Requests 50 CPU tasks, 200GB memory, and GPU access.
  - Sets a 12 hour time limit for 3 production runs total
  - Sends email notifications to `pier0273@umn.edu`.

- **Base and Template Directories:**

  - `base_dir` is set to `/users/3/pier0273/amber`.
  - The input template file is stored in `/users/3/pier0273/amber/template`.

- **Processing Variants:**

  - The script iterates over predefined variant directories (`1rx2`, `s102_2n4s`, `s144_2n4s`).
  - Ensures the MD input file exists in each directory.
  - If missing, it copies the template input file.

- **Running MD Simulations:**

  - The script runs a single replicate (rep 4) for each variant using `pmemd.cuda`.
  - Simulation outputs include:
    - `10md_prod_500_ns_<variant>_rep4.out` (log file)
    - `10md_prod_500_ns_<variant>_rep4.rst7` (restart file)
    - `mdcrd_<variant>_rep4.10nc_500ns` (trajectory file)

- **Logging and Error Handling:**

  - Logs messages to `md_production_log.txt` with timestamps.
  - Exits immediately if a critical step fails (e.g., missing directory, failed simulation).

## Expected Output

Each variant directory will contain:

- MD simulation output files (`.out`, `.rst7`, `.info`, `.nc`).
- Updated `md_production_log.txt` with progress logs.

## Troubleshooting

1. **Job fails immediately:**

   - Ensure Slurm is properly configured and you have permission to submit jobs.
   - Check if required files exist in the `template` and `variant` directories.

2. **MD Simulation Errors:**

   - Verify that topology files (`<variant>.prmtop`) and restart files (`9md.rst7`) exist.
   - Check AMBER output logs for error messages.

3. **Log File Shows Missing Directories:**

   - Confirm that the variant subdirectories are correctly named under `base_dir`.

## Modifications

- To add more variants, update the `variant_dirs` array.
- To adjust Slurm resource requests, modify the `#SBATCH` directives.
- To run multiple replicates, adjust the loop in the `for i in {1..3}` section.

---

This script ensures efficient automation of molecular dynamics simulations, reducing manual setup errors and improving reproducibility.




