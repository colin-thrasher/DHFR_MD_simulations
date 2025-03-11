#!/bin/bash -l

module load amber/20
module load cuda cuda-sdk

cd /users/3/pier0273/amber/variant_name/prep_md

pmemd.cuda -O -i 6md.in -o 6md.out -p ../variant_name.prmtop -c 5min.rst7 -r 6md.rst7\
 -inf 6md.info -ref 5min.rst7 -x mdcrd.6md

