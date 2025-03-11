#!/bin/bash -l

module load amber/20
module load cuda cuda-sdk

cd /users/3/pier0273/amber/variant_name/prep_md

pmemd.cuda -O -i 1min1.in -o 1min1.out -p ../variant_name.prmtop -c ../variant_name.inpcrd\
 -r 1min1.rst7 -inf 1min1.info -ref ../variant_name.inpcrd -x mdcrd.1min1

