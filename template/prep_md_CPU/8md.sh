#!/bin/bash -l

module load amber/20

cd /users/3/pier0273/amber/variant_name/prep_md

sander -O -i 8md.in -o 8md.out -p ../variant_name.prmtop -c 7md.rst7 -r 8md.rst7\
 -inf 8md.info -ref 7md.rst7 -x mdcrd.8md

