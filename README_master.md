# README. DHFR_MD_Simulations

This repository contains scripts and files to run molecular dynamics (MD) simulations focused on mouse dihydrofolate reductase (DHFR) protein variants containing domain insertions.

## Repository Structure

The repository is organized as follows:

- `/reference_files/`: Contains parameterized files (`.frcmod`) for the ligands DHF and NADPH, necessary for ligand-bound simulations. Also includes structure and parameter files for the reference *E. coli* DHFR (`1rx2`).
- `/scripts/`: Includes scripts for setting up, running, and analyzing MD simulations. Also include **README files** for each of the scripts used to prepare, run, and analyze the MD simulations
- `/template/`: Provides template input files and configurations for initiating new simulations.


## Getting Started

To replicate or extend the simulations:

1. **Prerequisites**  
   - These simulations were tested with **AMBER20**. Other versions may work with minor code modifications.  
   - The analysis scripts require **Python 3, PyMOL, R, and MDAnalysis**.

2. **Structure Files**  
   - *Only `.pdb` files* are accepted by AMBER.  
   - Structures generated using **AlphaFold** are output as `.cif` files and must be converted to `.pdb` format before use.

3. **File cleaning**
   - All .pdb files need to be cleaned via pdb4amber prior to running MD sims in AMBER. pdb4amber ensures that the file is formatted correctly and reduced.
   - Run via script `00_clean_pdb_files.sh`

4. **Structure and system preparation**
   - The AMBER tleap module is used to parameterize, solvate, charge neutralize, and combine protein with ligands to generate parameter (.prmtop) and coordinate (.inpcrd) files
   - Run using scripts `01_prepare_ligands_tleap.sh` and `01_prepare_no_ligands_tleap.sh` (with and without ligands)

5. **Energy Minimization, Heating, and Equilibration**  
   - Performs initial energy minimization with strong positional restraints.  
   - After heating, the restraints are gradually relaxed, followed by a **final pre-equilibration step** with no restraints.  
   - The **output `.rst7` (restart) and `.prmtop` (parameter) files** from pre-equilibration are required for production runs.
   - Run using scripts `02_minimize_equil_MD_system_ligands.sh` and `02_minimize_equil_MD_system_no_ligands.sh`

6. **Execution**  
   - Production runs (in triplicate) are queued using script `03_MD_production_500_ns.sh`

7. **Analysis**  
   - Converts **output `.nc` files to `.dcd`**, calculates **RMSF and CoVar** values at each position, and generates plots.  
   - Requires **Python 3, PyMOL, R, and MDAnalysis**.

## Development & Licensing

All development was done by **Colin Pierce**.  
This repository is **not actively maintained**, but past work remains available for reference.  

This project is licensed under the **MIT License**.

