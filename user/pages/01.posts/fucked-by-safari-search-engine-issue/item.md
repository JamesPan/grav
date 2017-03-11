---
title: 没被封闭软件坑过，就不懂得自由软件的可爱
date: '2016-09-29 01:30'
taxonomy:
    category:
        - blog
    tag:
        - 'OS X'
header_image_file: 'https://ws1.sinaimg.cn/mw1024/801b780agw1f89thdv8o0j20k80b4js3.jpg'
comments: true
---

很长一段时间里，一直把 Safari 当作我在工作之外的主力浏览器，比较喜欢它的 iCloud 同步以及和 macOS、iOS 的高度集成。

但是今天我却碰到了一桩怪事，Safari 给我上了一课。

===

Safari 为 macOS 提供了 "Search With XX" 这个 Action，我一般会把搜索引擎设置为 Google。

![](https://ws3.sinaimg.cn/mw1024/801b780agw1f89sr0xzfbj20k009c0tn.jpg)

平时我搜索的时候，会用 www.google.com.hk 这个位于域名，然而今天不知何故，我一使用 Search With Google，就会直接使用 www.google.co.th 这个域名，然后由于你懂的原因，无法访问。

![](https://ws2.sinaimg.cn/large/801b780agw1f89sw2zo5sj20f6053q3j.jpg)

为了知道这个 www.google.co.th 是哪里的服务，我做了一些微小的工作，终于能够顺利访问了。

![](https://ws3.sinaimg.cn/large/801b780agw1f89sxga7qfj20il091t9a.jpg)

居然是泰国！为什么会是泰国！

更可恶的是，我在网上翻来覆去查了好久，都找不着在 Safari 中设置搜索引擎的 URL 的方法，在 Safari 的配置文件和一坨坨的 plist 中也找不到蛛丝马迹，而我仅仅是想要把 www.google.co.th 替换为 www.google.com.hk 而已，Safari 却让我连这么简单的事情都做不到。

当时就感觉不是我在用 Safari 上网，而是被 Safari 上了！

后来在我的一顿折腾之下， Safari 的 Search With Google 又开始使用 www.google.com.hk 了，原因居然是我把网络代理的出口，从东南亚改成了香港。

Safari 这魔性的功能真是惊到我了，这盒子黑得可以。

