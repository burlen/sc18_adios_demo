#!/bin/bash

n=4
b=64
dt=0.1
delay=1
max_delay=100
file=random_2d_${b}.bp
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
bld=`echo -e '\e[1m'`
red=`echo -e '\e[31m'`
grn=`echo -e '\e[32m'`
blu=`echo -e '\e[36m'`
wht=`echo -e '\e[0m'`

mkdir -p ./configs
cp ${script_dir}/configs/* ./configs

echo "+ module use /usr/common/software/sensei/modulefiles"
module use /usr/common/software/sensei/modulefiles

echo "+ module load sensei/2.1.0-catalyst-shared"
module load sensei/2.1.0-catalyst-shared

set -x

cat ./configs/random_2d_${b}_adios.xml | sed "s/.*/$blu&$wht/"

srun -N 1 -n ${n} -r 0 -l \
    oscillator -b ${n} -t ${dt} -s ${b},${b},1  -p 0 -g 1 \
    -f ./configs/random_2d_${b}_adios.xml \
    ./configs/random_2d_${b}.osc 2>&1 | sed "s/.*/$red&$wht/" &

cat ./configs/random_2d_${b}_catalyst.xml | sed "s/.*/$blu&$wht/"

srun -N 1 -n ${n} -r 1 \
    ADIOSAnalysisEndPoint -r flexpath \
    -f ./configs/random_2d_${b}_catalyst.xml \
    random_2d_${b}.bp  2>&1 | sed "s/.*/$grn&$wht/"
