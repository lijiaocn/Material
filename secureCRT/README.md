---
layout: default
title:  README
author: 李佶澳
createdate: 2018/08/20 10:57:00
changedate: 2018/08/20 10:59:24
categories:
tags:
keywords:
description: 

---

* auto-gen TOC:
{:toc}

Mac下的SecureCRT需要破解才能使用 所以有些费劲的..

先 下载SecureCRT和破解文件 默认下载到了当前用户的”下载”目录中

在”Finder”中 打开 “scrt-7.3.0-657.osx_x64.dmg” 并将 SecureCRT复制到”应用程序”中. 这时SecureCRT的路径是: /Applications/SecureCRT.app/Contents/MacOS/SecureCRT

测试一下SecureCRT是否能打开, 如果可以,先关闭

在终端中输入:

	sudo perl securecrt_mac_crack.pl /Applications/SecureCRT.app/Contents/MacOS/SecureCRT

如果终端中有输出下面的信息, 表示激活成功了

    It has been cracked 
    License: 
    Name: bleedfly 
    Company: bleedfly.com 
    Serial Number: 03-29-002542 
    License Key: ADGB7V 9SHE34 Y2BST3 K78ZKF ADUPW4 K819ZW 4HVJCE P1NYRC 
    Issue Date: 09-17-2013

打开SecureCRT，输入刚才终端的数据就完成了破解

    Name: bleedfly 
    Company: bleedfly.com 
    Serial Number: 03-29-002542 
    License Key: ADGB7V 9SHE34 Y2BST3 K78ZKF ADUPW4 K819ZW 4HVJCE P1NYRC 
    Issue Date: 09-17-2013

再次打开 SecureCRT 点击Enter License Data..

1) 直接Continue，空白不填写

2) 点击Enter Licence Manually

3) Name:输入bleedfly Company:输入 bleedfly.com

4) Serial number: 03-29-002542 
License key: ADGB7V 9SHE34 Y2BST3 K78ZKF ADUPW4 K819ZW 4HVJCE P1NYRC

5) Issue date: 09-17-2013

6) 点击 Done

如果是灰色可能 上面的步骤输入的有问题, 也有可能是版本的问题. 请使用我提供给大家的链接进行下载 本人经过试验后, 是可以安装的
