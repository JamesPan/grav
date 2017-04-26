---
cc: true
comments: true
date: '2016-03-10 23:52:47'
jscomments:
  id: /2016/03/10/spring-of-artificial-intelligence-again/
  title: AlphaGo, The Machine 和我所知道的人工智能
  url: http://blog.jamespan.me/2016/03/10/spring-of-artificial-intelligence-again/
routes:
  aliases:
  - posts/spring-of-artificial-intelligence-again
  default: /2016/03/10/spring-of-artificial-intelligence-again
taxonomy:
  category:
  - blog
  - Study
  tag:
  - Thinking
thumbnail: https://i.imgur.com/Hjs8fcEm.png
title: AlphaGo, The Machine 和我所知道的人工智能
---

AlphaGo 连续两天在围棋上击败李世石，世界为之侧目。「开发者的大事，大快所有人心的大好事」，相比起 Apple 发布 iOS 8 时的自吹自擂，这更称得上是开发者的大事，却不见得是大快所有人心的大好事。

当然不管别人怎么想，我是很开心的。毕竟我作为混迹在计算机工业界的小虾米，有幸在有生之年看到我的同行们再次越过了一座高山，虽然没有亲身参与到项这伟大的事业中，却也感同身受，喜大普奔。

===



自从几十年前人工智能出现在大众视野中，它就成为了人民群众的一个闲聊扯淡时的谈资，尤其是类似于「奇点」这种耸人听闻的名词，更是被非专业人士津津乐道，仿佛知道了奇点就能做些什么使自己摆脱被机器人统治的命运。


<blockquote>
我并不担心「奇点」的到来，如果你的思想已经受到禁锢，何必还在乎统治你的是否是机器人呢? 

<footer>
<cite>@Fenng 阿尔法狗们早就战胜了人类，但我并不太关心 http://t.cn/RGnIwnQ</cite>
</footer>
</blockquote>


现在的中文互联网上，找不到一个让我满意的关于人工智能的定义。还记得当初学习人工智能的时候，廖老师给出了一个十分得体的定义，我虽然已经回忆不起这个定义的准确遣词，但是定义中透露出来的那种谦逊、内敛的感觉，我一直无法忘记。

为此，我特意请求学弟帮忙，咨询还在学校里并且上过廖老师讲授的人工智能课程的同学。廖老师对人工智能的定义是这么说的：

> 人工智能是研究理性智能主体的一般原理和计算方法的学科

至于那些所谓的人工智能是用机器去模仿人的智能，通过了图灵测试就具有人工智能之类的说法，则是人工智能萌芽期留下的陈年往事，被科技媒体翻出来炒炒冷饭，博博眼球。

主流的人工智能研究不是去研究模仿人的智能，因为人不是理性智能主体。是不是瞬间感受到了深深的歧视？人工智能也没有说自己要去造机器人啊，造机器人的那叫机器人学不叫人工智能。

其实人工智能一直都是计算机科学的前沿领域，现在我们所知道的自然语言处理（NLP）、机器学习（ML）以及其他许多子领域，都曾经被叫做人工智能，或者是人工智能领域的问题。一个有趣的现象是，当一个问题被人工智能搞出了大致方向、产出了一些成果之后，这个问题就不再被叫做人工智能了，它会换一个名字，在计算机科学里面开创一个全新的子领域然后继续发展。

人类善于构造比自己强大的机器，这是不争的事实，前人构造出了比人类更擅长快速移动的汽车飞机，比人类更擅长挖断光纤的挖掘机，比人类更擅长下国际象棋的深蓝，我们的生活并没有因此而变得更糟，却是因此变得更好。如今我们有生之年，AlphaGo 被我们之中天赋更高，工作更努力的天才们创造出来了，人类因此拥有了比人类更擅长下围棋的机器，有什么不好呢？

愚蠢的地球人啊，在计算机技术如此发达而且还在快速发展的今天，你还以为在智力活动上你能有几件事情比计算机强，就算有，能强多久？我算微积分不如 Mathematica，打 Dota 不如疯狂的电脑，算矩阵不如 Matlab，那又如何？

就算我高数挂科，也不妨碍我在 Mathematica 的帮助下解决数学问题，就算我线代挂科，也不妨碍我在 Matlab 的帮助下解决矩阵问题。科技的进步，就会使得原本需要大量时间勤学苦练才能获得的技能，变得唾手可得，就会使得原本只有专家才能拥有的经验和决断能力，普通人在机器的辅助下也能拥有。

或许未来，我们中间出现了天才般耀眼的人物，创造出了比我更擅长开发软件的机器，我也不必担心失业，因为在那之前，我会转职成为产品经理，然后每天改三次需求。

前些日子我看过一部美剧，「疑犯追踪」。里面也有一台「超级人工智能」，被称作 The Machine，不知道会不会有美剧迷在 AlphaGo 大火之后想起这台萌萌哒的神龙见首不见尾的机器。


<blockquote>
All computers do is fetch and shuffle numbers, he once explained, but do it fast enough and “the results appear to be magic”.

<footer>
<cite>Obituary Steve Jobs http://www.economist.com/blogs/babbage/2011/10/obituary</cite>
</footer>
</blockquote>


乔帮主明明是一个不那么懂计算机的人，说出的关于计算机的话，却是那么的在理。计算机的英文是 computer，而 compute 是计算的意思，而且不是微积分这种级别的计算，算微积分叫做 calculate，算 1+1 叫做 compute。计算机原本就是只能做这么简单的计算，但是算得足够快，魔法就开始了。

接下来的几天，让我们一起见证奇迹。