#!/bin/bash

n=4
b=64

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

mkdir -p ./configs
cp ${script_dir}/configs/* ./configs

bld=`echo -e '\e[1m'`
red=`echo -e '\e[31m'`
grn=`echo -e '\e[32m'`
wht=`echo -e '\e[0m'`

echo "+ module use /usr/common/software/sensei/modulefiles"
module use /usr/common/software/sensei/modulefiles

echo "+ module load sensei/2.1.0-catalyst-shared"
module load sensei/2.1.0-catalyst-shared

set -x

cat ./configs/random_2d_${b}_catalyst.xml

srun -N 1 -n ${n} -r 1 \
    ADIOSAnalysisEndPoint -r flexpath \
    -f ./configs/random_2d_${b}_catalyst.xml \
    random_2d_${b}.bp  2>&1 | sed "s/.*/$bld$grn&$wht/"
