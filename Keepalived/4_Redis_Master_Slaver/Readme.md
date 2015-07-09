---
layout: default
title: Readme

---

# Readme
创建时间: 2015/07/06 11:42:25  修改时间: 2015/07/09 16:29:31 作者:lijiao

----

## 摘要

## 使用

安装、配置Redis，记录好Redis命令和配置文件的路径，后续操作会用到。

>Redis的配置文件中，不要设置IP绑定，因为要用到VIP，绑定IP会导致各种问题...

调整export/App/keepalived/的中conf文件，将vip、网卡等根据实际情况进行修改。

在export/Shell/config.sh中完成配置:

	#VIP地址
	VIP=192.168.192.161
	
	#本机的IP地址
	LOCALIP=    <--- 本机IP, 告警通知将使用这个IP
	
	#alarm url
	ALARM="http://172.17.57.241/simplealarm"
	
	#Redis端口地址，注意必须与$CONFIG文件中的端口一致
	PORT=6000
	
	#Redis的进程号记录文件，注意与$CONFIG中的配置一致
	PIDFILE=/var/run/redis.keepalived.pid
	
	#Redis配置文件
	CONFIG=/export/App/redis-3.0.2/redis.conf
	
	#Redis命令路径
	CLI=/export/App/redis-3.0.2/bin/redis-cli
	SERVER=/export/App/redis-3.0.2/bin/redis-server

启动Redis服务:

	cd /export/Shell/keepalived;
	./redis.sh start

检查alive,sh执行的退出值是否为0：

	./alive.sh
	echo $?      //如果不为0，需要排查原因，直到返回值为0为止。

在Master执行:

	./as.master.sh

在Backup上执行:

	./as.backup.sh

## 测试

正常启动后，可以看到master的slave地址:

	$redis-cli -h $VIP -p $PORT INFO

	role:master
	connected_slaves:1     
	slave0:ip=192.168.192.38,port=6000,state=online,offset=183,lag=0  <--注意slave地址是"X.X.X.38"
	master_repl_offset:183
	repl_backlog_active:1
	repl_backlog_size:1048576
	repl_backlog_first_byte_offset:2
	repl_backlog_histlen:182

关闭当前master上的redis服务:

	$./redis.sh stop

VIP的redis服务依然可用，但是没有slave:

	$redis-cli -h $VIP -p $PORT INFO

	role:master
	connected_slaves:0
	master_repl_offset:0
	repl_backlog_active:0
	repl_backlog_size:1048576
	repl_backlog_first_byte_offset:0
	repl_backlog_histlen:0

重启原master的redis服务:

	$./redis.h start

VIP上的服务依然可用，且新起的redis成为slave:

	$redis-cli -h $VIP -p $PORT INFO
	role:master
	connected_slaves:1       
	slave0:ip=192.168.192.37,port=6000,state=online,offset=15,lag=0  <--注意slave地址变成了"X.X.X.37"
	master_repl_offset:15
	repl_backlog_active:1
	repl_backlog_size:1048576
	repl_backlog_first_byte_offset:2
	repl_backlog_histlen:14

写入一个value:

	$redis-cli -h $VIP -p $PORT set "key1" "aaaaaaaaaaaa"
	OK
	$redis-cli -h $VIP -p $PORT get "key1" 
	"aaaaaaaaaaaa"

关闭当前Master上的redis服务后，读取"key1"的取值, 并且写入一个新的key:

	$redis-cli -h $VIP -p $PORT get "key1" 
	Could not connect to Redis at 192.168.192.161:6000: Connection refused

	$redis-cli -h $VIP -p $PORT get "key1" 
	"aaaaaaaaaaaa"

	$redis-cli -h $VIP -p $PORT set "key2" "bbbbbbbbbbbbb"
	OK


>可以看到VIP上的服务瞬间不可用后，立马恢复。

## 详情

Deploy:

	              _|_
	              \ /
	         +-----'-----+            +-----------+         VIP:192.168.192.161
	         |   VIP     | keepalived |   VIP     |
	         |   LVS1    +------------+   LVS2    |
	         |  Master   |            |   Backup  |
	         +-----------+            +-----------+   
	        192.168.192.37            192.168.192.38

初次协商时，高优先级的成为Master，非初次协商时，如果低优先级的已经是Master了，高优先级的不会去抢占Master的角色。

除了检测对方的存活状态之外，每个Keepalived还会通过调用alive.sh检测自身状态是否正常。

	vrrp_script chk_alive {
		script "/export/Shell/keepalived/alive.sh"
		internal 1    # 1 second
		fall 3
		rise 3
	}

如果alive.sh返回0，则认为是OK的，连续三次OK，使用VRRP将自身存活的消息发送出去。

如果alive.sh返回1，则认为是Fail的，连续三次Fail，使用VRRP将自身死亡的消息发送出去。

>在alive.sh中，检查的是redis的进程是否存在，如果存在就认为正常。

>刚开始的时候，用"redis-cli ping"检查，发现在使用vip的时候，每过10秒左右，该命令执行的时间就会增加到9秒多，从而被keepalived认定超时，引发Master/Backup频繁切换。

目录:

	export/
	|-- App
	|   `-- keepalived
	|       |-- keepalived.backup.conf
	|       `-- keepalived.master.conf
	`-- Shell
		`-- keepalived
			|-- alive.sh
			|-- as.backup.sh
			|-- as.master.sh
			|-- fault.sh
			|-- notify.sh
			|-- to_backup.sh
			|-- to_master.sh
			`-- tool_dead.sh

## 文献
