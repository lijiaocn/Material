#!/bin/bash
CLI=/export/App/redis-3.0.2/bin/redis-cli
SERVER=/export/App/redis-3.0.2/bin/redis-server
CONFIG=/export/App/redis-3.0.2/redis.conf
VIP=

PORT=6000

func_alive(){
	ALIVE=`$CLI -h 127.0.0.1 -p $PORT PING`
	if [ "$ALIVE" == "PONG" ];then
		return 0
	fi
	return 1
}

func_start(){
	$SERVER $CONFIG &
}

func_as_master(){
	$CLI -h 127.0.0.1 -p $PORT slaveof on one
}

func_as_slave(){
	$CLI -h 127.0.0.1 -p $PORT slaveof $VIP $PORT
}
