---
layout: post
title: "Leiningen的profiles.clj不生效？"
date: 2013-07-16 18:54
comments: true
categories: [clojure]
---

需求:  
比如要自定义本地maven库的路径，又不想在project.clj中定义，因为每个人的本地路径不同，写在工程中不好。那么在profiles.clj中定义比较好：

	{:user {:local-repo "D:\\m2\\repository"}}

当庆幸找到解决方法时，一运行发现根本没生效是件很扫兴的事。
网上能找到的资料都告诉你profiles.clj这个文件是放在~/.lein/这个目录下的。

**实际情况是：** 
``` 如果自定义了LEIN_HOME的路径，那么profiles.clj就应该放在LEIN_HOME目录下，而不是~/.lein/下 ```  
否则不会生效，切记。 
