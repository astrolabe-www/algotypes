#!/bin/bash

if [ -z "$1" ]
then
  echo "specify which type of output [SCREEN | PRINT | TELEGRAM] [BLEED]"
  exit
fi

if [ ! -d "cards" ]
then
  mkdir -p cards
fi

for ALGO in $(find . -mindepth 2 -maxdepth 2 -type d -name "p5_0x*" | sort)
do
  echo $ALGO
  pushd $ALGO
  processing-java --sketch=$PWD --run $1 $2
  mv *png ../../cards/
  popd
done
