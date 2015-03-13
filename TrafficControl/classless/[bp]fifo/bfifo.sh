#/bin/bash

. ../../../LinuxShell/library.sh

dev="enp0s8"
cmdAdd="tc qdisc add dev $dev root handle 1:0  bfifo limit 100m"
cmdDel="tc qdisc delete dev $dev root handle 1:0 bfifo"

echo "Input Any Key to Add bfifo on $dev:"
func_green_str "    $cmdAdd"
read

echo "Before:"
func_red_cmd "tc qdisc show dev $dev"

`$cmdAdd`

echo ""
echo "After:"
func_red_cmd "tc qdisc show dev $dev"

echo ""
echo "Input Any Key to Delete bfifo on $dev"
func_green_str "    $cmdDel"
read

`$cmdDel`

echo "Deleted:"
func_red_cmd "tc qdisc show dev $dev"
