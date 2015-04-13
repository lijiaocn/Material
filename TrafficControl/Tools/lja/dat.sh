#!/bin/bash

rm /tmp/1k.dat
rm /tmp/1m.dat
rm /tmp/10m.dat
rm /tmp/100m.dat
i=0
size=$((2**10))
while [[ ! i -eq $size ]]
do
    echo -n  "a" >>/tmp/1k.dat
    i=$((i+1))
done

i=0
size=$((2**20))
while [[ ! i -eq  $size ]]
do
    echo -n  "b" >>/tmp/1m.dat
    i=$((i+1))
done

i=0
size=$((2**20))
while [[ ! i -eq $size  ]]
do
    echo -n  "cccccccccc" >>/tmp/10m.dat
    i=$((i+1))
done

i=0
size=$((10))
while [[ ! i -eq $size  ]]
do
    cat /tmp/10m.dat >>/tmp/100m.dat
    i=$((i+1))
done
