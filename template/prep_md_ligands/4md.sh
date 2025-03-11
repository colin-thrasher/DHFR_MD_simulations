#!/bin/bash -l

module load amber/20
module load cuda cuda-sdk

cd /users/3/pier0273/amber/ligand_MD/variant_name/prep_md

pmemd.cuda -O -i 4md.in -o 4md.out -p ../variant_name.prmtop -c 3md.rst7 \
       -r 4md.rst7 -inf 4md.info -ref 3md.rst7 -x mdcrd.4md

