#Delete tap0
tunctl -d tap0

#Delete bridge
ifconfig br0 down
brctl delbr br0

#Delete Iptables Rule
iptables -t nat -D PREROUTING -d 192.168.187.6/32 -j DNAT --to-destination 172.16.10.2
iptables -t nat -D POSTROUTING -s 172.16.10.2/32  -o br0 -j SNAT --to-source 192.168.187.6

