#!/bin/bash

n=4
b=64
dt=0.1
delay=1
max_delay=100
file=random_2d_${b}.bp

bld=`echo -e '\e[1m'`
red=`echo -e '\e[31m'`
grn=`echo -e '\e[32m'`
blu=`echo -e '\e[36m'`
wht=`echo -e '\e[0m'`

echo "+ module use /usr/common/software/sensei/modulefiles"
module use /usr/common/software/sensei/modulefiles

echo "+ module load sensei/2.1.1-libsim-shared"
module load sensei/2.1.1-libsim-shared

set -x

cat ./configs/random_2d_${b}_adios.xml | sed "s/.*/$blu&$wht/"

srun -N 1 -n ${n} -r 0 -l \
    oscillator -b ${n} -t ${dt} -s ${b},${b},1  -p 0 -g 1 \
    -f ./configs/random_2d_${b}_adios.xml \
    ./configs/random_2d_${b}.osc 2>&1 | sed "s/.*/$red&$wht/" &

cat ./configs/random_2d_${b}_libsim_it.xml | sed "s/.*/$blu&$wht/"

srun -N 1 -n ${n} -r 1 \
     ADIOSAnalysisEndPoint -r flexpath \
    -f ./configs/random_2d_${b}_libsim_it.xml \
    random_2d_${b}.bp  2>&1 | sed "s/.*/$grn&$wht/"
