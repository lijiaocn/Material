#!/bin/bash

. ./library.sh

systemctl daemon-reload
for SERVICE in jd-flannel jd-kube-proxy jd-kubelet jd-docker; do 
	func_stop_sd_service $SERVICE
done

ip link set docker0 down
brctl delbr docker0
