#!/bin/bash

#VIP地址
VIP=192.168.192.161

#本机的IP地址
LOCALIP=

#alarm url
ALARM="http://172.17.57.241/simplealarm"

#Alarm Mail Receiver, sep is ","
MAIL=

#SMS phont number, sep is ","
PHONE=

#Redis端口地址，注意必须与$CONFIG文件中的端口一致
PORT=6000

#Redis的进程号记录文件，注意与$CONFIG中的配置一致
PIDFILE=/var/run/redis.keepalived.pid

#Redis配置文件
CONFIG=/export/App/redis-3.0.2/redis.conf

#Redis命令路径
CLI=/export/App/redis-3.0.2/bin/redis-cli
SERVER=/export/App/redis-3.0.2/bin/redis-server

#############################################################################
#
#               Functions
#
############################################################################
func_alive(){

##This method will have some problem
#	ALIVE=`$CLI -h 127.0.0.1 -p $PORT PING`
#	if [ "$ALIVE" == "PONG" ];then
#		return 0
#	fi
#	return 1

	if [ ! -e $PIDFILE ];then
		return 1
	fi
	pid=`cat $PIDFILE`
	ps -p $pid 1>/dev/null 2>&1
	if [ $? -eq 0 ];then
		return 0
	fi
	return 1
}

func_start(){
	$SERVER $CONFIG  &
}

func_as_master(){
	$CLI -h 127.0.0.1 -p $PORT slaveof no one
}

func_as_slave(){
	$CLI -h 127.0.0.1 -p $PORT slaveof $VIP $PORT
}

#$1: title
#$2: content
func_sms(){
	local dat="{\"title\":\"$LOCALIP:$1\",\"content\":\"$LOCALIP:$2\",\"mailTo\":\"${MAIL}\",\"smsTo\":\"${PHONE}\"}"
	curl -H "Content-Type: application/json" -d "$dat" $ALARM &
}
