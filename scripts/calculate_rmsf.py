# Script: calculate_rmsf.py
# Calculates RMSF values using MDAnalysis and generates RMSF plots.

import os
import sys
import time
import MDAnalysis as mda
from MDAnalysis.analysis import rms, align
import matplotlib.pyplot as plt
import numpy as np
import glob

# Define log_message function to log messages to a file
def log_message(message, log_file):
    with open(log_file, 'a') as f:
        f.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} - {message}\n")
    print(message)

# Check if base_dir and variants are provided
if len(sys.argv) < 3:
    print("Error: Insufficient arguments provided.")
    print("Usage: python compute_rmsf_reps.py base_dir variant1 variant2 ...")
    sys.exit(1)

# Get base_dir and variants from arguments
base_dir = sys.argv[1]
variants = sys.argv[2:]

# Log file
log_file = 'rmsf_analysis_log.txt'
with open(log_file, 'w') as f:
    f.write("Starting RMSF calculation script...\n")

try:
    # Loop through the specified variants
    for variant in variants:
        variant_dir = os.path.join(base_dir, variant)

        # Check if the directory exists
        if not os.path.isdir(variant_dir):
            log_message(f"Directory {variant_dir} not found, skipping...", log_file)
            continue

        topology_files = glob.glob(os.path.join(variant_dir, "*.prmtop"))
        trajectory_files = glob.glob(os.path.join(variant_dir, "*rep[12345].dcd"))  # Match files ending with 'rep1.dcd', 'rep2.dcd', etc.

        if not topology_files or not trajectory_files:
            log_message(f"No valid topology or trajectory files found in {variant_dir}, skipping...", log_file)
            continue  # Skip if no valid topology or trajectory files are found in this subdirectory

        # Loop through trajectory files for replicates
        for trajectory_file in trajectory_files:
            try:
                replicate = trajectory_file.split("rep")[-1][0]  # Extract replicate number
                u = mda.Universe(topology_files[0], trajectory_file)
                log_message(f"Trajectory and topology files loaded for replicate {replicate} in {variant_dir}.", log_file)

                # Select protein atoms
                protein = u.select_atoms('protein')
                log_message("Protein atoms selected.", log_file)

                # Select all alpha carbon residues
                residues = u.select_atoms('name CA')
                log_message("All alpha carbon residues selected.", log_file)

                # Align the trajectory to the first frame to remove global translations and rotations
                align.AlignTraj(u, protein, select="protein and name CA", in_memory=True).run()
                log_message(f"Trajectory aligned to the first frame for replicate {replicate}.", log_file)

                # Compute RMSF
                rmsf_start = time.time()
                rmsf_analysis = rms.RMSF(residues).run()

                # Ensure proper NumPy array handling
                rmsf_values = np.asarray(rmsf_analysis.results.rmsf)

                log_message(f"RMSF computed in {time.time() - rmsf_start:.2f} seconds for replicate {replicate}.", log_file)

                # Save RMSF values to an output file
                output_file = os.path.join(variant_dir, f'rmsf_values_{variant}_rep{replicate}.txt')
                with open(output_file, 'w') as f:
                    f.write('Residue\tRMSF(Angstroms)\n')
                    for i, rmsf in enumerate(rmsf_values, start=1):
                        f.write(f'{i}\t{rmsf}\n')
                log_message(f"RMSF values saved to output file {output_file}.", log_file)

                # Plot RMSF
                plt.figure(figsize=(10, 6))
                plt.plot(range(1, len(rmsf_values) + 1), rmsf_values, marker='o')
                plt.xlabel('Residue')
                plt.ylabel('RMSF (Å)')
                plt.title(f'RMSF per Residue - Replicate {replicate}')
                plt.savefig(os.path.join(variant_dir, f'rmsf_by_residue_plot_rep{replicate}.png'))
                plt.close()  # Ensure figure is closed properly
                log_message(f"RMSF plot created and saved for replicate {replicate} in {variant_dir}.", log_file)

            except Exception as e:
                log_message(f"Error processing replicate {replicate}: {e}", log_file)

except Exception as e:
    log_message(f"Error: {e}", log_file)

# Record the end time
end_time = time.time()
log_message(f"Time taken: {end_time - time.time():.2f} seconds", log_file)

