#!/bin/bash
. ./library.sh

systemctl daemon-reload
for SERVICE in jd-flannel jd-kube-apiserver jd-kube-controller-manager jd-kube-scheduler jd-portal; do
	func_stop_sd_service $SERVICE
done
