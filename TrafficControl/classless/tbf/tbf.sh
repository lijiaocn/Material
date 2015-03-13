#!/bin/bash

. ../../../../LinuxShell/library.sh

dev="enp0s8"
cmdAdd="tc qdisc add dev $dev root handle 1:0 tbf rate 10mbit limit 256 burst 10k mpu 0"
cmdDel="tc qdisc delete dev $dev root handle 1:0 tbf rate 10mbit limit 256 burst 10k" 

echo "Input Any Key to Add tbf on $dev:"
func_green_str "    $cmdAdd"
read

echo "Before:"
func_red_cmd "tc qdisc show dev $dev"

`$cmdAdd`

echo ""
echo "After:"
func_red_cmd "tc qdisc show dev $dev"

echo ""
echo "Input Any Key to Delete tbf on $dev"
func_green_str "    $cmdDel"
read

`$cmdDel`

echo "Deleted:"
func_red_cmd "tc qdisc show dev $dev"
