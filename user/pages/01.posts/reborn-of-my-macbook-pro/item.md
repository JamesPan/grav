---
title: '回炉重炼我的 Macbook Pro'
date: '2016-09-02 14:29'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - 'OS X'
        - Mac
        - Homebrew
header_image_file: 'https://ws3.sinaimg.cn/large/006y8lVagw1f7f8phpzblj30rd06a770.jpg'
comments: true
---

前几天我把我的 Macbook Pro 全部格式化然后重装了系统。其实我想做这件事情已经很久了，但是一直都没有什么事情让我下定决心，毕竟重装一个用了两年多时间里一点一点积累起来的系统也是挺有风险的一件事情。直到前天晚上发生了一件事情，让我痛下决心，把系统砍掉重练。至于具体什么事情，可以看我的博文「[想从我这骗钱？报警抓你哦][1]」。

===

重装 OS X 还真是费了一番功夫，先从数据备份说起。OS X 默认只划了一个分区，因此格盘之前需要记得把不希望丢失的数据备份到外置存储，比如电影、图片、音乐、文档，还有我的各种项目源码。基本上就是把家目录下的几个目录复制到外置存储就万事大吉，但是我万万没有想到的是，我之前有使用 Inboard 做图片收集，而 Inboard 的存储不在 `~/Pictures` 目录，而是在 `~/Library/Group Containers/AN5MJ93DEM.com.ideabits/Inboard/` 这犄角旮旯里，我一不小心就忘记备份了，为此丢失了 Inboard 中收集的图片。不过万幸的是，Inboard 中收集的图片其实都是我我博文中使用的图，当初是为了防止图床作废才在 Inboard 中保存一份，如今我博文中用到的图片已经很多了，就算图床作废我也没有精力去给他们换个图床，就由它去吧，就算能从之前的时光机备份中捞回来，我也懒得去捞了。

Mac 电脑提供了一种被称为 [Recovery Mode][2] 的模式，可以通过在开机过程中按住 Command-R 进入，然后可以做格式化硬盘、重装系统之类的工作。我有一点不确定，这个重装系统，是会给我安装最新版本的系统 El Capitan，还是出厂时的 Mavericks。为了以防万一，我决定先刻录一个 El Capitan 的安装盘。

![](https://ws3.sinaimg.cn/large/72f96cbagw1f7ek7rn2vuj21kw14ikba.jpg)

从 App Store 下载来最新的 El Capitan，然后插上 U 盘，在终端输入命令如下，就可以等待漫长的 U 盘刻录了。

```
sudo /Applications/Install\ OS\ X\ El\ Capitan.app/Contents/Resources/createinstallmedia --volume /Volumes/<device> --applicationpath /Applications/Install\ OS\ X\ El\ Capitan.app --nointeraction
```

实践表明，Recovery Mode 是能够安装最新版本的 OS X 的，只不过它会联网下载安装镜像。为了加快重装速度，我选择了重启时长按 Option 进入 U 盘装机模式。在格式化磁盘的时候，我选择的文件系统是 Mac OS Extended (Case Sensitive, Journaled)，aka HFSX。我知道 OS X 默认的文件系统是不区分文件名大小写的 OS X Extended (Journaled)，但是我实际上更青睐 Linux 上区分文件名大小写的做法，而且我曾经在 Mac 上因为文件名大小写的问题折腾了好一会，算是被不区分大小写的文件系统坑过。据说 [一些软件][3] 无法在 HFSX 下工作，但是也还好，这些软件我估计是用不到的。

安装好系统之后我自然是做一些配置修改，把文件从外部存储挪回到内置硬盘之类的工作。就在这时我发现我之前备份数据时遗漏了 Inboard 的图库。痛定思痛，我觉得对于这种把数据存放在犄角旮旯的软件，以后还是少用为妙。最好是能让我把图库存储位置给指定在 iCloud Drive 里头，这样我不但不担心重装系统导致数据丢失，还可以获得在多个设备上同步的便利。

为此我寻寻觅觅，终于找到一个稍微靠点谱的图库管理 App，Pixa。其他的竞品比如 Ember 在同步功能上都不太靠谱甚至还把本来就聊胜于无的同步功能给砍了，只有 Pixa 能直接把图库给指定到 iCloud Drive 中。至于为什么我用 iCloud Drive 而不是 Dropbox 或坚果云之类的同步盘，其实是我被乔帮主那句 "Dropbox is a feature, not a product" 给安利了，每个月花 6 大洋订阅 iCloud Drive 的 50G 套餐。虽然 iCloud Drive 在同步盘的功能上比起 Dropbox 还逊色不少，但是 iCloud 又便宜又是系统自带特性还不被墙，适合我这种懒癌晚期患者。

之前我对待安装 App 这种事情的态度是，只要能用 Homebrew Cask 安装的，就坚决使用 Homebrew Cask 安装。但是前些日子 Homebrew Cask 又做了一次不兼容的修改，把 Caskroom 给换了个位置，让我感觉这东西很不靠谱的样子，三天两头变一下的折腾死人。于是这次我的态度发生了变化，只要能用 App Store 安装的，就坚决使用 App Store 安装。

![](https://ws1.sinaimg.cn/large/006y8lVagw1f7f6s1a253j31kw0zkwsg.jpg)

![](https://ws1.sinaimg.cn/large/006y8lVagw1f7f6stiecuj31kw0zkan1.jpg)

这些就是我目前安装的 App 了，之前搞的什么 Mathematica，Matlab 之类的，两年下来除了做毕设那会用了一下，后面就再也没用过了，于是我也就顺势清理了一下还在用的 App，不用的就不装了。

出乎意料的是，使用 Case Sensitive 的文件系统带来的不兼容问题，这么快就会遇到。Etcher 是一个颜值不错的 ISO 镜像烧录软件，我之前有用它在 Mac 上刻录 Linux 的 LiveCD。

![](https://ws2.sinaimg.cn/large/006y8lVagw1f7f6y1x652j31eo0rc41g.jpg)

安装过程中出现了莫名其妙的错误。

![](https://ws1.sinaimg.cn/large/006y8lVagw1f7f72sscvgj30ft03bjsc.jpg)

幸运的是这个错误我还能 hold 得住，通过修改 Etcher 的 Formula 搞定。要是遇到我搞不定的情况再找办法把文件系统换成大小写不敏感的好了。于是我顺手给 Homebrew Cask 提交了个 [PR][5]，如果能顺利合并那我也是给 Homebrew 做过贡献的人了哈哈哈。

![](https://ws3.sinaimg.cn/large/006y8lVagw1f7f7642l3ij309b05aaaq.jpg)

还有就是我现在的博客使用微博作为图床。曾经有一段时间我使用 imgur 作为图床，因为微博不支持 https 协议的图片外链。前些日子无意中发现微博图床支持 https 了，但是支持的方式比较别扭，需要按照如下规则对 http 的图片链接做修改。

对于一个 url pattern 为 `^http://ww(\d).sinaimg.cn/(.+)$` 的图片，我们需要将其修改为 `https://ws$1.sinaimg.cn/$2`。这些日子我厌恶了手动做这样的替换，就想着能不能有什么软件自动化地帮我把这个事情给做了。于是我找到了被我冷落已久的 [ClipMenu][4]。这个开源的剪贴板管理工具有一个强大的功能，就是能让用户通过 JavaScript 去实现一些 Action 来完成剪贴板内容的自动化处理。比如我就写了一个简单的脚本来实现了微博图床的 url https 化。

```js
var url = clipText;
url = url.replace(/^http:\/\/ww/, "https://ws");
return url;
```

然后把我的这个脚本绑定到 Command+Click 这个组合键上，就能够以比较轻快的方式实现自动替换了，只需要按下 Command+Shift+V 呼出 ClipMenu，然后按数字键高亮选中要粘贴的内容（用鼠标选也一样），最后 Command+Enter 或者 Command+Click 用绑定的 Action 去操作剪贴板内容并粘贴出来。

后记：

这篇博文写于重装系统之后，完全使用 Grav Admin 的 Web Editor 编辑，抛弃了之前使用 Hexo 时遗留的使用本地文本编辑器与同步盘配合的策略。原博客归档不再更新，托管于 Github Pages 服务，可以通过 <http://blog-archive.jamespan.me> 访问。

[1]: /posts/i-will-call-the-place-if-you-fraud-me
[2]: https://support.apple.com/zh-cn/HT201314
[3]: http://apple.stackexchange.com/questions/46322/what-programs-have-trouble-with-case-sensitive-hfsx-filesystems-and-how-to-fi
[4]: http://www.clipmenu.com
[5]: https://github.com/caskroom/homebrew-cask/pull/24219



