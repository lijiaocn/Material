#!/bin/bash
. /export/Shell/keepalived/config.sh

date=`date`
echo "$date: My service is fault">>/export/Logs/keepalived/log

func_sms "Fault" "Redis service dead"
