#!/bin/bash -l

module load amber/20
module load cuda cuda-sdk

cd /users/3/pier0273/amber/ligand_MD/variant_name/prep_md

pmemd.cuda -O -i 3md.in -o 3md.out -p ../variant_name.prmtop -c 2mdheat.rst7 \
       -r 3md.rst7 -inf 3md.info -ref 2mdheat.rst7 -x mdcrd.3md

