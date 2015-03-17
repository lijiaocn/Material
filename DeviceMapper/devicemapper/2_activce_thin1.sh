#!/bin/bash

. ./0_config.sh

losetup ${metaLoop} ${metaFile}
losetup ${poolLoop} ${poolFile}

echo "##### Create ${poolName}, any key continue..."
read 
set -x
dmsetup create ${poolName} --table "0 $((${poolSize}/512)) thin-pool ${metaLoop} ${poolLoop} 128 32768 1 skip_block_zeroing"
set +x

echo "##### Create ${thin1}, any key continue..."
read 

echo "##### Active ${thin1}, any key continue..."
read 
#active
set -x
dmsetup create ${thin1} --table "0 $((${thin1Size}/256)) thin /dev/mapper/${poolName} ${thin1ID}"
set +x

echo "##### Mount ${thin1}, any key continue..."
read
set -x
mount /dev/mapper/${thin1} `pwd`/thin1
set +x
