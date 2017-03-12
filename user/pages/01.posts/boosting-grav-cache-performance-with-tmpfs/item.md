---
title: '使用 tmpfs 提升 Grav 缓存性能'
date: '2017-02-16 01:13'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Blogging
        - Grav
header_image_file: 'https://ws1.sinaimg.cn/mw1024/e724cbefgy1fcrnmmwyzcj21840m4tjp'
comments: true
---

前些日子我对 Grav Admin 的访问速度感到很不满意，经常打开 Dashboard 页面就给我来个 504 Gateway Timeout，不得不再刷新一次才能正常访问；甚至有一次我在编辑页面写了一大段文字之后，保存失败导致内容丢失，后来尝试再写也没法补全丢失的内容。这份不愉快让我萌生了寻找一个更厉害的博客引擎的念头。

但是基本上 Grav 已经是 [2016 年最棒的开源 CMS][1] 了，也就是说综合各个方面因素，没有什么比它更好的 CMS  可供选择。失望之余不免产生想要亲自动手造一个轮子，但是考虑到我已经废弃了原本就不怎么突出的前端能力，如今的我已经对实现一个靠谱的博客后台力不从心，这些冲动最终也只是想想而已。

===

![](https://ws1.sinaimg.cn/large/e724cbefgy1fcrnq75atej20u602k74n)

今天不知为何突然天马行空地设想一个牛逼哄哄的博客系统的架构，用 OSGi 实现插件化和插件的热插拔，博客内容和配置都放在 H2 内存库里，然后部署三个实例给 H2 组一个 Raft Group 做容灾，H2 主库上定时打快照做全量备份……

用 H2 给博客做数据库是什么鬼，现在的 CMS 要么就用 MySQL、SQLite 之类的关系数据库，要么就用 MongoDB 之类的 NoSQL，要么直接用 flat file，哪有人用 H2 这种 Java 生态里的内存关系数据库的，性能再好也没人用。

感觉好像发现了什么，数据全放内存里，性能会很好，不管是放在内存数据库，还是直接用哈希表，性能都很好。如果我把 Grav 依赖的文件系统也给放到内存里，Grav 的性能也会很好啊~

如果我把 Grav 操作的目录给替换成内存文件系统了，就会失去持久性，机器重启之后博文就丢失了，回到解放前；为了获取一定程度的持久性，可以定时把文件从内存文件系统用 rsync 增量同步到磁盘文件系统，唯一的风险是重启丢失一个定时周期的数据。

权衡再三，我选择了把 Grav 的 cache 从磁盘文件系统换成内存文件系统，其余目录保持磁盘文件系统不变，这样能获取一部分加速效果，而且是本应该很快但是没快起来的部分变快了，也不需要去做数据定时同步这样的脏活。

```
sudo mount tmpfs cache -t tmpfs -o size=120m
```

cache 是 Grav 的缓存目录，设定最大 120 MB，空间用完了在写文件的时候会报 `No space left on device` 这样的错误信息。

感觉是快了一些，然而并没有实验对比，具体快了多少也不知道，反正感觉是快了一些。

![](https://ws1.sinaimg.cn/large/e724cbefgy1fcrnrum85dj20wj04ajsg)

访问 Dashboard 暂时也不会遭遇 504 了，就这么用下去吧~

---

Update 20170218:

Grav 使用的缓存封装是 Doctrine Cache，这破玩意无法设定缓存空间大小以及缓存淘汰策略，这些全靠具体的缓存实现来做。具体到 FileCache 这个实现，磁盘空间用完了，Doctrine Cache 就会在尝试写缓存的时候抛异常，然后博客就挂了。

于是我只能很脏地用 crontab 写一个定时清理缓存的任务。

```
* * * * * [ $(du -s $cache-path/doctrine/ | awk '{print $1}') -gt 100000 ] && rm -rf $cache-path/doctrine/
```


[1]: https://www.cmscritic.com/the-winner-of-best-open-source-cms-for-2016-is-grav/