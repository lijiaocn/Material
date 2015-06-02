#!/bin/bash
#echo subjectAltName = IP:10.42.0.1,IP:127.0.0.1 > /tmp/extfile
echo "extendedKeyUsage = clientAuth">/tmp/extfile
openssl x509 -req -days 365 -in ./Cert2/cert2.csr -CA ./CA/ca.pem -CAkey ./CA/ca-key.pem -CAcreateserial -out ./Cert2/cert2-cert.pem -extfile /tmp/extfile
