#!/bin/bash

ip="192.168.13.77"
./server -ip=$ip -port=1 &
sleep 1
./server -ip=$ip -port=1022 &
sleep 1
./server -ip=$ip -port=1023 &
sleep 1

./server -ip=$ip -port=1024 &
sleep 1
./server -ip=$ip -port=20000 &
sleep 1
./server -ip=$ip -port=32767 &
sleep 1

./server -ip=$ip -port=32768 &
sleep 1
./server -ip=$ip -port=50000 &
sleep 1
./server -ip=$ip -port=65535 &
sleep 1

