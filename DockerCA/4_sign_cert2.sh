#!/bin/bash
echo "extendedKeyUsage = clientAuth">/tmp/extfile
openssl x509 -req -days 365 -in ./Cert2/cert2.csr -CA ./CA/ca.pem -CAkey ./CA/ca-key.pem -CAcreateserial -out ./Cert2/cert2-cert.pem -extfile /tmp/extfile
