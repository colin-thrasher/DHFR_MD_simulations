README. DHFR_MD_Simulations

This repository contains scripts and files to run molecular dynamics (MD) simulations focused on mouse dihydrofolate reductase (DHFR) protein variants containing domain insertions.
Repository Structure

The repository is organized as follows:

    /reference_files/: Contains parameterized files (.frcmod) for the ligands DHF and NADPH, necessary for ligand-bound simulations. Also includes structure and parameter files for the reference E. coli DHFR (1rx2).
    /scripts/: Includes scripts for setting up, running, and analyzing MD simulations.
    /template/: Provides template input files and configurations for initiating new simulations.

Getting Started

To replicate or extend the simulations:

    Prerequisites
        These simulations were tested with AMBER20. Other versions may work with minor code modifications.
        The analysis scripts require Python 3, PyMOL, R, and MDAnalysis.

    Structure Files
        Only .pdb files are accepted by AMBER.
        Structures generated using AlphaFold are output as .cif files and must be converted to .pdb format before use.

    Energy Minimization, Heating, and Equilibration
        script_01 (with and without ligands) performs energy minimization with strong positional restraints.
        After heating, the restraints are gradually relaxed, followed by a final pre-equilibration step with no restraints.
        The output .rst7 (restart) and .prmtop (parameter) files from pre-equilibration are required for production runs.

    Execution
        Production runs (in triplicate) are queued using script_03.

    Analysis
        Converts output .nc files to .dcd, calculates RMSF and CoVar values at each position, and generates plots.
        Requires Python 3, PyMOL, R, and MDAnalysis.

Development & Licensing

All development was done by Colin Pierce.
This repository is not actively maintained, but past work remains available for reference.

This project is licensed under the MIT License.
