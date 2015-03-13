---
layout: default
title: Readme

---

# Readme
创建时间: 2015/03/10 03:25:33  修改时间: 2015/03/10 04:03:23 作者:lijiao

----


## 摘要

classless qdisc: pfifo_fast

man tc-pfifo_fast

## 原理

报文发送策略:

	1. 包含三个band: band0、band1、band2
	2. 在每个band中应用FIFO策略，
	3. 当band0中没有报文的时候，才会发送band1中的报文
	4. 同理，当band1中没有报文的时候才会发送band2中的报文

报文入队策略:

	1. Kernel依据报文头中的TOS值，将报文分发到对应的band
	2. TOS值与band的对应关系:

	 TOS     Bits  Means                    Linux Priority    Band
	 ------------------------------------------------------------
	 0x0     0     Normal Service           0 Best Effort     1
	 0x2     1     Minimize Monetary Cost   1 Filler          2
	 0x4     2     Maximize Reliability     0 Best Effort     1
	 0x6     3     mmc+mr                   0 Best Effort     1
	 0x8     4     Maximize Throughput      2 Bulk            2
	 0xa     5     mmc+mt                   2 Bulk            2
	 0xc     6     mr+mt                    2 Bulk            2
	 0xe     7     mmc+mr+mt                2 Bulk            2
	 0x10    8     Minimize Delay           6 Interactive     0
	 0x12    9     mmc+md                   6 Interactive     0
	 0x14    10    mr+md                    6 Interactive     0
	 0x16    11    mmc+mr+md                6 Interactive     0
	 0x18    12    mt+md                    4 Int. Bulk       1
	 0x1a    13    mmc+mt+md                4 Int. Bulk       1
	 0x1c    14    mr+mt+md                 4 Int. Bulk       1
	 0x1e    15    mmc+mr+mt+md             4 Int. Bulk       1

	>Linux Priority使用setsockopt设置,选项名是"SO_PRIORITY"
	>最后一列称为priomap: 1、2、1、1、2、2、2、2、0、0、0、0、1、1、1、1
	>priomap说明TOS值与band的对应关系

队列长度在网卡中设置:

	ifconfig eth0 txqueuelen 10

## 对比PRIO

pfifo_fast是一个classless的qdisc，不能再添加qdisc, 也不能进行配置，是默认的策略，例如:

	[root@localhost ~]# tc qdisc show 
	qdisc pfifo_fast 0: dev enp0s3 root refcnt 2 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1
	qdisc pfifo_fast 0: dev enp0s8 root refcnt 2 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1
	qdisc pfifo_fast 0: dev enp0s9 root refcnt 2 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1

PRIO是classful的，可以配置band数量和priomap，而且band中可以添加qdisc。


## 文献
1. http://xxx  "Name"


