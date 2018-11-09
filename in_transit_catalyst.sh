#!/bin/bash

n=4
b=64
dt=0.5
delay=1
max_delay=100
file=random_2d_${b}.bp
bld=`echo -e '\e[1m'`
red=`echo -e '\e[31m'`
grn=`echo -e '\e[32m'`
blu=`echo -e '\e[36m'`
wht=`echo -e '\e[0m'`

echo "+ module load sensei/2.1.1-catalyst-shared"
module load sensei/2.1.1-catalyst-shared

set -x

cat ./configs/random_2d_${b}_adios.xml | sed "s/.*/$blu&$wht/"

mpiexec -n ${n} \
    oscillator -b ${n} -t ${dt} -s ${b},${b},1  -p 0 -g 1 \
    -f ./configs/random_2d_${b}_adios.xml \
    ./configs/random_2d_${b}.osc 2>&1 | sed "s/.*/$red&$wht/" &

cat ./configs/random_2d_${b}_catalyst.xml | sed "s/.*/$blu&$wht/"

mpiexec -n ${n} \
    ADIOSAnalysisEndPoint -r flexpath \
    -f ./configs/random_2d_${b}_catalyst.xml \
    random_2d_${b}.bp  2>&1 | sed "s/.*/$grn&$wht/"
