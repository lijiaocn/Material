#!/bin/bash

CONFIG=/etc/keepalived/keepalived.conf

/bin/rm -f $CONFIG
ln -s /export/App/keepalived/keepalived.master.conf  ${CONFIG}

LOGDIR=/export/Logs/keepalived
if [ ! -d ${LOGDIR} ];then
	mkdir -p $LOGDIR
fi

service keepalived start
