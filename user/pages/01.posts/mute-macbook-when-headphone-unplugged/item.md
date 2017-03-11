---
title: '拔掉耳机时自动将 Macbook 静音以避免尴尬'
date: '2016-09-06 22:11'
comments: true
taxonomy:
    category:
        - blog
    tag:
        - Tool
        - Mac
header_image_file: 'https://ws3.sinaimg.cn/mw690/801b780agw1f7k7ziaz02j20zk0k0n0o.jpg'
---

工作之后，我常常在写代码的时候带着耳机听歌。并不是我真的有多喜欢这些歌曲，我只是想有一些声响去帮我抵御工作环境的噪声。反正我就用流行的音乐服务随便听着，一开始是豆瓣电台，现在是在网易云音乐上跟着推荐的歌单列表循环。

在工作电脑上听音乐，拔掉耳机那一刻最危险，一不小心就迷の尴尬，将我那本就不高的音乐品味暴露在众人面前。如果 OS X 能像 iOS 那样，在拔掉耳机之后自动停止播放就好了。

===

至少 OS X 目前没有这种功能，也不知道是设计上故意不这么做，还是在不久的将来会加上。在得不到官方支持之前，我只好绕道实现需求了。

OS X 会分别记录电脑音响和耳机的音量，利用这个特性，可以实现插上耳机时功放，拔掉耳机静音。操作也很简单，在拔掉耳机的状态下，将电脑静音；然后插上耳机，将音量调至合适大小。

比较出乎意料的是，这个需求还有人专门写了 App 来满足。有趣的是，这种 App 有两个，名字都叫做 AutoMute。

第一个 [AutoMute][1] 全名叫做 "AutoMute - Preventing Awkward Situations"，防止尴尬时刻都写到名字里是什么鬼。反斗软件有相应的 [介绍][2]。

第二个 [AutoMute][3] 没有上架 App Store，作用是根据电脑连接的 Wi-Fi 网络，自动设置静音。对于只有一台电脑同时作为工作和生活实用的人来说这个功能有点用。


[1]: https://itunes.apple.com/cn/app/automute-preventing-awkward/id1118136179
[2]: http://www.apprcn.com/automute-2.html
[3]: http://lorenzo45.github.io/AutoMute/

