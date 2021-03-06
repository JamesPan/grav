---
title: 尝试以一种不那么「酷」的方式写博客
date: '2016-08-28 13:42'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Blogging
        - Grav
header_image_file: 'https://ws2.sinaimg.cn/large/7853084cgw1f79r5y55kmj218g0qugpf.jpg'
hljs: true
comments: true
---

也许你已经注意到，我的博客的样子变了。不管是变得好看还是不好看，总之是有了些变化。我大约在一年多前写过一篇 [博文][1]，记录当时给博客更换主题时的经历和思考。这一次就不仅仅是换个主题这么简单了，我更换了整个博客系统，将博客从 [Hexo][2] 迁移到了 [Grav][3]。

之所以会对博客做这么大的动作，其实是在两年的时间里使用静态博客生成器，能玩的花样基本上都玩了，但还是明显地感觉到一些不便（或者说是在折衷上有冲突），想要在一个新的世界里开始新的折腾之旅。

===

几年前我还在上大学的时候，无意中看到一篇译文，似乎是「[像黑客一样写博客][4]」，当时就被带上了车，开始接触以 Jekyll 为首的一众静态博客生成器。念书那会能写的东西也就仅仅是在「刷题报告」，把在 OJ 上通过的水题的代码、题目、链接给贴一下，以便日后查找。工作之后听说 Jekyll 在文章积累到达一定数量之后会遭遇性能问题，生成一次站点需要好几分钟，于是我在自建博客的时候就用了 Hexo 这个使用 Node.js 实现的引擎，据说 Hexo 会在文章数量超过 1k 的时候遭遇性能瓶颈，不过管他呢，我的文章要到 1k 还早得很，到时候大不了还可以换 Hugo。

我们基本上可以看到一个有趣的现象，静态博客生成器生成全站的耗时，会随着文章数量的增多而线性增长，（大部分时候还会随着插件增多而线性增长），这个耗时是博主能够切身感受得到的。而且作为静态博客生成器本身，在延缓生成耗时的增长上无能为力，只能靠抛弃旧引擎，换一个使用更加底层的语言开发的新引擎来实现站点生成耗时的大幅度缩减。

而一门语言，是能够在很大程度上决定用这门语言开发的软件，拥有哪些特性的。语言作为软件生态圈的基石，决定了框架的使用难度和扩展难度。同为解释型语言的 Ruby 和 Node.js，想要实现插件化的设计相对来说是比较简单的，插件还可以使用和引擎本身相同的语言开发，这对于想要为生成器添加扩展的用户来说能够减少不少学习成本。而一门语言是否拥有靠谱的中央仓库，是否有足量的高质量第三方类库，则会直接影响用户为引擎开发扩展插件的意愿（是的我就是在黑 Golang）。甚至一个引擎是否被各大 Pages 服务所支持，也能影响用户最终选择哪个引擎来生成站点。

[StaticGen][5] 是一个记录了流行的静态站点生成器的网站，本身也是一个静态站点。通过对比可以发现，Jekyll 使用 Ruby 实现，被 Github Pages 默认支持。Hexo 使用 Node.js 实现，Hugo 使用 Golang 实现。除了 Jekyll 可以被 Github Pages 等服务直接渲染，其他引擎都需要我们先生成站点再推送到 Pages 服务。

一开始的时候我受到 [像黑客一样写博客][4] 这篇文章的影响，觉得把博文做版本控制然后托管在 Github，然后能在本地用自己喜爱的编辑器写博客真的是一件很酷的事情。对博文做版本控制可以理解，比如可以避免引入预期外的修改，可以用代码对博文做批量的转换等等，但是「自己喜爱的编辑器」是个什么东西？

一开始的时候我宣称自己喜欢 Emacs，也曾经给 Emacs 加各种酷炫的插件，但是实际上我并没有掌握 Emacs 的精髓，没能生活在 Emacs 中。我在工作中需要写 Java 和 Python，哪怕是 Python 也得面对几十万行代码的大工程，好几个项目好几个虚拟环境来回切换，这使得我十分依赖 IntelliJ 和 PyCharm 强大的索引和自动提示功能，甚至在 IDE 的加持下我不再需要去翻阅类库文档和记住语言的核心类库的核心 API（曾经我也尝试过使用 Dash 来查看文档，但是自从我开始使用 JetBrain 全家桶之后，我就再也不需要 Dash 了）。操作开发环境的数据库我用的是 DataGrip，这样才能不至于让数据库配置分散在各个 IDE 的许多个项目中。如果离开了 JetBrain 全家桶我不知道我的开发能力会下降到什么程度。Vim 我用了这么多年，也就是在服务器上修改几行代码的能力，代码改动多了我还是只能在 IDE 里写好再贴回服务器里。所以说，我喜欢的文本编辑器是什么？也许从来就没有一个我喜欢的编辑器，只能说是我最近在使用的编辑器。前些日子是 Sublime Text，最近几个月是 VS Code。

工作两年来我的认知一直在变化，其中一个改变是终于认识到，人们只关心你做出了什么成绩，以及做出这些成绩时的思考和方法，至于具体用的什么工具，nobody cares。曾经我会觉得只用 Vim 和 Emacs 做开发的人都是高手，能除了浏览器不使用其他 GUI 程序工作的人也是高手，因为我始终没能做到这么 Geek 的事情。如今便不会这么认为了，虽然在网上还经常自黑不会用 Git 只会用 SourceTree，但是不会用这些工具又怎么样呢？只要我还有设计和实现系统的能力，还有解决问题的能力，还有帮助同行的能力，就足够了。不再因为会用一个工具而沾沾自喜，不再因为别人会用一个工具而高看一眼，不再因为不会用一个工具而妄自菲薄。

也许之前将会用什么工具作为个人能力的一部分，是因为念书的时候能体现一个人具体能力特别是工程能力的机会少得可怜，只好在工具上进行无谓的攀比。

言归正传。用了 Hexo 这一年多我也没有什么别的，大概三件事：

+ 一个，开发了 [hexo-ruby-character][7]
+ 第二个，开发了 [hexo-filter-indicate-the-source][8]
+ 第三个，给我的博客加上了自动部署和高可用部署

如果说还有一点什么成绩就是分享了一个照片流插件！这个插件还是有几个网友在用的。还有把评论系统从多说迁移到 Disqus 也是很大的，我应该是国内最早干了这事还把迁移脚本分享出来的人了。但这些都是次要的，我主要的我就是三件事情，很惭愧，就做了一点微小的工作，谢谢大家。

是啊，给博客上高可用，除了我估计也是没谁了。为什么当初会玩这么一手，如今又不在乎是不是高可用了呢？其实很简单，为了学习而搭建的复杂架构，学会了之后就成了负担。当时做自动部署是因为不想要把更新博客的能力局限在拥有完整 Hexo 环境的一台电脑上，做了自动部署之后，我只要在 Github 上直接修改文件，Travis CI 就会从 WebHook 感知到更新事件，然后走自动部署流程。

做高可用则是当初为了学习 Docker，买了一台服务器，把博客的静态文件完整打包到 Docker 镜像之后手动部署到服务器上。后来觉得这样子部署太麻烦，就在服务器上部署了个 WebHook 去感知 DockerHub 的更新，然后自动拉取最新的镜像部署博客。一台服务器挂了就挂了，为了学习实践前端机的高可用，就再买一台异地的服务器，号称「双活」。

这么做了一套下来，整个博客部署链路引入了 Github、Travis CI、Docker Hub 等三个外部依赖，其中一环出现问题都会影响博客的部署，最困扰我的当属 Travis CI。由于我没买 Travis 的收费套餐，我这个自动部署的 CI 和许多许多的开源项目共享一个 CI 资源池，每到夜里和早晨，都能感受到明显的构建延迟，Travis CI 的回归任务迟迟不启动，最夸张的一次是我深夜里写好了文章，第二天早上起床了还没给我部署好。从那时起我就开始怀疑我是不是没有按照正确的方法在使用 Hexo，给本应该简单的静态博客做了这么复杂的架构以至于走火入魔。

另一个让我感到不安的，是我写博客的方式的改变。从表面上看，我把博文托管到了 Github，本应是便于协作，至少是方便我在多设备上编辑的。其实并不是这样。移动设备上并没有一个真正好用的 Github 客户端，我要想直接在 Github 上开写是比较不便的。另一个则是 Hexo 设计上的取舍，Hexo 使用 `_drafts` 目录来存放未发布的草稿，在草稿完成后，需要将博文所在文件从 `_drafts` 移动到 `_posts`，最好用 `hexo publish` 指令来完成这一动作，然后才能走站点生成、发布等流程。这样复杂的发布流程是在不便于在移动端操作，况且我每保存一次，Travis CI 就会被触发一次自动部署，写一篇博文少说得保存个几十几百次，这 Travis CI 任务堆积的画面不要太美。于是最后我用了什么方式来实现多设备同步编辑博文呢？我用了一个叫 Letterspace 的 iOS App，它会在 iCloud 的某个 Inbox 目录(iCloud Drive/Letterspace/Inbox)里新建文件，在该目录里创建的文本文件也能被 Letterspace 识别，于是我就用它作为移动端编辑器，写博文的时候先在 Inbox 目录里创建文件，然后巴拉巴拉写，在电脑上用 VS Code 写，如果没写完就得出门，那就在路上在空闲的时候用 Letterspace 接着写。写好了再回到 Hexo 管理的博客目录下，走一遍 `hexo new`，`hexo publish`，`git add`，`git commit`，`git push` 的过程，然后祈祷 Travis CI 不要堵住赶快给我把 Docker Image 给构建出来。

号称简洁轻巧，让用户像一个黑客一样写博客的静态博客生成器，被我用得如此繁琐不堪，每当我发布一篇文章，或者修改一个页面的时候，我一点都没感觉我像一个黑客，反而更像一个傻逼。

前几天我在网上随意搜索了 "flat file cms"，第一个结果就指向了 [Grav][3]。翻了一下例子和文档，感觉还行，至少后台做的不错，前台也有不错的主题和模板，就是它了！我的服务器上没有 PHP 环境，照例还是要用 Docker 搞一个。因为之前没用过 PHP，更没在 Docker 里用过 PHP，整个过程还是有点折腾的，特别是文件权限问题，搞得我在本地跑的好好的镜像，到了服务器上就缺胳膊少腿的，这个以后再说了。

博客系统换就换了，不能换的是博文的链接。如果链接变了，或者之前的链接全部 404 了，不仅之前辛苦 SEO 全白费，还会导致其他问题，甚至站点被搜索引擎惩罚降低权重。还好 Grav 提供了 [Routing][9] 机制，让我可以比较轻松的在迁移博文的时候按照规则给原来的博文指定类似于 <https://blog.jamespan.me/2016/08/18/grand-theft-auto-v-a-new-world> 的链接，虽然我实际上上并不喜欢这种把博文发布日期放在链接中的做法，也许这是 Hexo 为了让生成站点和 Jekyll 保持一致而使用的默认配置，当时我不明就里的掉进坑里了。现在的我更倾向于使用 <https://blog.jamespan.me/posts/grand-theft-auto-v-a-new-world> 这样的链接。

当然除了链接，博文的评论也很重要，也要迁移过来。我用的评论系统是 Disqus，给 Grav 加上 jscomments 插件之后，就可以开启 Disqus 评论。在迁移脚本里给每个博文按照规则生成 jscomments 的配置，其实就是指定 Disqus 的 identity，url，title 之类的参数，然后原来的评论就都过来了，轻而易举。

```
jscomments:
  id: /2015/11/15/bloging-the-docker-way/
  title: 博客以及反向代理的容器化
  url: http://blog.jamespan.me/2015/11/15/bloging-the-docker-way/
routes:
  aliases:
  - posts/bloging-the-docker-way
  default: /2015/11/15/bloging-the-docker-way
```

过一段时间我再整体用代码去处理一遍博文，把调整路由策略，把带日期的链接 301 重定向到 不带日期的链接，就完成了新老链接的更替。我使用一个叫 `python-frontmatter` 的类库处理博文的 frontmatter，就是文章开头那一段 YAML 配置。

部署完成之后照例要用 ab 压测一把，看看站点能承受多少并发，压挂之后多久能自动恢复。之前用 Nginx 部署的静态博客那可是很能扛的，几千并发网站都不挂，只是 1M 小水管打满而已。然而我的这个用 PHP7 做后端的新站点，100 并发直接打挂。不过话说回来，我的博客现在的流量，QPS 连 1 都没到，要那么能扛做什么，真要碰上谁闲着蛋疼 DDoS 我的博客，把带宽打满和把服务打挂，好像并没有什么区别。

![](https://ws1.sinaimg.cn/large/7853084cgw1f79ecjmdr7j20qd05sabr.jpg)

总之，我暂时不用 Hexo 作为博客生成器了，我也不是在安利 Grav，毕竟这玩意我也才用，部署起来也没官网上宣传的那么简单，或许是我用 Docker 部署的姿势不对吧。要说 Grav 没坑也是不可能，碰到一个解决一个吧。比如我发现 Grav Admin 提供的 Mardkown 编辑器，大部分时候都工作良好，就是快捷键比较烦人，居然和 macOS 自带的 Emacs Style 的光标移动冲突了，我只好简单粗暴地修改了 Grav Admin 插件的源码，把编辑器的快捷键注册的代码给删了。

好吧，其实我并不想告诉你，我现在开始用 PHPStorm 了，为了给博客写插件，改代码。我发现 PHPStorm 的 Deploy 功能挺好用的，配置好目录映射之后，我可以直接把我修改的文件推送到服务器，还可以把服务器上有变化的文件按需拉回本地。我并不是不知道 rsync，实际上我在工作中经常用 rsync，只不过在这个场景里面，IDE 提供的功能更好用一些。

我爱 JetBrain 全家桶。

[1]: https://blog.jamespan.me/2015/04/28/scalability-and-cost/
[2]: https://hexo.io/zh-cn/
[3]: https://getgrav.org
[4]: http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html
[5]: https://www.staticgen.com
[6]: https://github.com/ppoffice/hexo-theme-icarus
[7]: https://github.com/JamesPan/hexo-ruby-character
[8]: https://github.com/JamesPan/hexo-filter-indicate-the-source
[9]: https://learn.getgrav.org/content/routing
