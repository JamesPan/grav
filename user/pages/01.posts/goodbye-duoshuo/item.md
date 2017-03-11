---
cc: true
comments: true
date: '2015-04-18 16:47:06'
jscomments:
  id: /2015/04/18/goodbye-duoshuo/
  title: 告别多说，拥抱 Disqus
  url: http://blog.jamespan.me/2015/04/18/goodbye-duoshuo/
routes:
  aliases:
  - posts/goodbye-duoshuo
  default: /2015/04/18/goodbye-duoshuo
taxonomy:
  category:
  - blog
  - Study
  tag:
  - Python
  - Tool
  - Blogging
title: 告别多说，拥抱 Disqus
---

## 背景 ##

一开始搭建博客的时候，直接套用了 Pacman 主题，它自带了多说评论插件，所以我就注册了一个帐号，然后就这么用着。

这两天我把博客环境升级到 Hexo 3.0 之后，由于一些 API 的不兼容，导致我生成的文章唯一标识符和之前的不一致了，然后好多文章的评论就显示不出来。

我尝试着去 hack 这些有变化的 API，把文章唯一标识符恢复成原来的样子，结果在新的标识符下的评论，又没法显示了。按下葫芦又起瓢，简直不能忍，只好去多说后台做修改。

多说后台有一个严重的问题，文章管理界面始终没法翻页，不管我有多少篇文章，页面上只给我显示一页的内容，后面的全部截断抛弃。当我在页面上删除了一篇文章，实际上它并没有被删除，假如我添加一篇一样的文章，使用一样的文章唯一标识符，它会阻止我继续操作。

===



之前我一直将就用着，今天终于给多说这个充满漏洞的评论系统跪了，除了支持新浪微博，找不出半点好。可见一个应用哪怕再烂，只要“接地气”，多弄一些天朝特色，还是能让用户将就这用的。

我决定把评论系统切换到 [Disqus][1]，即使可能会丢失全部的评论数据，我还是决定和多说一刀两断。

## 切换 ##

整个切换过程其实很简单，在 Disqus 注册，然后在 [Settings/Admin][3] 中新建站点，接下来就是一步一步跟着向导程序走下去，把 Disqus 提供的 脚本放在指定的位置即可。

为了拥有更好评论一致性，建议直接使用第二步中提供的 JavaScript 脚本，为每篇文章指定唯一的 identifier，固定的 title 和 url。

为了更好的显示效果，我们还需要为 Disqus 的评论框添加样式，我直接参考了 [Morris' Blog][4] 博文《[解決 Hexo Comment !][3]》。

到此为止，博客已经可以很好的显示评论了。考虑到国内注册 Disqus 的人没有注册微博的那么多，我调整了设置，允许访客留言。不过我还是希望读者能够花几分钟注册，毕竟这个是全球最大的评论社区，加入社区怎么看都是有好处的（虽然是一个以英文为主的社区，但是我们作为开发者，如果连这种程度的英文都头疼的话，恐怕离天花板也不远了）。

## 迁移 ##

人是一种不懂得满足的生物。用上 Disqus 之后，我得寸进尺的想要把之前在多说的评论也迁移过来。

多说提供了导出的功能，能够把整个站点的文章列表和评论列表导出来，以 JSON 格式存储[^1]。

[^1]: [多说导出的评论文件说明][5]

然而 Disqus 的导入功能，支持的是 WordPress 导出的 XML 格式的文件[^2]。

[^2]: [Custom XML Import Format][6]

两种格式之间的转换，似乎只有从 Disqus 到多说的转换，我想要的转换没有现成的轮子可以使用，只好亲自动手。

整个转换的过程无非就是加载 JSON 文件，解析成哈希表，然后遍历哈希表生成“文章-评论”这样的一对多的组合关系，最后遍历这样的关系生成目标格式的文件。

解析 JSON 直接使用标准库即可，多说导出的 JSON 还是比较标准的，没有语法错误。整个过程也就输出到 XML 的时候麻烦一些。之前只用过 [lxml][7] 解析 XML，生成 XML 还是头一回。

在[官方文档][8]的帮助下，我顺利的把轮子造出来了。

多说导出的评论比较混乱，有些文章的链接居然还是指向的 localhost 或者其他的内网 ip，也是醉了。转换了格式不算，还得人工审查，幸好现在博文还不是太多，要是有几百篇博文非得被玩坏不可。

<del>如果我有时间把这次写的脚本整理成一个命令行程序，就单独再写一篇博客分享出来。</del>

这次写的脚本在《{% post_link the-duoshuo-migrator %}》有详 (jiăn) 细 (lüè) 的介绍，欢迎使用~

[1]: https://disqus.com
[2]: https://disqus.com/admin/
[3]: http://morris821028.github.io/2014/04/12/web/hexo-comment/
[4]: http://morris821028.github.io
[5]: http://dev.duoshuo.com/docs/500fc3cdb17b12d24b00000a
[6]: https://help.disqus.com/customer/portal/articles/472150-custom-xml-import-format
[7]: http://lxml.de/index.html
[8]: http://lxml.de/tutorial.html