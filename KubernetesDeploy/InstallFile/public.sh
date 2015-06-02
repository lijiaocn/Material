ETC="/export/jd-kuber8s/etc"
BIN="/export/jd-kuber8s/bin"
SERVICE="/usr/lib/systemd/system"
WWW="/export/jd-kuber8s/www"
KUBER8S="/export/jd-kuber8s"

func_copy_config(){
	if [ ! -d $ETC ]
	then
		mkdir -p $ETC
	fi
	cp -f ./config/* $ETC
}

func_copy_bin(){
	if [ ! -d $BIN ]
	then
		mkdir -p $BIN
	fi
	cp -f ./bin/* $BIN
}

func_copy_service(){
	if [ ! -d $SERVICE ]
	then
		mkdir -p $SERVICE
	fi
	cp -f ./service/* $SERVICE
}

func_copy_www(){
	if [ ! -d $WWW ]
	then
		mkdir -p $WWW
	fi

	cp -rf ./www/*  $WWW
}
