#!/bin/bash

TAP="tap0"
BRIDGE="br0"
PHYINTER="enp0s8"   #Bridge rely on this phy interface

BRIDGE_EXTER_IP="192.168.187.102"
BRIDGE_EXTER_IP_MASK="24"

BRIDGE_INTER_IP="172.10.10.1"
BRIDGE_INTER_IP_MASK="24"

TAP_EXTER_IP="192.168.187.6"
TAP_EXTER_IP_MASK="24"

TAP_INTER_IP="172.10.10.2"
TAP_INTER_IP_MASK="24"

####################################################################
#                         Check                                    #
####################################################################

if [ $# -ne 1 ];then
    echo "Usage: $0 command"
    echo "    command: start| stop"
    exit 0
fi

####################################################################
#                    Deal process                                  #
####################################################################

BRIDGE_EXTER_IP_FINAL="${BRIDGE_EXTER_IP}/${BRIDGE_EXTER_IP_MASK}"
BRIDGE_INTER_IP_FINAL="${BRIDGE_INTER_IP}/${BRIDGE_INTER_IP_MASK}"
TAP_EXTER_IP_FINAL="${TAP_EXTER_IP}/${TAP_EXTER_IP_MASK}"
TAP_INTER_IP_FINAL="${TAP_INTER_IP}/${TAP_INTER_IP_MASK}"

cleanup(){
    ip link set $BRIDGE down
    brctl delbr $BRIDGE
    ip addr add $BRIDGE_EXTER_IP_FINAL  dev $PHYINTER 
    iptables -t nat -D PREROUTING -d $TAP_EXTER_IP_FINAL -j DNAT --to-destination $TAP_INTER_IP
    iptables -t nat -D POSTROUTING -s $TAP_INTER_IP_FINAL  -o br0 -j SNAT --to-source $TAP_EXTER_IP
}

start(){
    systemctl restart iptables
    # Create bridge
    brctl addbr $BRIDGE
    brctl addif $BRIDGE $PHYINTER
    brctl stp $BRIDGE on
    ip link set $BRIDGE up
    ## Set IP
    ip addr add $BRIDGE_EXTER_IP_FINAL  dev $BRIDGE
    ip addr add $BRIDGE_INTER_IP_FINAL dev $BRIDGE
    ip addr add $TAP_EXTER_IP_FINAL  dev $BRIDGE  
        ## Be Careful, tap external ip is set on BRIDGE
    ifconfig $PHYINTER 0 up ## Now can cancel the phy's ip

    # Set tap
    ip addr add  $TAP_INTER_IP_FINAL dev $TAP
        ## Be Careful, Just set Internal IP
    ip link set $TAP up
    ## Plug tap into bridge
    brctl addif $BRIDGE $TAP

    # Set Forward Rules
    iptables -t nat -A PREROUTING -d $TAP_EXTER_IP/32 -j DNAT --to-destination $TAP_INTER_IP
    iptables -t nat -A POSTROUTING -s $TAP_INTER_IP/32  -o ${BRIDGE} -j SNAT --to-source $TAP_EXTER_IP
}

case $1 in
    stop)
        cleanup &
        ;;
    start)
        havetap=`ifconfig -a|grep ${TAP}`
        if [ -z "$havetap" ];then
            echo "You must Create ${TAP} First!"
            exit 0
        fi
        start &
        ;;
esac
