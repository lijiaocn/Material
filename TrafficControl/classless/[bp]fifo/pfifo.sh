#/bin/bash

. ../../../LinuxShell/library.sh

dev="enp0s8"
cmdAdd="tc qdisc add dev $dev root handle 1:0  pfifo limit 1000"
cmdDel="tc qdisc delete dev $dev root handle 1:0 pfifo"

echo "Input Any Key to Add pfifo on $dev:"
func_green_str "    $cmdAdd"
read

echo "Before:"
func_red_cmd "tc qdisc show dev $dev"

`$cmdAdd`

echo ""
echo "After:"
func_red_cmd "tc qdisc show dev $dev"

echo ""
echo "Input Any Key to Delete pfifo on $dev"
func_green_str "    $cmdDel"
read

`$cmdDel`

echo "Deleted:"
func_red_cmd "tc qdisc show dev $dev"
