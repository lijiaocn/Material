#!/bin/bash
. ./library.sh
. /export/jd-kuber8s/etc/flannel.conf

func_yellow_str  "Deleting old Config ..."
ret=`curl ${ETCD}/v2/keys/${ETCD_PREFIX}?recursive=true -XDELETE 2>/dev/null`
func_red_str $ret

func_yellow_str  "Putting New Config ..."
value=`cat /export/jd-kuber8s/etc/flannel.json`
ret=`curl ${ETCD}/v2/keys/${ETCD_PREFIX}/config -XPUT -d value="$value" 2>/dev/null`
func_green_str $ret

