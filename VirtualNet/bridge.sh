set +x
#Create bridge
brctl addbr br0
brctl addif br0 enp0s3
brctl stp br0 on
ifconfig enp0s3 0 up
ifconfig br0 up
## Bridge external address
ip addr add 192.168.187.5/24 dev br0
## Bridge internal address
ip addr add 172.16.10.1/24 dev br0

#Create tap
tunctl -t tap0
brctl addif br0 tap0
ifconfig tap0 up
## tap external address
ip addr add 192.168.187.6/24 dev br0
## tap internal address
#ip addr add 172.16.10.2/24 dev tap0

#Setting route
ip route add default via 192.168.187.5 dev br0
ip route add 172.16.10.0/24 via 172.16.10.1 dev br0

#Iptables, forword to tap0
iptables -t nat -A PREROUTING -d 192.168.187.6/32 -j DNAT --to-destination 172.16.10.2
iptables -t nat -A POSTROUTING -s 172.16.10.2/32  -o br0 -j SNAT --to-source 192.168.187.6

