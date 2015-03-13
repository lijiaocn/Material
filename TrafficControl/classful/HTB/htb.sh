#!/bin/bash

. ../../../../LinuxShell/library.sh

#                       enp0s8
#                       root 1:0
#                        htb       
#                   ____100Mbit____             
#            ______/       |       \_______     
#        ___/              |               \____
#    class 1:1          class 1:2          class 1:9
#     dport:            dport:             default               
#  [0xF000,0xFFFF]   [0xE000,0xEFFF]
#  [61440,  65535]   [57344,  61439]
#     prio 1             prio 2             prio 9
#     30Mbit            30Mbit              10Mbit
#    Max 70Mbit        Max 90Mbit        Max 100Mbit
#       |                  |                    |
#      sfq               pfifo                pfifo 
#     10:0              default              default


dev="enp0s8"

cmdAddRoot1_1="tc qdisc add dev $dev root handle 1:0 htb default 10 r2q 6000"
cmdAddClass1_1="tc class add dev $dev parent 1:0 classid 1:1 htb prio 1 rate 30Mbit ceil 80Mbit"
cmdAddLeaf10_0="tc qdisc add dev $dev parent 1:1 handle 10:0 sfq"
cmdAddClass1_2="tc class add dev $dev parent 1:0 classid 1:2 htb prio 2 rate 30Mbit ceil 90Mbit "
cmdAddClass1_9="tc class add dev $dev parent 1:0 classid 1:9 htb prio 9 rate 30Mbit ceil 100Mbit "
cmdAddRootFilter1="tc filter add dev $dev parent 1:0 protocol ip prio 4 basic match u32(u16 0xF000 0xF000 at nexthdr+0) flowid 1:1"
cmdAddRootFilter2="tc filter add dev $dev parent 1:0 protocol ip prio 5 basic match u32(u16 0xE000 0xF000 at nexthdr+0) flowid 1:2"
cmdDel="tc qdisc delete dev $dev root handle 1:0 htb"

echo "Input Any Key to Add htb on $dev:"
func_green_str "                       enp0s8"
func_green_str "                       root 1:0"
func_green_str "                        htb       "
func_green_str "                   ____100Mbit____             "
func_green_str "            ______/       |       \_______     "
func_green_str "        ___/              |               \____"
func_green_str "    class 1:1          class 1:2          class 1:9"
func_green_str "      dport:            dport:             default               "
func_green_str "    [0xF000,0xFFFF]   [0xE000,0xEFFF]"
func_green_str "    [61440,  65535]   [57344,  61439]"
func_green_str "     prio 1             prio 2             prio 9"
func_green_str "     30Mbit            30Mbit              10Mbit"
func_green_str "    Max 100Mbit        Max 100Mbit        Max 100Mbit"
func_green_str "       |                  |                    |"
func_green_str "      sfq               pfifo                pfifo "
func_green_str "     10:0              default              default"

func_green_str "$cmdAddRoot1_1"
func_green_str "$cmdAddClass1_1"
func_green_str "$cmdAddLeaf10_0"
func_green_str "$cmdAddClass1_2"
func_green_str "$cmdAddClass1_9"
func_green_str "$cmdAddRootFilter1"
func_green_str "$cmdAddRootFilter2"

read

echo "Before:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"

func_error_cmd "$cmdAddRoot1_1"
func_error_cmd "$cmdAddClass1_1"
func_error_cmd "$cmdAddLeaf10_0"
func_error_cmd "$cmdAddClass1_2"
func_error_cmd "$cmdAddClass1_9"
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
