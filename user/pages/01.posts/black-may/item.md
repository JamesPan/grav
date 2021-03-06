---
cc: true
comments: true
date: '2015-05-30 11:50:10'
jscomments:
  id: /2015/05/30/black-may/
  title: 中国互联网的黑色五月
  url: http://blog.jamespan.me/2015/05/30/black-may/
routes:
  aliases:
  - posts/black-may
  default: /2015/05/30/black-may
taxonomy:
  category:
  - blog
  - Work
  tag: []
title: 中国互联网的黑色五月
---

每次看我几个月之前写的代码，都觉得当初写的不是代码而是是一坨翔。一直觉得我迟早要被我刚入职那会写的代码坑到，最近还真的被坑了。

一个软件写的是否健壮，不能光看正常流程，还得看看异常流程有没有处理好，容错有没有做好。这一次我就坑在了没有把容错做到位，甚至连 HTML 提供的容错机制都没用上。我为博客里每张图片的 alt 属性添加了内容，偏偏在自己维护的系统的页面上没有做到。

===



## 五月病 ##

也许五月病真的存在，天朝的互联网在这个五月，故障频发。先是网易机房的骨干网路被 DDoS 然后直接宕机 5 小时[^1]，然后是支付宝机房的电信光纤被挖断然后系统瘫痪了一个半小时[^2]，再然后是携程那长达 12 小时的宕机[^3]。

[^1]: [网易骨干网宕机5小时][1]
[^2]: [局部“宕机”90分钟：支付宝称“光纤被挖断”][2]
[^3]: [携程：网络故障由员工错误操作导致][3]

有了这次自己挖坑自己跳的经历，我负责的系统也算是加入“五月俱乐部”了，虽然现在系统体量还不是太大，而且系统主要通过接口提供服务，一次几个小时的页面故障不会引发广泛关注，我还是要吸取前车之鉴。

## 痛定思痛 ##

网易宕机之后，互联网上的技术圈子有一些讨论，然后阿里系的工程师们似乎都认为，异地多活一定要做。

支付宝故障之后，我一度以为我们引以为豪的异地多活没有生效。后来才知道金融系统和一般的互联网服务不太一样，流量切换的时候会更加谨慎。

关于携程，虽然官方的说法是员工错误操作导致，具体原因是人为意外删除了生产服务器上的执行代码[^4]，我却不太相信这套说辞。

[^4]: [携程瘫痪事件确认系员工误操作所致][4]

至于我，当然是要把页面的容错做好，把当年挖的坑填上。

![神秘的程序员们-9 http://blog.xiqiao.info/2009/12/16/611](https://ws4.sinaimg.cn/large/e724cbefgw1esm3nrwqw5j20fa07f3zz.jpg)

## 技术与流程 ##

之前我旁听过一些严重故障的回 (sī) 顾 (bī) 会 (dà) 议 (zhàn)，也听过赵海平先生在一次分享中说到的 Facebook 处理故障的方式。最近耗子的一条微博让我想明白了一些事情。


<blockquote>
技术上出故障是必然的。能否体现一个公司是技术公司，重要看这几点：1）故障的恢复是否有技术含量，2）公司对故障的处理方式，如果是通过加更多的流程，或是通过加更多的权限管控，或是通过处罚犯错误的人，或是上升到员工意识形态上，而不是去用更好的技术来解决，那么这个公司不会是个技术公司。

<footer>
<cite>@左耳朵耗子 http://weibo.com/1401880315/CjZfa1ms4</cite>
</footer>
</blockquote>


其实之前我也手黑弄出过几次故障，有大有小。但是我们在思考如何避免问题再次发生的时候，总是倾向于使用管理的手段，添加更多的流程，用更多的人力来试图避免问题。

<!-- 数据订正造成故障，以后就在执行订正之前找同事做 double check；同时发布多个分支的时候有些代码合并丢失，以后就在集成之后去集成分支检查代码等等。 -->

这是最好的方式，也是最坏的方式。添加流程确实能减少故障发生的次数，而且立竿见影，但是这也是一种杀敌八百，自损一千的方式。我们做技术的人，都希望能够用技术改变人们做事情的方式，然而大部分时候，却是被流程改变了我们做技术的方式。

<!-- 渐渐的，一些开发者失去了对自己创造出来的代码的最基本的信任，如果代码不经过 QA 团队的测试，就不敢发布到生产环境。 -->

也许我们能做得更好。

技术企业的核心价值应该不会是一大堆的流程，而是技术，能够帮助人们提高生产力的技术，或者让人们活的更舒服的技术，或者帮助人们减少 human error 的技术。

[1]: http://www.chuapp.com/2015/05/12/157529.html
[2]: http://news.xinhuanet.com/fortune/2015-05/27/c_1115430242.htm
[3]: http://tech.163.com/15/0529/07/AQP3OEPD000915BF.html
[4]: http://tech.sina.com.cn/i/2015-05-29/doc-iavxeafs8277124.shtml