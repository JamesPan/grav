---
title: '加速 Homebrew 批量安装应用的速度'
date: '2016-10-12 12:02'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Homebrew
        - Tips
header_image_file: 'https://ws4.sinaimg.cn/large/006y8lVagw1f8pctn4p54j30h309ltae.jpg'
comments: true
math: true
---

如果你是一个开发者，那么你拥有至少一台 Mac 的可能性大约是 1/4。如果你是拥有 Mac 的开发者，那么你使用 Homebrew 来安装和管理软件的可能性几乎 100%。

如果你恰好和我生活在同一个国度，头顶同一片天空，怨念同一堵墙，那么你使用 Homebrew 的 cask 子命令来管理 GUI 软件的体验，想必也是不那么愉快的。

于是我写了一个软件，自认为能够提升使用 Homebrew 批量安装软件时的体验。如果你开始感兴趣了，请继续往下看。如果对我的扯淡没兴趣想让我赶紧 show code，也可以直接访问 [JamesPan/tmux-parallel][2]。

===

## <a name="design-intention"></a>设计初衷

为什么我会写这么一个东西？当我们使用 brew 和 brew cask 安装软件之后，可以使用 list 子命令得到当前系统中通过 brew 安装的软件和这些软件的依赖。于是我们可以经过筛选之后得到一个软件列表，拿到其它 Mac 机器上去喂给 brew。

经过上面的操作之后，我们就成功把一大批软件安装到了其它 Mac 机器上了。然而现实总是让人措手不及。

![](https://i.imgur.com/5UVWQXu.png)

上图是我前几天试图安装一个叫 Vivaldi 的浏览器的遭遇。如果看到这里你的脸上浮现迷の微笑，你一定直到我在吐槽什么，以及我最后是如何成功安装 Vivaldi 的。

而这仅仅是安装一个软件的遭遇，试想如果你有十几个甚至几十个 GUI 软件，需要借助 brew cask 批量安装，会是一种怎样的体验。

## <a name="design-detail"></a>设计细节

brew 安装的都是 CLI 软件，基本上都是事先编译完成的二进制文件，统一托管在 <https://bintray.com/homebrew>，速度还是过得去的，如果感觉速度不给力还能替换为 USTC 的[镜像][1]。brew cask 就没有托管和镜像这回事了，基本上都是去软件的官网下载安装包，至于能不能访问官网，下载速度如何，那就只能听天由命。

如何改善 brew cask 的安装体验？我们先看看最常见的 brew cask 批量安装是怎么做的。

```bash
#!/bin/bash
apps=(evernote inboard macvim iterm2 intellij-idea pycharm)
for app in "${apps[@]}"
do
    brew cask install $app
done
```

我们先列出一个需要安装的软件清单，然后遍历清单依次安装。

显然这是一种效率极低的安装方式，就算在理想的状况下，安装进程不会因为网络或者其它奇怪的问题而中断，整个安装耗时也是所有软件下载安装耗时的总和，$T=\sum_{i=1}^n T_i$。

brew 不同于 apt 之类 Linux 上的包管理器的一个特性，就是安装软件的时候不会加上排他锁。换句话说，我们可以在两个终端中，同时使用 brew 安装软件。或许这种设计是考虑到 OS X 不同于 Linux 的使用场景。

无论如何，两个 brew cask 进程能够同一时间、互不干扰地工作，这真是帮了大忙了。如果能有一种办法，让所有 brew cask 命令同时运行起来，那么在理想的状况下，安装耗时不就下降到 $T=max(T_i)$ 了吗？

看到这里，或许有人会说，「啊，这个很简单啊，你在批量安装里头，给brew
cask 加上 & 让每个软件的安装命令都后台执行就好了」。

或许事情其实并没有看上去那么简单呢？

首先，brew cask 执行安装的过程中，可能是会请求用户输入密码或者其它信息的，这个问题需要考虑。其次，下载也是可能失败的，有时候这些失败通过简单的重试就能解决，有时候不得不改变数据包的传输路径，或者有时候根本就是本地保存的 Formula 文件过于陈旧，指向了一个不存在的下载地址，需要执行 brew cask update 才能继续重试。

看到这么多的异常需要处理，是不是感觉这件事情却是没有看上去那么简单了呢？

> 计算机科学领域的任何问题都可以通过增加一个间接的中间层来解决

这个问题也是一样的，我们可以通过引入一个中间层来巧妙地解决。这个中间层就是 Tmux。

对于每个要借助 brew cask 安装的软件，我们在 tmux 中单独开启一个 panel 来执行安装过程，安装成功后自动关闭 panel，安装失败时让用户选择重试或者结束。考虑到 tmux 的显示效果，每个 window 最多分成 4 个 panel，超过 4 个就开启新的 window。

![](https://i.imgur.com/od0sZoj.png)

有了这个方法，从安装 brew 到用 brew 安装软件的过程，就可以从串行变成下面这样的串行 + 并行，看起来是不是酷酷的样子？

![](https://i.imgur.com/8mmX4D9.png)

要说有什么遗憾的地方，应该就是这种安装方式没法做到像一个线程池一样，维持 N 个工作线程，然后每完成一个任务就从阻塞队列中读取下一个任务，只能是一次性开启 M 个进程并行执行一批任务，全部都完成之后才开始并行执行下一批任务。

于是这个任务的切分以及并行度的控制，只能由用户自行控制了，要是在一个任务中创建了成千上万的进程，把系统内核给玩坏也不是不可能的事情。

这或许就是 fork-join 模型和 master-worker 模型的差异吧。


[1]: https://lug.ustc.edu.cn/wiki/mirrors/help/homebrew-bottles
[2]: https://github.com/JamesPan/tmux-parallel

