#!/bin/bash

. ./0_config.sh

for i in `ls mount`
do
    umount "${mountDir}/${i}"
    dmsetup remove ${i}
    dmsetup message "/dev/mapper/${poolName}" 1 "delete ${i}"
    if [[ $? ]];then
        rm -rf "${mountDir}/${i}"
    fi
done
