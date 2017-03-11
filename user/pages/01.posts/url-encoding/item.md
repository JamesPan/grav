---
cc: true
comments: true
date: '2015-05-17 22:51:22'
jscomments:
  id: /2015/05/17/url-encoding/
  title: 陈年老坑之 URL Encoding
  url: http://blog.jamespan.me/2015/05/17/url-encoding/
routes:
  aliases:
  - posts/url-encoding
  default: /2015/05/17/url-encoding
taxonomy:
  category:
  - blog
  - Work
  tag: []
thumbnail: https://ws3.sinaimg.cn/small/e724cbefgw1es8uaglowgj20ca07f3yz.jpg
title: 陈年老坑之 URL Encoding
---

下午去公司蹭健身房，本以为可以悄悄的来，悄悄的走，结果锻炼完回到工位歇会的功夫，就被同事叫去帮忙看问题了。同事在项目中用到一个基于 Solr 构建的搜索引擎，我这边也用了。

同事那边的查询条件比我这边的复杂好多，各种条件与或非的。文档里写了，通过在条件前面写上“+”来表示两个条件是逻辑与。同事照着文档在搜索的 URL 中以各种姿势添加“+”，可是搜索引擎就是不认这个加号，查出的结果是两个条件做逻辑或得到的。

===



一开始我给同事的建议是使用搜索引擎的客户端提供的 API 去组装查询条件，不要自己在地址栏里面拼链接，如果 API 出了问题那就可以去找维护搜索引擎的同学修复了。也许我这种有 API 就调 API 的习惯，是我很少掉进坑里的原因？

我直接问同事要了他正在调试的链接和文档，开始折腾。几分钟之后我发现，URL 中的加号，在搜索引擎返回的查询参数中，变成了空格。然后我怀疑这个问题和 URL Encoding 有关，一番 Google 之后把加号换成了 %2B，然后就搞定了。

## 寻寻觅觅 ##

在 Java Web 开发中，如果需要访问一个网址，尤其是拼装了很多参数的网址，我们一般都会先用 URLEncoder 做一个编码，接收方收到网址中的参数之后，一般都会用 URLDecoder 做一个解码。

为了了解这套编码解码背后的映射规则，我去翻看 JDK 的文档，基本上没有收获，除了 "application/x-www-form-urlencoded" 这个东西。不看代码的原因是这个类的代码写的实在不怎么样。

顺藤摸瓜，我在维基百科找到了我想要的答案[^1]。

[^1]: [百分号编码][1]

## 百分号编码 ##

百分号编码是用于 URI 的编码机制，也用于为 "application/x-www-form-urlencoded" MIME 准备数据。

URI 把允许出现的字符分为“保留”和“未保留”。

保留字符是这么定义的[^2]：

[^2]: [RFC 3968][2]

```
reserved    = gen-delims / sub-delims
gen-delims  = ":" / "/" / "?" / "#" / "[" / "]" / "@"
sub-delims  = "!" / "$" / "&" / "'" / "(" / ")"
                  / "*" / "+" / "," / ";" / "="
```

百分号编码一个保留字符，其实是在这个字符的 16 进制 ASCII 值前面加上转义字符 '%'。

未保留字符是这么定义的：

```
unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"
```

未保留字符不需要被百分号编码。

对于那些不在保留字符和未保留字符范围内的字符，先转换为UTF-8字节序列，然后对其字节值使用百分号编码。

## 加号与空格 ##

维基百科百分号编码词条的最后一段解释了 URL Encoding 中加号与空格之间的陈年老坑。

> 当 HTML 表单中的数据被提交时，表单的域名与值被编码并通过 HTTP 的 GET 或者 POST 方法甚至更古远的 email 把请求发送给服务器。
>
> 这里的编码方法采用了一个非常早期的通用的 URI 百分号编码方法，并且有很多小的修改如新行规范化以及把空格符的编码 "%20" 替换为 "+"。
>
> 按这套方法编码的数据的 MIME 类型是 application/x-www-form-urlencoded，当前仍用于（虽然非常过时了）HTML 与 XForms 规范中。此外，CGI 规范包括了 web 服务器如何解码这类数据、利用这类数据的内容。

在正常的编码解码流程中，编码的时候先把加号替换为 %2B，然后把空格替换为加号；解码的时候先把加号替换为空格，再把 %2B 替换为加号，天衣无缝。

假如我在一个经过编码的 URI 中直接添加加号，然后直接被拿去解码，加号就会妥妥的被替换成空格了。


[1]: http://zh.wikipedia.org/wiki/百分号编码
[2]: http://tools.ietf.org/html/rfc3986#section-2.2