---
layout: post
title: "jenkins集成caliper"
date: 2013-02-04 13:34
comments: true
categories: 
---
1.jenkins安装caliper-ci插件(Caliper CI Plugin)

2.编写microbench  	
    最简便的办法就是作为单元测试来跑(这样就不用在jenkins里配置跑microbench的步骤)。
    编写好microbench后，加一个test方法运行Runner.main(XXXBenchmarksTest.class, new String[] {
                "--measureMemory", "--saveResults", "XXXBenchmarks.caliper.json" });方法,
    注意指定结果报告的文件位置（这里指定了放在工程的根目录）。
    
3.在jenkins的job中Add post-build action添加publish caliper microbenchmark results,	JSON result files	这项中填入\*\*/\*.caliper.json，目的就是告诉插件microbenchmark生成的结果文件在哪里，如果不行就到工作区里找一下报告文件生成到哪里了,多试几次看看路径是否设对了