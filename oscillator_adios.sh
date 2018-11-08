#!/bin/bash

n=4
b=64
dt=0.1

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

mkdir -p ./configs
cp ${script_dir}/configs/* ./configs

bld=`echo -e '\e[1m'`
red=`echo -e '\e[31m'`
grn=`echo -e '\e[32m'`
wht=`echo -e '\e[0m'`

echo "+ module use /usr/common/software/sensei/modulefiles"
module use /usr/common/software/sensei/modulefiles

echo "+ module load sensei/2.1.0-vtk-shared"
module load sensei/2.1.0-vtk-shared

set -x

cat ./configs/random_2d_${b}_adios.xml

srun -N 1 -n ${n} -r 0 -l \
    oscillator -b ${n} -t ${dt} -s ${b},${b},1  -p 0 -g 1 \
    -f ./configs/random_2d_${b}_adios.xml \
    ./configs/random_2d_${b}.osc 2>&1 | sed "s/.*/$bld$red&$wht/" &

