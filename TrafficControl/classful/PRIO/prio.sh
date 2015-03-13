#!/bin/bash

. ../../../../LinuxShell/library.sh

dev="enp0s8"
cmdAdd="tc qdisc add dev $dev root handle 1:0 prio bands 3"
cmdDel="tc qdisc delete dev $dev root handle 1:0 prio" 
cmdAttachBand1="tc qdisc add dev $dev parent 1:1 handle 10:0 sfq"
cmdAttachBand2="tc qdisc add dev $dev parent 1:2 handle 10:0 tbf"
cmdAttachBand3="tc qdisc add dev $dev parent 1:3 handle 10:0 sfq"

echo "Input Any Key to Add prio on $dev:"
func_green_str "    $cmdAdd"
func_green_str "         $cmdAttachBand1"
func_green_str "         $cmdAttachBand2"
func_green_str "         $cmdAttachBand3"
read

echo "Before:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"

`$cmdAdd`

echo ""
echo "After:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"

echo ""
echo "Input Any Key to Delete prio on $dev"
func_green_str "    $cmdDel"
read

`$cmdDel`

echo "Deleted:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"
