#!/bin/bash

. ../../../LinuxShell/library.sh

dev="em1"
class1_rate="1000mbit      "
class1_ceil="1000mbit      "
class10_rate="495mbit      "
class10_ceil="1000mbit     "
class20_rate="495mbit      "
class20_ceil="1000mbit     "
class90_rate="10mbit      "
class90_ceil="10mbit      "

cmdAddRoot1_0="tc qdisc add dev $dev root handle 1:0 htb default 90 r2q 10000"
cmdAddClass1_1="tc class add dev $dev parent 1:0 classid 1:1 htb rate $class1_rate ceil $class1_ceil  burst 100M cburst 100M"
cmdAddClass1_10="tc class add dev $dev parent 1:1 classid 1:10 htb rate $class10_rate ceil $class10_ceil burst 100M cburst 100M quantum 300000"
cmdAddClass1_20="tc class add dev $dev parent 1:1 classid 1:20 htb rate $class20_rate ceil $class20_ceil burst 100M cburst 100M quantum 300000"
cmdAddClass1_90="tc class add dev $dev parent 1:1 classid 1:90 htb rate $class90_rate ceil $class90_ceil burst 100M cburst 100M quantum 150000"

cmdAddLeaf10_0="tc qdisc add dev $dev parent 1:10 handle 10:0 sfq"
cmdAddLeaf20_0="tc qdisc add dev $dev parent 1:20 handle 20:0 sfq"

cmdAddRootFilter1="tc filter add dev $dev parent 1:0 protocol ip u32 match ip sport 61440 0xf000 flowid 1:10"
cmdAddRootFilter2="tc filter add dev $dev parent 1:0 protocol ip u32 match ip sport 57344 0xf000 flowid 1:20"

cmdDel="tc qdisc delete dev $dev root handle 1:0 htb"

echo "Input Any Key to Add htb on $dev:"
func_green_str "                       $dev"
func_green_str "                       root 1:0"
func_green_str "                       class 1:1"
func_green_str "                        htb       "
func_green_str "                   ____1000Mbit____             "
func_green_str "            ______/       |       \_______     "
func_green_str "        ___/              |               \____"
func_green_str "    class 1:10          class 1:20          class 1:90"
func_green_str "      dport:            dport:             default               "
func_green_str "    [0xF000,0xFFFF]   [0xE000,0xEFFF]"
func_green_str "    [61440,  65535]   [57344,  61439]"
func_green_str "     prio 1             prio 2             prio 9"
func_green_str "    $class10_rate      $class20_rate       $class90_rate"
func_green_str "    $class10_ceil      $class20_ceil       $class90_ceil"
func_green_str "       |                  |                    |"
func_green_str "      sfq                sfq               pfifo "
func_green_str "     10:0                20:0             default"

func_green_str "$cmdAddRoot1_0"
func_green_str "$cmdAddClass1_1"
func_green_str "$cmdAddClass1_10"
func_green_str "$cmdAddLeaf10_0"
func_green_str "$cmdAddClass1_20"
func_green_str "$cmdAddClass1_90"
func_green_str "$cmdAddRootFilter1"
func_green_str "$cmdAddRootFilter2"

read

echo "Before:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"

func_error_cmd "$cmdAddRoot1_0"
func_error_cmd "$cmdAddClass1_1"
func_error_cmd "$cmdAddClass1_10"
func_error_cmd "$cmdAddLeaf10_0"
func_error_cmd "$cmdAddClass1_20"
func_error_cmd "$cmdAddClass1_90"
func_error_cmd "$cmdAddRootFilter1"
func_error_cmd "$cmdAddRootFilter2"
echo ""
echo "After:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"

echo "Enter a bash?[Y|N]"
read subbash
if [[ $subbash == "Y" || $subbash == "y" ]];then
	func_yellow_cmd "/bin/sh"
fi

echo "Input Any Key to Delete htb on $dev"
func_green_str "    $cmdDel"
read

func_error_cmd `$cmdDel`

echo "Deleted:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"
