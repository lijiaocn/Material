#!/bin/bash

. ./library.sh

systemctl daemon-reload
for SERVICE in jd-flannel ; do 
	func_start_sd_service $SERVICE
	if [ $? != 0 ];then
		exit
	fi
	source /run/flannel/subnet.env
	echo "FLANNEL_DOCKER_NETWORK_OPTIONS=\"--bip=$FLANNEL_SUBNET --mtu=$FLANNEL_MTU\"" >>/run/flannel/subnet.env
done

for SERVICE in jd-kube-proxy jd-kubelet jd-docker; do 
	func_start_sd_service $SERVICE
	if [ $? != 0 ];then
		exit
	fi
done
