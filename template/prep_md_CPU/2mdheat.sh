#!/bin/bash -l

module load amber/20

cd /users/3/pier0273/amber/variant_name/prep_md

sander -O -i 2mdheat.in -o 2mdheat.out -p ../variant_name.prmtop -c 1min.rst7\
       -r 2mdheat.rst7 -inf 2mdheat.info -ref 1min.rst7 -x mdcrd.2mdheat

