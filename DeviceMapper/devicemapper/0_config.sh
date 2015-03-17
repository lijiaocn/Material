#!/bin/bash

metaFile=`pwd`"/Meta2G.dat"
poolFile=`pwd`"/Pool100G.dat"
metaLoop="/dev/loop6"
poolLoop="/dev/loop7"
blockSize=1024

poolName="testPool"
metaSize=$((2*2**30))
poolSize=$((100*2**30))

thin1ID="01"
thin2ID="02"
thin1="thin1"
thin2="thin2"
thin1Size=$((2*2**30))

mountDir="mount"
