#!/bin/bash
. /export/Shell/keepalived/config.sh

ret=`func_alive`

## Redis server is not running
if [ $ret -eq 1 ];then
	func_start
	sleep 3
fi

func_as_master

echo "to master">/export/Logs/keepalived/tomaster
