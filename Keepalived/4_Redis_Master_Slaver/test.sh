#!/bin/bash

VIP=192.168.192.161
PORT=6000

redis-cli -h $VIP -p $PORT INFO
