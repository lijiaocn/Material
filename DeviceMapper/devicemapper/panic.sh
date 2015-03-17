#!/bin/bash

./6_reinit.sh
./2_activce_thin1.sh

echo "################################################"
echo "####       Start Now!  (input any key)      ####"
echo "################################################"
read 

./a0_random_write_thin1.sh 1>./log/a0.log 2>&1 &
PID1=$!
./3_continue_snap_thin1.sh  10000 1>./log/3.log 2>&1  &
PID2=$!
#./9_timer_remove_all.sh 1>./log/9.log 2>&1 &
#PID3=$!

echo "Stop: (input any key to stop it)"
read
kill -9 $PID1
kill -9 $PID2
kill -9 $PID3
