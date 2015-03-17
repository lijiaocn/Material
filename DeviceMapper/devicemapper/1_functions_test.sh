#!/bin/bash
set +x

. ./0_config.sh

#usage: 
# CreateMetaDat filename
CreateMetaDat(){
    if [[ ! $# -eq 1 ]];then
        echo "MetaDat not set"
        exit
    fi
    dd if=/dev/zero of=$1 bs=4096 count=1
    dd if=/dev/zero of=$1 bs=1M seek=2048 count=0
}

#usage: 
# CreatePoolDat filename
CreatePoolDat(){
    if [[ ! $# -eq 1 ]];then
        echo "PollDat not set"
        exit
    fi
    dd if=/dev/zero of=$1 bs=1G seek=100 count=0
}

main(){
    CreateMetaDat "${metaFile}"
    CreatePoolDat "${poolFile}"

    losetup ${metaLoop} ${metaFile}
    losetup ${poolLoop} ${poolFile}

    echo "##### Create ${poolName}, any key continue..."
    read 
    set -x
    dmsetup create ${poolName} --table "0 $((${poolSize}/512)) thin-pool ${metaLoop} ${poolLoop} 128 32768 1 skip_block_zeroing"
    set +x

    echo "##### Create ${thin1}, any key continue..."
    read 
    #create
    set -x
    dmsetup message /dev/mapper/${poolName} ${thin1ID} "create_thin ${thin1ID}"
    set +x

    echo "##### Active ${thin1}, any key continue..."
    read 
    #active
    set -x
    dmsetup create ${thin1} --table "0 $((${thin1Size}/256)) thin /dev/mapper/${poolName} ${thin1ID}"
    set +x

    echo "##### Format ${thin1}, any key continue..."
    read
    set -x
    mkfs.ext4 /dev/mapper/${thin1}
    set +x

    echo "##### Mount ${thin1}, any key continue..."
    read
    set -x
    mount /dev/mapper/${thin1} `pwd`/thin1
    set +x

    echo "##### Snapshot ${thin1}, any key continue..."
    read
    set -x
    dmsetup message /dev/mapper/${poolName} ${thin1ID} "create_snap ${thin2ID} ${thin1ID}"
    set +x

    echo "##### Umount ${thin1}, any key continue..."
    read
    set -x
    umount /dev/mapper/${thin1}
    set +x

    echo "##### Remove ${thin1}, any key continue..."
    read
    set -x
    dmsetup remove ${thin1}
    set +x

    echo "##### Remove $poolName}, any key continue..."
    read
    set -x
    dmsetup remove ${poolName}
    losetup -d ${metaLoop}
    losetup -d ${poolLoop}
    set +x
}

main
