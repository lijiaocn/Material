#!/bin/bash

. ../../../../LinuxShell/library.sh

#                    enp0s8 100Mbit
#                      root 1:0
#                  ____  cbq  _____     
#             ____/                \____
#          class 1:1                class 1:2
#           20Mbit                    80Mbit
#           prio 6                   prio 0-5
#              |                         |
#              |                         |
#           sfq 10:0              __cbq 11:0__    
#                               _/            \_  
#                             _/                \_
#                          class 11:1        class 11:2
#                             50Mbit           30Mbit
#                          prio 0-2          prio 3-5
#                              |                 |
#                              |                 | 
#                           sfq 20:0          sfq 21:0
#

dev="enp0s8"
cmdAddRoot1_0="tc qdisc add dev $dev root handle 1:0 cbq avpkt 1000 bandwidth 100Mbit cell 8"
cmdDel="tc qdisc delete dev $dev root handle 1:0 cbq bandwidth 100Mbit avpkt 1000" 

cmdAddClass1_1="tc class add dev $dev parent 1:0 classid 1:1 cbq \
    weight 1 allot 1514  prio 0 avpkt 1000 rate 20Mbit bandwidth 100Mbit\
    maxburst 100 minburst 20 minidle 100 split 1:0 defmap 40" 
cmdAddClass1_2="tc class add dev $dev parent 1:0 classid 1:2 cbq \
    weight 1 allot 1514  prio 0 avpkt 1000 rate 80Mbit bandwidth 100Mbit\
    maxburst 100 minburst 20 minidle 100 split 1:0 defmap 3f" 

cmdAddLeaf10_0="tc qdisc add dev $dev parent 1:1 handle 10:0 sfq"
cmdAddNode11_0="tc qdisc add dev $dev parent 1:2 handle 11:0 cbq avpkt 1000 bandwidth 80Mbit"

cmdAddClass11_1="tc class add dev $dev parent 11:0 classid 11:1 cbq\
    weight 1 allot 1514  prio 0 avpkt 1000 rate 50Mbit bandwidth 80Mbit\
    maxburst 100 minburst 20 minidle 100 split 1:0 defmap 7" 
cmdAddClass11_2="tc class add dev $dev parent 11:0 classid 11:2 cbq\
    weight 1 allot 1514  prio 0 avpkt 1000 rate 30Mbit bandwidth 80Mbit\
    maxburst 100 minburst 20 minidle 100 split 1:0 defmap 38" 

cmdAddLeaf20_0="tc qdisc add dev $dev parent 11:1 handle 20:0 sfq"
cmdAddLeaf21_0="tc qdisc add dev $dev parent 11:2 handle 21:0 sfq"


echo "Input Any Key to Add prio on $dev:"
func_green_str "                    enp0s8 100Mbit"
func_green_str "                      root 1:0"
func_green_str "                  ____  cbq  _____     "
func_green_str "             ____/                \____"
func_green_str "          class 1:1                class 1:2"
func_green_str "           20Mbit                    80Mbit"
func_green_str "           prio 6                   prio 0-5"
func_green_str "              |                         |"
func_green_str "              |                         |"
func_green_str "           sfq 10:0              __cbq 11:0__    "
func_green_str "                               _/            \_  "
func_green_str "                             _/                \_"
func_green_str "                          class 11:1        class 11:2"
func_green_str "                             50Mbit           30Mbit"
func_green_str "                          prio 0-2          prio 3-5"
func_green_str "                              |                 |"
func_green_str "                              |                 | "
func_green_str "                           sfq 20:0          sfq 21:0"
read

echo "Before:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"

func_error_cmd "$cmdAddRoot1_0"
func_error_cmd "$cmdAddClass1_1"
func_error_cmd "$cmdAddLeaf10_0"
func_error_cmd "$cmdAddClass1_2"
func_error_cmd "$cmdAddNode11_0"
func_error_cmd "$cmdAddClass11_1"
func_error_cmd "$cmdAddLeaf20_0"
func_error_cmd "$cmdAddClass11_2"
func_error_cmd "$cmdAddLeaf21_0"

echo ""
echo "After:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"

echo ""
echo "Input Any Key to Delete prio on $dev"
func_green_str "    $cmdDel"
read

func_error_cmd `$cmdDel`

echo "Deleted:"
func_red_cmd "tc qdisc show dev $dev"
func_red_cmd "tc class show dev $dev"
func_red_cmd "tc filter show dev $dev"
