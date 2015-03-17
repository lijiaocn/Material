#!/bin/bash

while true
do
    ./4_remove_all_snap.sh
    t=$(($RANDOM%60+10))
    echo "Sleep $t"
    sleep $t
done
