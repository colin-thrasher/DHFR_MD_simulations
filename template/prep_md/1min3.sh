#!/bin/bash

module load amber/20
module load cuda cuda-sdk

cd /users/3/pier0273/amber/variant_name/prep_md

pmemd.cuda -O -i 1min3.in -o 1min3.out -p ../variant_name.prmtop -c 1min2.rst7\
 -r 1min3.rst7 -inf 1min3.info -ref 1min2.rst7 -x mdcrd.1min3
