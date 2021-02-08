#!/bin/bash

# prereq: kmax installation, make.cross, >python3.8, >libisl.so.22 in ldpath (if needed by make.cross)

#
# Experiment prep
#
set -x

which kismet
if [[ $? -neq 0 ]]; then
  echo "couldn't find kismet"
  exit -1
fi

which python3
if [[ $? -neq 0 ]]; then
  echo "couldn't find cross python3"
  exit -1
fi

which make.cross
if [[ $? -neq 0 ]]; then
  echo "couldn't find cross compilation script \"make.cross\""
  exit -1
fi

buildtest_script=$(dirname $0)
buildtest_script="${buildtest_script}/buildtest.py"
if [ ! -f "$buildtest_script" ]; then
    echo "couldn't find build test script \"$buildtest_script\"."
fi

# get linux 5.4.4 source
echo "pulling the linux source.."
mkdir -p ~/kismet-experiments/
cd ~/kismet-experiments
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.4.tar.xz
tar -xvf linux-5.4.4.tar.xz

echo "starting the experiments.."
date

#
# Kismet: static analysis for unmet direct dependency bugs
#
# todo: um32 is not supported by kextract, add it once resolved
ARCHS=("x86_64" "i386" "arm" "arm64" "sparc64" "sparc" "powerpc" "mips" "alpha" "arc" "c6x" "csky" "h8300" "hexagon" "ia64" "m68k" "microblaze" "nds32" "nios2" "openrisc" "parisc" "riscv" "s390" "sh" "sh64" "um" "unicore32"  "xtensa")

for arch in ${ARCHS[@]}; do
  echo "running kismet on ${arch}"
  date
  /usr/bin/time -o kismet_time_${arch}.txt kismet --linux-ksrc="linux-5.4.4/" -a=${arch} --test-cases-dir="test_cases_${arch}/" --summary-csv="kismet_summary_${arch}.csv" > kismet_log_${arch}.txt 2>&1
  echo "kismet done running on ${arch}"
  date
done

#
# Build test: running build test on testcases
#
for arch in ${ARCHS[@]}; do
  echo "running build test on ${arch}"
  date
  /usr/bin/time -o buildtest_time_${arch}.txt python3 ${buildtest_script} --linux-ksrc="linux-5.4.4/" -k="kismet_summary_${arch}.csv" --make-path="make.cross" > buildtest_log_${arch}.txt 2>&1
  echo "build test done running on ${arch}"
  date
done

echo "done running the experiments."
date