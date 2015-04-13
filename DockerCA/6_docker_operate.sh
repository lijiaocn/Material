#!/bin/bash

if [[ $# -lt 2 ]];then
	echo "usage: $0 host commands"
	exit 0
fi

Host=$1
shift 1

docker --tlsverify --tlscacert=./CA/ca.pem --tlscert=./Cert2/cert2-cert.pem --tlskey=./Cert2/cert2-key.pem -H=$Host:2376 $@

