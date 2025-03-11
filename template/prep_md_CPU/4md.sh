#!/bin/bash -l

module load amber/20

cd /users/3/pier0273/amber/variant_name/prep_md

sander -O -i 4md.in -o 4md.out -p ../variant_name.prmtop -c 3md.rst7 \
       -r 4md.rst7 -inf 4md.info -ref 3md.rst7 -x mdcrd.4md

