---
cc: true
comments: true
date: '2015-09-14 01:17:02'
jscomments:
  id: /2015/09/14/loss-of-precision/
  title: 消失的用户标识——浮点数精度问题
  url: http://blog.jamespan.me/2015/09/14/loss-of-precision/
routes:
  aliases:
  - posts/loss-of-precision
  default: /2015/09/14/loss-of-precision
taxonomy:
  category:
  - blog
  - Work
  tag:
  - Bug
  - Precision
thumbnail: https://ws1.sinaimg.cn/bmiddle/e724cbefgw1ew0unvadj2j207g05o3yz.jpg
title: 消失的用户标识——浮点数精度问题
---

最近我在负责系统稳定性相关工作，其实就是单机压测、链路梳理、容量评估之类的事情，其中比较有意思事情是构造压测请求。

其实去年双 11 之前的全链路压测中，除了第一次压测之外，电子面单系统的压测请求基本上都是我造的，只不过那时候我是临时接手加上时间紧迫来不及好好设计，只好用 Python 大法、Bash 大法来硬扛。今年是一个新的开始，我要换种玩法，不想像去年一样只用单机的计算力来构造请求了，我要用集群，ODPS 大法好！

===



在某些场景下，需要对数据库更新操作做压测，这时候我需要借助去年压测留下来的数据，生成今年的压测请求。写了个程序连接到到生产数据库，把去年的压测数据有节制地以 [JSON][1] 格式导出到文件里，然后对每一行 JSON 做 Base64 编码，上传到 ODPS 中。到了 ODPS 上再跑个函数把 Base64 解开，然后用 UDTF 把 JSON 变成结构化的表。

之所以这么绕，其实是我懒得去研究怎么把 MySQL 的数据导入到 ODPS。也正是因为这么绕了一圈，加上处理 JSON 反序列化的时候没有弄好，把我绕到一个坑里了。

## 消失的用户标识 ##

数据上传好之后，简单看了看，字段都在，字段值看起来也八九不离十，我开始吭哧吭哧写生成压测请求的 UDTF 去了。写好之后提交，运行，下载，发起请求，发现悲剧了。生成的请求有些不对劲，仔细一看，发现请求中一个用来标识用户身份的参数为空。

我开始好奇了，这个参数为空，就代表生成请求时候传入的用户身份标识，不在我事先准备好的那批数据中，而这个标识，是一个很大的 Long 型变量。

赶紧跑一把查询，发现上传的数据中，九成以上的用户标识，都不在我那批数据中。

当时我就震惊了。这尼玛什么鬼！我开始怀疑是 [ODPS 上传工具][3]出了问题，因为我之前在做散列算法选型的时候，被这个上传工具坑过。

于是我就开始了各种尝试。把表砍掉重练，生成几行记录上传，生成几万行记录上传……

最后终于发现，上传的 Base64 文件没问题，解析出来的 JSON 也没问题，但是从 JSON 到结构化数据这一步出了问题。

## Gson vs. fastjson ##

一开始我在处理 JSON 的时候，是不用 Gson 的，一直用 fastjson。这几天用 ODPS 生成压测请求的时候发现，fastjson 的序列化功能不能用在 ODPS 的 UDF 实现中，可能是因为调用了一些比较特殊的代码，而这些代码出于安全考虑被 ODPS 禁止了，我才临时换了 Gson 作为序列化工具。

Gson 在做序列化的时候没什么大问题，在反序列化的时候却让我十分怀念 fastjson 的好。Gson 会把 JSON 中数字类型的值，不管三七二十一地统统转换成 Double 类型，因此对于那些实际上是 Long 型的值，我还得做一次类型转换才行。

fastjson 则不同，对于数字类型，它会尽可能的使用最小的类型去表达，能用 Integer 的就绝不用 Long，然后在取值的时候提供大量的 API 帮助用户完成类型转换。

问题就出在类型转换上。

## 浮点数与 IEEE 754 ##

本科的时候，第一门课，计算机科学导论，就简单地讲过浮点数在计算机内部的表示，到了学习组成原理的时候又讲了一遍。然而具体的细节我还是忘了，只记得有 IEEE 754[^1] 这个东西。

[^1]: [Double-precision floating-point format][2]

![双精度浮点数](https://ws1.sinaimg.cn/large/e724cbefgw1ew1a83twibj20yc06ymy9.jpg)

和 Long 型一样，Double 占据 64 bit。1 bit 符号位，11 bit 指数位，52 bit 尾数位。

很明显，Long 型有 63 bit 用来存储具体的值，而 Double 只有 52 bit，把一个 Long 型变量转换成 Double 型的时候有可能会造成不可挽回的信息丢失，特别是 Long 型变量的有效 bit 超过 53 位的时候。

举个栗子，9223370016454021128L，转换为 double 型，再转换为 long 型，就变成了 9223370016454021120L。

借助系统自带的计算器，我们可以轻松地得到一个整数的二进制形式，OS X 和 Linux 的计算器都带有这个功能，至少 Gnome 和 KDE 的计算器是支持的。

![大整数的二进制表示](https://ws2.sinaimg.cn/large/e724cbefgw1ew1avmqukyj20b205dwev.jpg)

得到二进制表示之后，忽略第一个为 1 的 bit，之后的 52 bit 就是尾数。

![尾数与丢失的比特](https://ws4.sinaimg.cn/large/e724cbefgw1ew1bb7p19xj20b205ejrw.jpg)

## 带着镣铐的舞蹈 ##

问题的原因找到了，接下来就是要解决问题，无论如何都不能让 Long 型变量被转换为 Double 类型。

带着以上原则，我开始寻找解决方案。可怜的是我对 Gson 不太熟悉啊，各种面向 Google 面向 StackOverflow 编程之后还是搞不定。

抱着试一试的心情，用 fastjson 做了一下反序列化，提交到 ODPS 上之后居然成功了。看来在 ODPS 上处理 JSON，只能序列化用 Gson，反序列化用 fastjson 了。

这种人格分裂般的用法也是无奈啊，再一次印证了现实世界中的编程就是带着镣铐的舞蹈，以及所谓的高级工程师就是熟知系统中的坑然后熟练地绕过这些坑。


[1]: http://json.org
[2]: https://en.wikipedia.org/wiki/Double-precision_floating-point_format
[3]: https://docs.aliyun.com/#/pub/odps/tools/dship&install