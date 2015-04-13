#!/bin/bash
openssl genrsa -aes256 -out CA/ca-key.pem 2048
openssl req -new -x509 -days 365 -key CA/ca-key.pem -sha256 -out CA/ca.pem
