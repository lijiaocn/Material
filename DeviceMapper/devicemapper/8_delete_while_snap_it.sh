. ./0_config.sh

delete_thin(){
    if [[ $2 -gt 0 ]];then
        kill -9 $2
    fi
    umount "${mountDir}/$1"
    dmsetup remove $1
    dmsetup message /dev/mapper/${poolName} ${thin1ID} "delete $1"
}

if [[ ! $# -eq 1 ]];then
    echo "usage: $0 snapnum"
    exit
fi

lastddPID=0
snapid=2
snapMax=$(($snapid+$1))

echo "##### Start snapshot ${thin1} any key continue..."
read

while [[ ! ${snapid} -eq ${snapMax} ]]
do
    if [[ ! -d "${mountDir}/${snapid}" ]];then
        mkdir -p "${mountDir}/${snapid}"
    fi
    set -x
        delete_thin  $(($snapid-1)) ${lastddPID} &
        dmsetup message /dev/mapper/${poolName} ${thin1ID} "create_snap ${snapid} $(($snapid-1))"
        dmsetup create ${snapid} --table "0 $((${thin1Size}/256)) thin /dev/mapper/${poolName} ${snapid}"
    set +x
        mount /dev/mapper/${snapid} "${mountDir}/${snapid}"
        dd if=/dev/sdb of="${mountDir}/${snapid}/dat" bs=40M count=2 1>/dev/null 2>&1 &
        lastddPID=$!
        snapid=$((${snapid}+1))
        sleep 2
done
rm "${thin1}/*.dat"
