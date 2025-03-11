#!/bin/bash -l

module load amber/20
module load cuda cuda-sdk

cd /users/3/pier0273/amber/ligand_MD/variant_name/prep_md

pmemd.cuda -O -i 7md.in -o 7md.out -p ../variant_name.prmtop -c 6md.rst7 -r 7md.rst7\
 -inf 7md.info -ref 6md.rst7 -x mdcrd.7md

