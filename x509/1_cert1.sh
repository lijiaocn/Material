#!/bin/bash
openssl req -new  -out Cert1/cert1.csr -config ./cert1.req.config
openssl x509 -req -days 365 -in ./Cert1/cert1.csr -CA ./CA/ca.pem -CAkey ./CA/ca-key.pem -CAcreateserial -out ./Cert1/cert1-cert.pem
