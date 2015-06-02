#!/bin/bash
. ./public.sh
for DIR in docker flannel kuber8s portal
do
	cd ${DIR};bash ./install.sh; cd ..
done

systemctl daemon-reload

cp -f *.sh   $KUBER8S
