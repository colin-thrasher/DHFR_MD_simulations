#!/bin/bash -l

module load amber/20

cd /users/3/pier0273/amber/variant_name/prep_md

sander -O -i 5min.in -o 5min.out -p ../variant_name.prmtop -c 4md.rst7\
 -r 5min.rst7 -inf 5min.info -ref 4md.rst7 -x mdcrd.5md

