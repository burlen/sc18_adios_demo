#!/bin/bash

n=4
b=64
dt=0.25
delay=1
max_delay=100
file=random_2d_${b}.bp
bld=`echo -e '\e[1m'`
red=`echo -e '\e[31m'`
grn=`echo -e '\e[32m'`
blu=`echo -e '\e[36m'`
wht=`echo -e '\e[0m'`

echo "+ module load sensei/3.0.0-catalyst-shared"
module load sensei/3.0.0-catalyst-shared

set -x

cat ./configs/random_2d_${b}_adios1_write.xml | sed "s/.*/$blu&$wht/"

mpiexec -n ${n} \
    oscillator -b ${n} -t ${dt} -s ${b},${b},1  -p 0 -g 1 \
    -f ./configs/random_2d_${b}_adios1_write.xml \
    ./configs/random_2d_${b}.osc 2>&1 | sed "s/.*/$red&$wht/" &

cat ./configs/random_2d_${b}_adios1_read.xml | sed "s/.*/$blu&$wht/"
cat ./configs/random_2d_${b}_catalyst.xml | sed "s/.*/$blu&$wht/"

mpiexec -n ${n} \
    SENSEIEndPoint -t ./configs/random_2d_${b}_adios1_read.xml \
    -a ./configs/random_2d_${b}_catalyst.xml 2>&1 | sed "s/.*/$grn&$wht/"
