---
layout: post
title: "hbase启动问题记录"
date: 2013-01-23 17:19
comments: true
categories: 
---
昨天测试环境的Hbase启动有问题,日志中显示:

transaction type: 1 error: KeeperErrorCode = NoNode for /hbase

hmaster等其他进程日志中显示连接不上zookeeper，发现zookeeper启动有问题。


于是判断可能是(% style="font-size: 14px; line-height: normal;" %)zookeeper中的某些数据丢失了，之前也出现过类似的启动问题，都是清除zookeeper所有数据解决的，这显然不能根本上解决问题。

进一步分析和判断想到hbase的数据目录，由于商测环境是用伪分布式的方式部署的，zookeeper集成在hbase里管理，所以zookeeper的数据也在hbase的临时数据目录下。hbase的临时目录默认是放在/tmp的，而linux的/tmp目录是会被定期清理的(参考linux系统的tmpwatch)。到此问题已基本定位清楚了，修改hbase的临时目录位置，问题解决



hbase.rootdir

这个目录是region  server的共享目录，用来持久化Hbase。URL需要是'完全正确'的，还要包含文件系统的scheme。例如，要表示hdfs中的 '/hbase'目录，namenode  运行在namenode.example.org的9090端口。则需要设置为hdfs:~/~/namenode.example.org:9000 /hbase。默认情况下Hbase是写到/tmp的。不改这个配置，数据会丢失。     

默认: file:~/~//tmp/hbase-${user.name}/hbase



hbase.tmp.dir

本地文件系统的临时文件夹。可以修改到一个更为持久的目录上。(/tmp会清除)     

默认: /tmp/hbase-${user.name}


**这两点是hadoop/hbase系统部署和运维要重点注意的事项**