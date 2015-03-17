#!/bin/bash  
. ./0_config.sh

./4_remove_all_snap.sh

umount ${thin1}
dmsetup remove ${thin1}
dmsetup remove ${poolName}
losetup -d ${metaLoop}
losetup -d ${poolLoop}

rm ${metaFile}
rm ${poolFile}

./1_functions_test.sh
