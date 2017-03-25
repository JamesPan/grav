---
title: 给博客的照片流添加过滤器
date: '2017-02-01 21:42'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Grav
        - Hexo
        - JavaScript
header_image_file: 'https://ws1.sinaimg.cn/mw1024/e724cbefgy1fcbauul7smj20l90gqan9.jpg'
comments: true
hljs: true
---

许久之前我分享了一个在 Hexo 博客中制作照片流的[方法][1]，至今这个照片流已经成为了我的博客中更新最频繁的页面，承载着我对那些曾经浪费我生命的美好事物的回忆，一开始是书籍和动漫、电影等影视作品，如今还多了个游戏，毕竟游戏继电影之后，也被归为艺术之列，号称「第九艺术」。

我对照片流这个功能是如此的喜爱，以至于我将博客从 Hexo 迁移到 Grav 之后，之前为 Hexo 开发的几个插件都被我放弃了，唯一一个被我移植到 Grav 上的，就是照片流。当然也有一部分原因是移植照片流的工作十分简单，以至于我只需要借助 Twig 模板的宏定义功能就能轻松搞定。

===

将照片流迁移到现在的博客上之后，我又充分发挥 Grav 强大的后台功能，将照片流的数据和样式完美分离。样式部分是一成不变的 Twig 函数调用，数据部分则抽取成一个 YAML 配置文件，配合 Grav Admin 强大的 blueprint 功能，我在 Grav 博客的后台实现了一个可视化编辑照片流的功能。

![](https://ws1.sinaimg.cn/mw1024/e724cbefgy1fcb9out20vj210a0jr0v5.jpg)

于是我终于可以不用再直接编辑那面目可憎的源文件了，终于可以从「复制、粘贴、复制、粘贴」这种具体的文本编辑行为，升级成「新增、粘贴、粘贴、粘贴」这种更加抽象的内容管理行为。这小小的变化，不由得让人感叹 GUI 的伟大，让简单的事情变的更加简单。

今年春节回家，和一位叔叔交流最近看了什么书。叔叔用涂书笔记来记录看过的书，我因为有博客就不会用其他的应用来记录这些东西了。但是交流的时候有点尴尬，我展现的内容混杂了书籍、电影、动漫、电视剧甚至游戏等各种各样的东西，很容易就让人迷失在这茫茫图海之中，而且看一本书花的时间比看一部电影多了去了，把不同的内容混在一起，就显得我看了很多电影但是没看几本书。但是实际上我今年（2016）有记录的看完的书，包括电子书和纸质书，至少 53 本，绝大部分是专业领域的书籍，少量涉猎畅销书。但是感觉还是让叔叔感觉我没读什么书的样子，好气啊！

其实之前同事让我推荐几本技术书的时候，我就发现我之前设计的照片流，缺失了一个重要的功能：按内容类型过滤！其实这个真的很简单，但是当时我从照片流中翻出最近看的几本好书发给同事就过去了，又来也没深究，如今看起来也是得加上了。

因为不想在 Grav 后端上大动干戈，我就在前端用 JQuery 随便写了个脚本，解析 URL 中的参数获取想要过滤出来的类型，比如 book 或者 movie 之类的，然后根据参数自动把照片流中非指定类型的 figure 元素给去除。

```javascript
$(function() {
  if (window.location.hash) {
    do {
      var mapping = {
        'book': ['book.douban.com', 'www.oreilly.com', 'www.amazon.cn'],
        'movie': ['movie.douban.com'],
      }
      var filter = window.location.hash.substring(1);
      var domains = mapping[filter];
      if (domains == null) {
        break;
      }
      $('figure').each(function(i) {
        var url = $(this).find('a')[0].href;
        var hostname = (new URL(url)).hostname;
        if ($.inArray(hostname, domains) < 0) {
          $(this).remove();
        }
      });
    } while(false);
  }
});
```

代码如此糙快猛以至于没什么好说的，够用就好~

其实 Hexo 版本的照片流还是有一些同行在用的，有些 Hexo 玩家还把它魔改出了自己的风格，比如 [这里][2]。这位博主看起来也有分开展示书籍和电影的需求，于是就把电影和书籍用两个照片流分别记录了，这种策略在元素较少的时候也不失为一种可行的解决方案。

[1]: https://blog.jamespan.me/2016/01/28/show-your-favorites-collection-in-hexo
[2]: https://monniya.com/favourite/
