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

func_as_slave

func_sms "New BACKUP" "Help! Please repair me! I'm not MASTER now"

date=`date`
echo "$date: became backup">>/export/Logs/keepalived/log
