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

echo "+ module load sensei/2.1.0-libsim-shared"
module load sensei/2.1.0-libsim-shared

set -x

cat ./configs/random_2d_${b}_adios.xml | sed "s/.*/$blu&$wht/"

srun -N 1 -n ${n} -r 0 -l \
    oscillator -b ${n} -t ${dt} -s ${b},${b},1  -p 0 -g 1 \
    -f ./configs/random_2d_${b}_adios.xml \
    ./configs/random_2d_${b}.osc 2>&1 | sed "s/.*/$red&$wht/" &

set +x

echo "Waiting for writer to start ${delay} sec"
while [[ True ]]
do
  echo -n '.'
  if [[ -e "${file}_writer_info.txt" ]]
  then
    break
  elif [[ ${max_delay} -le 0 ]]
  then
    echo "ERROR: max delay exceded"
    exit -1
  else
    sleep ${delay}s
    let max_delay=${max_delay}-${delay}
  fi
done

set -x

cat ./configs/random_2d_${b}_libsim_it.xml | sed "s/.*/$blu&$wht/"

srun -N 1 -n ${n} -r 1 \
     ADIOSAnalysisEndPoint -r flexpath \
    -f ./configs/random_2d_${b}_libsim_it.xml \
    random_2d_${b}.bp  2>&1 | sed "s/.*/$grn&$wht/"
