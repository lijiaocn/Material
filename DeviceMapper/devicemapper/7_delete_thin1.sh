#!/bin/bash

. ./0_config.sh

#if [[ ! $# -eq 1 ]];then
#    echo "usage: $0 snapid"
#    exit
#fi
#
#snapid=$1

#set -x
#dmsetup message /dev/mapper/${poolName} ${thin1ID} "create_snap ${snapid} ${thin1ID}" 
#dmsetup create ${snapid} --table "0 $((${thin1Size}/256)) thin /dev/mapper/${poolName} ${snapid}"
#set +x
#
#if [[ ! -d "${mountDir}/${snapid}" ]];then
#    mkdir -p "${mountDir}/${snapid}"
#fi
#mount /dev/mapper/${snapid} "${mountDir}/${snapid}"

echo "##### Start delete ${thin1}"
read

while true
do
    umount ${thin1}
    dmsetup remove ${thin1}
    dmsetup message "/dev/mapper/${poolName}" ${thin1ID} "delete ${thin1ID}"
    if [[ $? ]];then
        exit
    fi
done
