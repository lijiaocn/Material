#!/bin/bash

#Get the net interfaces's name
func_nic_names(){
	local names=`ip addr |grep \<.*\>|awk '{print $2}'|sed -e "s/://"`
	echo $names
}

#$1: message
func_fatal(){
	echo  -n -e "\e[31m"
	echo "Fatal Error: $1"
	echo  -n -e "\e[0m"
	exit
}

#Input is a string.
#The string  will be displayed with red color
func_red_str(){
	echo  -n -e "\e[31m"
	echo  -e "$*"
	echo  -n -e "\e[0m"
}

#Input is the command.
#The command's execute output will use red color
func_red_cmd(){
	echo  -n -e "\e[31m"
	$*
	echo  -n -e "\e[0m"
}

#Input is the command
#If command is error, display the error
func_error_cmd(){
	$*
	local ret=$?
	if [ ! $ret -eq 0 ];then
		echo  -n -e "\e[41;37m"
		echo "Error: [$ret] $*"
		echo  -n -e "\e[0m"
	fi
}

#$1: net interface name 
tc_set_policy(){
	if [[ ! $# -eq 1 ]];then
		func_fatal "don't know which device should be set!"
	fi

	# system port  -- [1,1023] 10mbit~10mbit class1:10
	# user port    -- [1024,0x7FFF] 495mbit~1000mbit class1:20
	# manager port -- [0x8000,0xFFFF] 495mbit~1000mbit class1:30

	# 1. a system port add value "0x8000" will locate the user port pool 
	# 2. a manage port add value "0x8000" will locate in the user port pool 
	# 3. a user port sub value "0x8000" can locate in the system port pool or manage port pool

	# Test Case:
	# 1. only system traffic:  it shouldn't exceed 10mbit/s
	# 2. only manage traffic:  it can burst to 1000mbit/s
	# 3. only user traffic:    it can burst to 1000mbit/s
	# 4. just system traffic and manage traffic: 
	#       the manage traffic can burst to (1000mbit/s - system traffic rate) , 
	# 5. just system traffic and user traffic: 
	#       the user traffic can burst to (1000mbit/s - system traffic rate) , 
	# 6. just manage traffic and user traffic:
	#       manage traffic can burst to (495 + (495 - user traffic rate) + 5 + (user traffic < 495 ? 5 : 0) mbit/s
	#       user traffic can burst to (495 + (495 - manage traffic rate) + 5 + (mange traffic < 495 ? 5 : 0)mbit/s
	# 7. system,manage and user traffic:
	#       system traffic can burst to 10mbits/s
	#       manage traffic can burst to (495 + (495 - user traffic rate) + (10 - system traffic)/2 + (user traffic < 495 ? (10 - system traffic)/2 : 0) mbit/s
	#       user traffic can burst to (495 + (495 - manage traffic rate) + (10 - system traffic)/2 + (manage traffic < 495 ? (10 - system traffic)/2 : 0) mbit/s
	# 8. in all the case:
	#       if the system traffic is produced more than 10mbit/s, it will always get a 10mbit/s bandwidth

	local dev=$1
	local class1_rate="1000mbit"
	local class1_ceil="1000mbit"
	local class10_rate="10mbit"
	local class10_ceil="10mbit"
	local class20_rate="495mbit"
	local class20_ceil="1000mbit"
	local class30_rate="495mbit"
	local class30_ceil="1000mbit"

	local cmdAddRoot1_0="tc qdisc add dev $dev root handle 1:0 htb default 20 r2q 10000"
	local cmdAddClass1_1="tc class add dev $dev parent 1:0 classid 1:1 htb rate $class1_rate ceil $class1_ceil  burst 100M cburst 100M"
	local cmdAddClass1_10="tc class add dev $dev parent 1:1 classid 1:10 htb rate $class10_rate ceil $class10_ceil burst 100M cburst 100M quantum 150000"
	local cmdAddClass1_20="tc class add dev $dev parent 1:1 classid 1:20 htb rate $class20_rate ceil $class20_ceil burst 100M cburst 100M quantum 300000"
	local cmdAddClass1_30="tc class add dev $dev parent 1:1 classid 1:30 htb rate $class30_rate ceil $class30_ceil burst 100M cburst 100M quantum 300000"
	local cmdAddLeaf20_0="tc qdisc add dev $dev parent 1:20 handle 20:0 sfq headdrop"
	local cmdAddLeaf30_0="tc qdisc add dev $dev parent 1:30 handle 30:0 sfq headdrop"
	local cmdAddRootFilter10="tc filter add dev $dev parent 1:0 protocol ip basic match cmp (u16 at 0 layer transport lt 1024) flowid 1:10"      #<1024
	local cmdAddRootFilter30_1="tc filter add dev $dev parent 1:0 protocol ip basic match cmp (u16 at 0 layer transport eq 0x8000) flowid 1:30"  #=0x8000
	local cmdAddRootFilter30_2="tc filter add dev $dev parent 1:0 protocol ip basic match cmp (u16 at 0 layer transport gt 0x8000) flowid 1:30"  #>0x8000

	func_error_cmd "$cmdAddRoot1_0"
	func_error_cmd "$cmdAddClass1_1"
	func_error_cmd "$cmdAddClass1_10"
	func_error_cmd "$cmdAddClass1_20"
	func_error_cmd "$cmdAddClass1_30"
	func_error_cmd "$cmdAddLeaf20_0"
	func_error_cmd "$cmdAddLeaf30_0"
	func_error_cmd "$cmdAddRootFilter10"
	func_error_cmd "$cmdAddRootFilter30_1"
	func_error_cmd "$cmdAddRootFilter30_2"
}

#$1: net interface name 
tc_unset_policy(){
	if [[ ! $# -eq 1 ]];then
		func_fatal "don't know which device should be unset!"
	fi

	local dev=$1
	local cmdDel="tc qdisc delete dev $dev root handle 1:0 htb"

	func_error_cmd `$cmdDel`
}

#$1: net interface name 
tc_show_policy(){
	if [[ ! $# -eq 1 ]];then
		func_fatal "don't know show which device!"
	fi

	func_red_cmd "tc qdisc show dev $1"
	func_red_cmd "tc class show dev $1"
	func_red_cmd "tc filter show dev $1"
}

start(){
	tc_set_policy $1
}

stop(){
	tc_unset_policy $1
}

status(){
	tc_show_policy $1
}

cmds(){
	local cmd=$1
	local nics=`func_nic_names`
	local nic=""
	local i=0
	for nic in $nics
	do
		if [[ ${nic:0:2} == "em" ]];then
			echo "Operate on $nic"
			$cmd "$nic"
			i=$((i+1))
		fi
	done

	if [[ $i -eq 0 ]];then
		func_red_str "No nic device is suitable (should named like: emX)"
	fi
}

case $1 in
	(start)
		cmds start;;
	(stop)
		cmds stop;;
	(status)
		cmds status;;
	(version)
		echo "2015-03-30 v0.3";;
	(*)
		echo "usage: $0 [stop|start|status]"
esac
