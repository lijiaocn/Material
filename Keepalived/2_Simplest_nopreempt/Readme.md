---
layout: default
title: Readme

---

# Readme
创建时间: 2015/07/06 11:42:25  修改时间: 2015/07/07 10:49:52 作者:lijiao

----

## 摘要

Deploy:

	              _|_
	              \ /
	         +-----'-----+            +-----------+         VIP:172.10.10.2
	         |   VIP     | keepalived |   VIP     |
	         |   LVS1    +------------+   LVS2    |
	         |  Backup   |            |   Backup  |
	         +-----------+            +-----------+   
	        192.168.192.37            192.168.192.38

两台机器都是Backup，它们之间通过优先级选出一个作为Master。如果所有的Backup都配置了nopreempt，高优先级的机器不会从低优先级的机器那里抢夺Master角色。

目录:

	export/
	|-- App
	|   `-- keepalived
	|       |-- keepalived.backup.conf
	|       `-- keepalived.master.conf
	`-- Shell
		`-- keepalived
			|-- as.backup.sh
			|-- as.master.sh
			|-- fault.sh
			|-- notify.sh
			|-- to_backup.sh
			|-- to_master.sh
			`-- tool_dead.sh

## 文献
