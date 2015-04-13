#!/bin/bash
openssl genrsa -out Cert1/cert1-key.pem 2048
openssl req -new -key Cert1/cert1-key.pem -out Cert1/cert1.csr
