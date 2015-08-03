Name:  docker-portable
Version: 1.5
Release: 1
Summary: docker portable g
License: GPL
Distribution: jimdb
#Icon:  
Vendor: JD.Jcloud.Jimdb
#Url:
#Group:
Packager:  jim<jim@jd.com>
#Provides:
#Requires:
Requires:   openssl
#Conflicts:
#Serial: 1
AutoReqProv: no
#ExcludeArch:
#ExclusiveArch:
#ExcludeOS:
#ExclusiveOS:
#Prefix:
#BuildRoot:
Source0:  docker-portable-1.5.tar.gz
#NoSource:
#Patch:
#NoPatch:

%description
	docker portable

%prep
%setup 

%build
#Nothing to do

%install
if [ -d ${RPM_BUILD_ROOT} ];then
	/bin/rm -rf ${RPM_BUILD_ROOT}
fi
mkdir ${RPM_BUILD_ROOT}
cp -rf *  ${RPM_BUILD_ROOT}

%clean
/bin/rm -rf %{_builddir}/*
/bin/rm -rf %{_buildrootdir}/*

%postun
rm -rf /etc/docker

%files
%config /etc/sysconfig/docker
%config /etc/sysconfig/docker-network
%config /etc/sysconfig/docker-storage
/usr/bin/cgroupfs-mount
/usr/bin/docker
/usr/bin/dockerd

%changelog
