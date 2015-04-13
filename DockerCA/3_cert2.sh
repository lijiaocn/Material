#!/bin/bash
openssl genrsa -out Cert2/cert2-key.pem 2048
openssl req -new -key Cert2/cert2-key.pem -out Cert2/cert2.csr
