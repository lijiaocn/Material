#!/bin/bash

. ./0_config.sh

while true
do
    dd if=/dev/sda of="${thin1}/dat" bs=10M count=1000
done
