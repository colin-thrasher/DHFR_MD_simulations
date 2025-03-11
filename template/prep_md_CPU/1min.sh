#!/bin/bash -l

module load amber/20

cd /users/3/pier0273/amber/variant_name/prep_md

sander -O -i 1min.in -o 1min.out -p ../variant_name.prmtop -c ../variant_name.inpcrd\
 -r 1min.rst7 -inf 1min.info -ref ../variant_name.inpcrd -x mdcrd.1min

