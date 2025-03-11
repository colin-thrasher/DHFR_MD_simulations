#!/bin/bash -l

module load amber/20

cd /users/3/pier0273/amber/variant_name/prep_md

sander -O -i 9md.in -o 9md.out -p ../variant_name.prmtop -c 8md.rst7 -r 9md.rst7\
 -inf 9md.info -ref 8md.rst7 -x mdcrd.9md

