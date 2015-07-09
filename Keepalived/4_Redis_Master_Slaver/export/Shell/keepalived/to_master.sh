#!/bin/bash
. /export/Shell/keepalived/config.sh

ret=`func_alive`
func_alive
ret=$?

## Redis server is not running
if [ $ret -eq 1 ];then
	func_start
	sleep 3
fi

func_as_master

func_sms "New MASTER" "MASTER's redis service is lost, I'm the new MASTER"

date=`date`
echo "$date: became master">>/export/Logs/keepalived/log
