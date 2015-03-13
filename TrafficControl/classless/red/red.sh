#!/bin/bash

. ../../../../LinuxShell/library.sh

dev="enp0s8"
cmdAdd="tc qdisc add dev $dev root handle 1:0 red min 100000 max 300000 probability 0.02 limit 1200000 avpkt 1000 bandwidth 100Mbit ecn adaptive"
cmdDel="tc qdisc delete dev $dev root handle 1:0 red limit 120000 avpkt 1000"

echo "Input Any Key to Add red on $dev:"
func_green_str "    $cmdAdd"
read

echo "Before:"
func_red_cmd "tc qdisc show dev $dev"

`$cmdAdd`

echo ""
echo "After:"
func_red_cmd "tc qdisc show dev $dev"

echo ""
echo "Input Any Key to Delete red on $dev"
func_green_str "    $cmdDel"
read

`$cmdDel`

echo "Deleted:"
func_red_cmd "tc qdisc show dev $dev"
