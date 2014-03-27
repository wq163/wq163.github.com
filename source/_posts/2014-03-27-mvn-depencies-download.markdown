---
layout: post
title: "如何一次性下载某个类库依赖的所有jar包"
date: 2014-03-27 17:50
comments: true
categories: [java技术]
---

** 经常碰到这种事情: **

在一些非maven工程中(由于某种原因这种工程还是手工添加依赖的),需要用到某个新的类库(假设这个类库发布在maven库中),而这个类库又间接依赖很多其他类库,如果依赖路径非常复杂的话,一个个检查手动下载是很麻烦的事. 

** 下面给出一个便捷的办法: **

创建一个新目录里面建一个maven pom文件, 添加需要依赖的类库:

```
<?xml version="1.0"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.dep.download</groupId>
    <artifactId>dep-download</artifactId>
    <version>1.0-SNAPSHOT</version>
 
    <dependencies>
        <dependency>
            <groupId>com.xx.xxx</groupId>
            <artifactId>yy-yyy</artifactId>
            <version>x.y.z</version>
            <scope/>
        </dependency>
    </dependencies>
</project>
```

在这个目录下运行命令:  
``` mvn -f download-dep-pom.xml dependency:copy-dependencies ```

所有跟这个类库相关的直接和间接依赖的jar包都会下载到 ./target/dependency/下

