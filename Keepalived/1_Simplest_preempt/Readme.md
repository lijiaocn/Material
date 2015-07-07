---
layout: default
title: Readme

---

# Readme
创建时间: 2015/07/06 11:42:25  修改时间: 2015/07/07 10:47:38 作者:lijiao

----

## 摘要

Deploy:

	              _|_
	              \ /
	         +-----'-----+            +-----------+         VIP:172.10.10.2
	         |   VIP     | keepalived |   VIP     |
	         |   LVS1    +------------+   LVS2    |
	         |  Master   |            |   Backup  |
	         +-----------+            +-----------+   
	        192.168.192.37            192.168.192.38

Master的角色是指定的，如果192.168.192.37存活，那么它一定是Master。如果它是重新复活，那么它会抢回Master。

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
