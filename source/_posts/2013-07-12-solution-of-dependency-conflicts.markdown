---
layout: post
title: "避免jar依赖冲突的一种办法"
date: 2013-07-12 14:21
comments: true
categories: [java技术]
---

  java中的依赖冲突问题一直比较头疼，特别是做公用包给其他系统用的时候，现在都不敢引入太多的依赖，基本上每次都要帮别人解决依赖冲突的问题，非常麻烦。  

  特别是碰到一些老系统还不是用maven管理的，人家用你的一个功能还要拷一堆jar包过去，然后排出哪些包在系统中已经有了，版本是否兼容等问题，非常蛋疼。为了方便人家使用就想把所有依赖打成一个jar包提供出去，但这样潜在的依赖冲突问题就会更严重，以后出现冲突时都不知道哪个jar包含了冲突的类。  

  更不想引入OSGi这种重量级的东西来隔离依赖。  

## 一种解决方法  
  尝试了多种途径后，发现还是用maven-shade-plugin的relocation方式比较能够满足需要，对于提供基础类库的场景下比较友好。  

  原理就是可能把依赖的class重命名包路径，并打包到一个jar中。maven-shade-plugin主要帮我们做了三件事情：  

  - 把依赖的class重新放到指定的包下；  
  - 改写相关class的字节码，对应于重定义的包路径； 
  - 把相关依赖的class打进一个jar包；   

  这样我们对外提供一个jar包就可以了，显得非常干净，依赖的类被定义到指定的包路径中（比如以当前项目路径为前缀），可以避免跟使用者系统的包冲突。

  有时候我们并不希望把所有的依赖都打到一个包中，只想把一部分容易引起冲突的依赖重定义包路径后包含进来，幸运的是maven-shade-plugin很容易做到，并且会把要发布到maven库的pom.xml中的依赖关系都自动改写掉。（通过配置artifactSet中的include和exclude来指定要包含和排除的依赖）

## 简单例子  
比如我们有这么一个需求：  

 -  假设commons-collections这个包非常容易跟其他系统引起冲突，我们想把它重定义路径后包含到主jar包中； 
 -  假设我们认为mapdb这个类库一般不会跟别人冲突，不想把它打进主jar包里;  


  在pom.xml中定义plugin:  

		<plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>2.1</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <shadedArtifactAttached>false</shadedArtifactAttached>
                            <!--<shadedClassifierName>standalone</shadedClassifierName>-->
                            <!--<createDependencyReducedPom>true</createDependencyReducedPom>-->
                            <!--<shadedArtifactId>jconvert-pinyin-standalone</shadedArtifactId>-->
                            <!--<shadeSourcesContent>true</shadeSourcesContent>-->
                            <createSourcesJar>true</createSourcesJar>
                            <artifactSet>
                                <excludes>
                                	<exclude>org.mapdb:*</exclude>
                                </excludes>
                            </artifactSet>
                            <relocations>
                                <relocation>
                                    <pattern>org.apache.commons.collections</pattern>
                                    <shadedPattern>com.mycompany.myproject.org.apache.commons.collections</shadedPattern>
                                </relocation>
                            </relocations>
                        </configuration>
                    </execution>
                </executions>
        </plugin>

其中shadedArtifactAttached设为false,表示把shade过的jar作为项目默认的包（发布到maven库时也是shade后的包,发布上去的pom也是改写过的）。如果设为true,则默认的包还是不变,会生成一个独立的shade后的包(这样可以提供2种格式的包,比如让maven工程用户依赖普通的包,非maven用户使用shade过的包)。  
*其他详细的参数设置参考 [maven-shade-plugin官网](http://maven.apache.org/plugins/maven-shade-plugin/) :*

## 潜在的问题  
如果第三方包中有反射相关的代码，则shade后可能出现不能正常工作，所以要仔细检查确保不会出现问题