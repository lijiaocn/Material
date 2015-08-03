#!/bin/bash

if [ ! -d BUILDROOT ];then
	mkdir BUILDROOT
fi

echo "%_topdir `pwd`" >~/.rpmmacros

cd ./SPECS; rpmbuild -ba docker.spec; cd ..
find ./RPMS  -name "*.rpm"
