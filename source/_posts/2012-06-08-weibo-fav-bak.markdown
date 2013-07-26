---
layout: post
title: "备份新浪微博收藏夹"
date: 2012-06-08 11:49
comments: true
categories: [技术]
---
由于要定期对收藏的微博进行整理并删除，又想保留一份原始数据，于是想到了备份一下，在网上找了找没有满意的就自己写了一个，顺便体验一下微博开放的api.

这个小程序可以备份收藏微博的原始json格式的数据,也可以保存成易读的文本格式，还可以根据自己的需要扩展保存任何想要的格式(比如excel、html等我就不一一实现了)

程序代码放在github上用于学习交流，可以[点击这里查看](https://github.com/wq163/weibobak)源代码和文档，或者[binary包](/static/weibobak.tar.gz)

{% render_partial static/weibobak-README.md %}

----------

下面记录一下使用api几个点，自己的体会，也不一定是最好的方法：  
(以下以我用微博的java sdk写命令行方式的应用来说明)

**1. 调用api的准备工作**  
首先要在微博开放平台页面上申请并创建一个应用，完成后会分配给应用App Key和App Secret，这两个东西在程序中要用到.就是在Config.properties里 client_ID和client_SERCRET这两个属性

**2. 如何在命令行应用里进行oauth2认证**  
典型的web应用方式是用户点击后跳转到新浪的账号验证页面，输入账号验证通过后回调到应用的页面并在url中带上code值，然后我们用这个code获取AccessToken，这个AccessToken就是授权我们访问数据的凭证。
  
按照SDK中提供的api是在浏览器中进行交互的，而我只想写个简单的java命令行应用，不想弄web应用。命令行中调用浏览器进行认证后，我的程序无法获得返回的code，也就没法获取到AccessToken(我可不想人工介入,我只想输入自己的微博账号就搞定)。于是想到程序中模拟浏览器请求（也就是页面中输入账号后提交的那一步），通过抓包获知提交请求所需的参数主要有这么几个:  
{% codeblock lang:java %}
            PostParameter[] params =
                    new PostParameter[] { new PostParameter("withOfficalFlag", 0),
                                         new PostParameter("response_type", "code"),
                                         new PostParameter("redirect_uri", Config.getValue("redirect_URI").trim()),
                                         new PostParameter("client_id", Config.getValue("client_ID").trim()),
                                         new PostParameter("action", "submit"),
                                         new PostParameter("userId", Config.getValue("userId").trim()),
                                         new PostParameter("passwd", Config.getValue("passwd").trim()),
                                         new PostParameter("isLoginSina", ""), new PostParameter("regCallback", ""),
                                         new PostParameter("state", ""), new PostParameter("from", "") };
{% endcodeblock %}

并且要增加http header：  
{% codeblock lang:java %}
        postMethod
            .addRequestHeader("Referer",
                "https://api.weibo.com/oauth2/authorize?client_id=2671507095&redirect_uri=http://jenwang.org&response_type=code");
        postMethod
            .addRequestHeader("User-Agent",
                "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.151 Safari/535.19");
{% endcodeblock %}
