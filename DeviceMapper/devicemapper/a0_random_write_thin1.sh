#!/bin/bash
. ./0_config.sh

while true
do
    t=$(($RANDOM%10+5))
    n=$(($RANDOM%60))
    c=$(($RANDOM%5))
    dd if=/dev/sda of="${thin1}/$n" bs=10M count=${c}
    n=$(($RANDOM%30))
    rm -rf "${thin1}/$n"
    echo "sleep $t"
    sleep $t
done
