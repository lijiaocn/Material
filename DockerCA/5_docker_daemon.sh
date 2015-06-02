#!/bin/bash
docker -d --tlsverify --tlscacert=./CA/ca.pem --tlscert=./Cert1/cert1-cert.pem --tlskey=./Cert1/cert1-key.pem -H=0.0.0.0:2376 
#docker -d --tlsverify --tlscacert=./CA/ca.pem --tlscert=./Cert2/cert2-cert.pem --tlskey=./Cert2/cert2-key.pem -H=0.0.0.0:2376 
