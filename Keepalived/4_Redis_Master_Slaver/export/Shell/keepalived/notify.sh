#!/bin/bash
. /export/Shell/keepalived/config.sh

str="$date: $1 $2 $3"
echo "$str">>/export/Logs/keepalived/log

func_sms "Notify" "$str"
