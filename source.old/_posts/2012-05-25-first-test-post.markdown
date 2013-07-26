---
layout: post
title: "第一次使用,中文问题的解决办法"
date: 2012-05-25 23:05
comments: true
categories: [c1,中文测试分类]
---
文章内容和分类中有中文比较麻烦，网上找了很多方法都不管用,我在windows7下cywin的解决办法是： 

1. 把文章的makedown文件保存成为无BOM的utf-8格式。
2. 控制台或脚本中在rake generate命令后加上export LC_ALL=zh_CN.UTF-8和export LANG=zh_CN.UTF-8

两步骤缺一不可