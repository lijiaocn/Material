. ./0_config.sh

if [[ ! $# -eq 1 ]];then
    echo "usage: $0 snapnum"
    exit
fi

snapid=2
snapMax=$(($snapid+$1))

echo "##### Start snapshot ${thin1} any key continue..."
read

trap "killSubPid ${subPIDs}" SIGABRT SIGKILL SIGQUIT

while [[ ! ${snapid} -eq ${snapMax} ]]
do
    #thin1Exist=`df |grep thin1`
    #if [[ ${snapid} -lt 30 && -n ${thin1Exist} ]];then
        #dd if=/dev/sda  of="${thin1}/${snapid}.dat" bs=40M count=10  1>/dev/null 2>&1 &
    #fi
    set -x
        dmsetup message /dev/mapper/${poolName} ${thin1ID} "create_snap ${snapid} ${thin1ID}"
        dmsetup create ${snapid} --table "0 $((${thin1Size}/256)) thin /dev/mapper/${poolName} ${snapid}"
    set +x
        if [[ ! -d "${mountDir}/${snapid}" ]];then
            mkdir -p "${mountDir}/${snapid}"
        fi
        mount /dev/mapper/${snapid} "${mountDir}/${snapid}"
        if [[ $? ]];then
            dd if=/dev/sdb of="${mountDir}/${snapid}/dat" bs=50M count=2 1>/dev/null 2>&1 &
        fi
        snapid=$((${snapid}+1))
done
rm "${thin1}/*.dat"
