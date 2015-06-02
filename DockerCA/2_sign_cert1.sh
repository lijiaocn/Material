#!/bin/bash
#echo subjectAltName = IP:10.42.0.1,IP:10.42.0.92,IP:127.0.0.1 > /tmp/extfile
echo subjectAltName = IP:10.42.0.1,IP:127.0.0.1 > /tmp/extfile
#echo extendedKeyUsage = clientAuth>>/tmp/extfile
#echo subjectAltName = IP:127.0.0.1 > /tmp/extfile
openssl x509 -req -days 365 -in ./Cert1/cert1.csr -CA ./CA/ca.pem -CAkey ./CA/ca-key.pem -CAcreateserial -out ./Cert1/cert1-cert.pem  -extfile /tmp/extfile
