#!/bin/bash
. /export/Shell/keepalived/config.sh

ret=`func_alive`

## Redis server is not running
if [ $ret -eq 1 ];then
	func_start
	sleep 3
fi

func_as_slave

echo "to backup">/export/Logs/keepalived/tobackup
