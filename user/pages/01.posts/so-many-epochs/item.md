---
title: 'Epoch 知多少'
date: '2016-10-05 16:10'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - 'OS X'
header_image_file: 'https://ws4.sinaimg.cn/large/006y8lVagw1f8hgiuve5mj30m709jabu.jpg'
comments: true
---

国庆假期的头三天去朋友家做客，感受了一下富二代「奢靡腐化」的生活。但是，作为一个想要成为 PPT 架构师的好程序员，即使在假期里，也是要写代码的，这一点古今中外概莫如是。

<blockquote>
<p>我是个程序员，今天我休息。猜猜我在干嘛？虽然我很想告诉你我在巴哈马享受鸡尾酒，但实际上我休假的时候还是在写代码。</p>

<p>因此所谓的“休假”只是对 HR 来说的——我只是放下工作，好专心让我的游戏重新上线。这个游戏我写了快 10 年，开发的时间差不多有 7 年。这个游戏下线已经好一段时间了，现在重新上线，部分原因是为了摆脱那些一直追在我屁股后面的玩家。这至少要花一个星期，所以我只好休一星期的假来搞定它。</p>
<footer><cite>Steve Yegge，程序员的呐喊</cite></footer>
</blockquote>

===

至于我这两天写了什么，都在「[准备再次尝试用 OmniFocus 记录工作并生成周报][1]」这篇博文里了。之所以不把代码放出来，是因为我觉得这脚本写得太糙快猛，就这么大咧咧的放出来，有损我准 PPT 架构师的光辉形象。

然而事实证明我不把代码放出来实在是太机智了。到目前为止，我都是用 AppleScript 及其周边技术来实现从 OmniFocus 生成周报的，为了知道 ScriptingBridge 返回的对象有哪些属性哪些方法，还得安装 Xcode 然后参考 [这里][2] [那里][3] 搞到了最新的 `OmniFocus.h`，这才算是把接口搞清楚了，要不然靠着反射去猜哪些方法是 OmniFocus 的哪些方法是框架自带的，简直要命。

今天我无意中发现了 [OmniFocus 用 SQLite 来持久化数据][4]这一惊天大秘密，就想着可以找时间把我的周报生成器重写了，绕过 AppleScript，直接读取 SQLite。

于是我把 OmniFocus 的数据库拷贝出来了一份，先看看表结构。

![](https://ws2.sinaimg.cn/large/006y8lVagw1f8hfocvpavj31kw1f615h.jpg)

在生成周报这个需求里，因为是周报，以完成时间为分割线，所以 dateCompleted 这个字段是一个需要重点关注的地方。

```
select dateCompleted from Task where projectInfo is NULL and dateCompleted is not NULL;

497156893.964988
497156894.558405
497156895.134153
497156897.265427
497156898.010303
497156898.714034
```

这查出来的一坨浮点数是个什么鬼！

一番探查学习研究提高姿势水平之后，我终于知道了这一坨浮点数是从 2001-01-01 00:00:00 +0000 到目标时间的秒数。

在之前六年多的计算机科学和软件工程生涯中，我用过的唯一一个从某一时刻到现在的秒数，就是 [UNIX 时间][5]，即从 1970-01-01 00:00:00 +0000 到当前时刻的秒数。然而 OmniFocus 给我上了一课，只知道 UNIX 时间是不够的，要想在 macOS 上愉快玩耍，还得知道「OS X 时间」，即从 2001-01-01 00:00:00 +0000 到当前时刻的秒数。

Wikipedia 的 [Epoch (reference date)][6] 页面告诉我们，这个世界上除了被广泛使用的 UNIX 时间，还有其他很多种纪元，比如 Microsoft Excel 使用的纪元从 [January 0][7], 1900 开始，MATLAB 纪元从 January 0, 1 BC 开始，Apple's Cocoa framework 则是之前说的，从 January 1, 2001 开始。

看得出来苹果还是蛮自恋的，不过敢认为 OS X 开创了 UNIX 之后的一个新纪元，这想法我很喜欢！

最后，要想从 OmniFocus 的数据库中查出本地时区下的完成时间，得这么来：

```
select datetime(dateCompleted + strftime('%s', '2001-01-01 00:00:00'), 'unixepoch', 'localtime') from Task where projectInfo is NULL and dateCompleted is not NULL ;
```


[1]: /posts/log-daily-work-and-generate-weekly-with-omni-focus
[2]: https://gist.github.com/cdzombak/4350fa979a24f75ea3de
[3]: http://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error
[4]: http://marc-abramowitz.com/archives/2011/03/08/accessing-omnifocus-data-as-a-sqlite-database/comment-page-1/
[5]: https://en.wikipedia.org/wiki/Unix_time
[6]: https://en.wikipedia.org/wiki/Epoch_(reference_date)
[7]: https://en.wikipedia.org/wiki/January_0
