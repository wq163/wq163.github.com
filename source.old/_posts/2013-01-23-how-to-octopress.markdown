---
layout: post
title: "how-to-octopress"
date: 2013-01-23 18:42
comments: true
categories: 
---
记录一下怎么用octopress的，尼玛一段时间没弄都忘了怎么用这玩意写博客了。

windows7

安装git

安装Ruby
下载RubyInstaller和DevKit。选rubyinstaller-1.9.2-p290.exe，DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe

http://rubyforge.org/frs/?group_id=167

https://github.com/oneclick/rubyinstaller/downloads/

先安装RubyInstaller，然后解压缩DevKit(路径中不能有中文)。

在“Start Command Prompt with Ruby”命令行中进入DevKit解压缩的目录，然后运行以下命令:

ruby dk.rb init

ruby dk.rb install

gem install rdiscount --platform=ruby


cd octopress

gem install bundler

bundle install 

由于本地原先已经有octopress，执行

rake setup_github_pages

-------------------
写文章

rake new_post["title"]，会创建一个新的Post，新文件在source/_post下，文件名如下面的格式:2012-07-31-title.markdown。该文件可以直接打开修改。

预览效果
在修改设置或者写完文章后，想看看具体效果，可以通过如下命令来完成:

set LANG=zh_CN.UTF-8

set LC_ALL=zh_CN.UTF-8

rake generate

rake preview

发布到github

rake generate

rake deploy

提交源码

git add .

git commit -m "new post"

git push origin source

---------------------------------

windows下可能会在My Octopress Page is coming soon之后出现hellip;不是内部命令之类的错误, 可以不用管, 如果一定不想要出现这个错误可以修改myoctopress目录下的Rakefile, 搜My Octopress Page is coming soon, 在&hellip;前加个^(这个是Windows cmd的转义符), 如下

system "echo 'My Octopress Page is coming soon ^&hellip;' > index.html"
rake setup_github_pages命令最后出现Now you can deploy to xxxxxxx with `rake deploy`, 就表示成功.

另外文章的文件格式一定要转化一下（环境变量LANG指定的格式），不然生成会出错

