#!/bin/bash

n=4
b=64
dt=0.05

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

mkdir -p ./configs
cp ${script_dir}/configs/* ./configs

echo "+ module use /usr/common/software/sensei/modulefiles"
module use /usr/common/software/sensei/modulefiles

echo "+ module load sensei/2.1.0-libsim-shared"
module load sensei/2.1.0-libsim-shared

set -x

cat ./configs/random_2d_${b}_libsim.xml

srun -n ${n} \
    oscillator -b ${n} -t ${dt} -s ${b},${b},1 -g 1 -p 0 \
    -f ./configs/random_2d_${b}_libsim.xml \
    ./configs/random_2d_${b}.osc
