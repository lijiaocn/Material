---
layout: default
title: Readme

---

# Readme
创建时间: 2015/07/06 11:42:25  修改时间: 2015/07/07 12:03:14 作者:lijiao

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

除了检测对方的存活状态之外，每个Keepalived还会通过调用alive.sh检测自身状态是否正常。

	vrrp_script chk_alive {
		script "/export/Shell/keepalived/alive.sh"
		internal 1    # 1 second
		fall 3
		rise 3
	}

如果alive.sh返回0，则认为是OK的，连续三次OK，使用VRRP将自身存活的消息发送出去。

如果alive.sh返回1，则认为是Fail的，连续三次Fail，使用VRRP将自身死亡的消息发送出去。


Master的角色是指定的，如果192.168.192.37存活，那么它一定是Master。如果它是重新复活，那么它会抢回Master。

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
