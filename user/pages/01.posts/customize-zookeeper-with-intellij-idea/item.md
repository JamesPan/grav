---
title: '在 IntelliJ IDEA 中定制开发 ZooKeeper'
date: '2016-09-04 14:31'
comments: true
taxonomy:
    category:
        - blog
        - Study
    tag:
        - ZooKeeper
        - 'IntelliJ IDEA'
header_image_file: 'https://ws2.sinaimg.cn/large/72f96cbagw1f7hjh4ewsoj209g06074d.jpg'
---

这两天我尝试在业余时间做一个 Side Project，对 ZooKeeper 做一些修改来实现一个大胆的想法。之前也做过几个项目，但是没有一个系统是像 ZooKeeper 这样的基础设施，也没有一个项目的工具链像 ZooKeeper 这样陈旧，还在用 Ant 管理项目，用 Ivy 下载依赖，用 jute 定义 RPC……简直就是在逛古董店啊！

这里分享一下我在 OS X El Capitan 上构建 ZooKeeper 开发环境过程中增长的人生经验。

===

源码自然是从 [apache/zookeeper][1] 抓取，clone 下来之后先 `git checkout release-3.4.8` 把代码恢复到最新的 stable，然后以这个 tag 为基准拉出自己的开发分支。

IntelliJ 并没有提供 Ant 项目导入，默认只支持 Maven、Gradle 和 Eclipse 等几个还有活力的项目管理工具。

![](https://ws1.sinaimg.cn/large/72f96cbagw1f7hi9jzeuzj20l104p0t0.jpg)

既然我们不能 Import，就只能 Open 了，直接用 IntelliJ IDEA 去打开项目所在的目录。这时候 IDEA 会认为整个项目里的文件都是普通文本，并不能识别出这是一个 Ant 管理的 Java 项目。我们需要给 IDEA 一些信息。先配置一下 Ant Build，让 IDEA 知道这个项目有哪些 Ant 任务。

![](https://ws1.sinaimg.cn/large/72f96cbagw1f7hitnip8kj20lu0b2gn8.jpg)

然后执行 `bin-package` 这个任务，先构建出一个 ZooKeeper 分发包，构建结果和下载下来的依赖都在 build 目录。

![](https://ws4.sinaimg.cn/large/72f96cbagw1f7hiwyqqe3j21600oxk1a.jpg)

到此为止，ZooKeeper 的服务端已经能够从 Ant 构建了，但是 IDEA 还没全完配置好，比如还没识别哪些文件是 Java 代码，也就会出现这样的情况。

![](https://ws1.sinaimg.cn/large/72f96cbagw1f7hj2b2xb2j20qf0ca42e.jpg)

这时候 IDEA 的 Project Structure 设置开始粉墨登场。

![](https://ws4.sinaimg.cn/large/72f96cbagw1f7hj4clflqj20sf08u75p.jpg)

这里也能看到 IDEA 只知道项目目录，不知道项目中哪些目录是 Source，哪些目录是 Resource。ZooKeeper 的目录那么多，项目结构我也不熟，要让我一个一个目录添加真是要命。于是我偷了个懒，先把项目目录从 Project Structure 中删了，再加回去，这时候 IDEA 就会帮我分析出有 Java 代码的目录。

![](https://ws1.sinaimg.cn/large/72f96cbagw1f7hj7k4x4kj20vk0q1dn3.jpg)

这目录也太多了啊，连 build 目录都给我加进来，真想对 IDEA 说一句「妈的智障」。我只好手动调整，把 build 目录排除，把带 test 的目录标记为 Tests，自动生成的目录标记为 Generated，如此这般就把 ZooKeeper 的代码目录结构整理清楚了。

![](https://ws1.sinaimg.cn/large/72f96cbagw1f7hjajqdhcj20vk0q1gqh.jpg)

如此这般之后就可以愉快地 Coding 了~

另外，我在 JetBrains 全家桶上又遇到了 Case Sensitive 文件系统带来的问题。一打开 ZooKeeper 项目就给我提示这个：

![](https://ws3.sinaimg.cn/large/72f96cbagw1f7hjdeqqf9j20a003nwer.jpg)

其实也简单，就按照提示里说的，去给 IDEA 加个启动参数就好了。在 `/Applications/IntelliJ IDEA.app/Contents/bin/idea.properties` 里追加 `idea.case.sensitive.fs=true` 即可。


[1]: https://github.com/apache/zookeeper