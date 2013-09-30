---
layout: post
title: "关于serialVersionUID与序列化"
date: 2013-09-30 11:24
comments: true
categories: [java技术]
---
## java序列化trick and trap
厂内经常出现序列化对象版本不匹配问题，于是发本文说明一些序列化的注意点

*调用MQ、memcached、rpc等等涉及到远程通讯的都会经过序列化，虽然客户端透明的封装了细节，但底层是一定会有序列化操作的。因此了解序列化的注意事项是非常有必要的，可以避免误用导致潜在的风险*

- 通过网络传输的对象，必须实现Serializable接口，或者父类已经实现序列化接口。

- 网络传输对象继承层次不宜过深，封装在内部的对象也不宜太复杂。（太复杂很容易出现某个相关的类没实现序列化接口，而导致整个对象无法序列化）
	- 一般long/int/String/Map/List/Array等常见类组成的对象就
	能解决问题 
	- 最好不要在本应用对外的业务接口中传递或返回另一人或系统主导业务对象。因为你不能保证别人的对象版本会兼容，从而导致错误扩散

- 在接口定义上用的是父类，实际远程传输过去的是子类，反序列化不了的。特别是在rpc中客户端容易出现此问题

- 远程接口上的参数、返回值类型、会抛出的异常类，都要实现序列化接口。并且server和client都要有对应的类。
	- 一个比较容易忽略的例子是:某服务接口可能会抛出某个运行时异常，但没有把这个异常类放入客户端中，一旦抛出此异常，客户端接收到此异常就会无法反序列化

- ArrayList.subList()返回的List实现类是内部类型，不能序列化的，通过网络传输会出错。
- ArrayList经过网络传输后，里面的元素顺序可能不一样

- 网络传输对象要有无参构造器（如果定义了有参构造器那就要显式定义一个无参构造起），因为机器是不知道传什么内容给有参构造器进行实例化，无参构造器不是public都没关系。没定义无参构造器，有些序列化方式会在底下生成无参构造器的方式才能解决问题。

- 网络传输最好不要用enum类型，太强耦合，从网络一端传到另一端，对方可能还是旧版本而识别不了。
	- Enum 常量的序列化不同于普通的 serializable 或 externalizable 对象。enum 常量的序列化形式只包含其名称；常量的字段值不被传送。为了序列化 enum 常量，ObjectOutputStream 需要写入由常量的名称方法返回的字符串。
	
- 不需通过网络传输的field用transient定义，但有些json序列化类库是不会区别对待这种field

- 有些序列化类库，遇到反序列化不了的类，会反序列化成Map，但会在使用时遇到class cast异常。

- 同一应用不要有同package同名的类，可能隐藏在同名/不同名/不同版本的jar中。

- ，

## serialVersionUID 

- <font color="red">用于网络传输的对象，第一次上线使用时，就一定要设定serialVersionUID，不要不顾编译警告</font>

	- NOTE: 网络对象的匹配，除了靠类名，还靠serialVersionUID，serialVersionUID在《Java语言规范》有固定算法，<u>**跟各field的定义相关，如果没有显式赋值，虽然看不见，但会底下会默认算出一个进行网络传输。**</u>

	- <font color="red">如果没有显式赋值，在看不见觉察不到的情况下，在你增减了field/修改了定义的情况下，serialVersionUID已被改变，这时网络两端就对接不上而悲剧了。  
没定义serialVersionUID，而又发生了serialVersionUID变化，网络两端只有所有机器都停掉，并且先后起有顺序时，才能不出丝毫差错。</font>

- 最好不要用用1L作为serialVersionUID。0L对于java enum的序列化有特殊意义。

- 没赋值serialVersionUID 只是警告，不是错误，造成没设定serialVersionUID，网络两端上线运行一段时间也感觉正常。如果再增减修改field，没赋值好serialVersionUID，网络两端就不匹配。 
	- 算出旧版本的serialVersionUID（使用serialver或eclipse），设置到新版本的代码中 

*本文大部分内容取自前同事的分享资料，作了少许修改，[外网地址](http://lokki.iteye.com/blog/1134482)*
