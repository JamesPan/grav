---
title: '用 Grav 搭建博客之后，我重新捡起了最好的语言'
date: '2016-09-29 23:53'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - NGINX
        - Grav
header_image_file: 'https://ws1.sinaimg.cn/large/801b780agw1f89tsfezyej20m80b4wf8.jpg'
comments: true
---

从之前那篇博文「[尝试以一种不那么「酷」的方式写博客][1]」开始算，我用 Grav 搭建的博客已经稳定运行了一个多月了。按照老规矩，我还是用 Docker 做部署，基础镜像还是我常用的 Alpine Linux。当然，我也因为用 Grav 搭建博客，学到了一些和最好的语言相关的人生经验。

===

为了尝试鸟哥呕心沥血的成果，我部署 Grav 用的是 PHP7。但是 PHP 一般不会单独部署，大多数时候都是作为 CGI 程序和一个 Web 服务器一起部署。大学时候我有部署过 WordPress，那时用的是 Apache 和 php_mod，这一次我用的是 NGINX。

NGINX 和 PHP 之间的通信，用 fastcgi 系列指令，这系列指令和用 NGINX 做反向代理时候的 proxy 系列指令很相似，可以类比认为是把请求给反向代理到 PHP 写的 CGI 程序上吧，然后 NGINX 也可以在请求 CGI 之前做缓存之类的。

```
fastcgi_cache_path /var/cache/nginx levels=1:2 keys_zone=fast-cgi-cache:100m inactive=60m;
fastcgi_cache_key "$scheme$request_method$host$request_uri";
fastcgi_cache_use_stale error timeout updating;

fastcgi_cache fast-cgi-cache;
fastcgi_cache_valid 200 301 10s;
fastcgi_cache_valid 404 60m;
fastcgi_cache_bypass $no_cache;
fastcgi_no_cache $no_cache;
fastcgi_ignore_headers Cache-Control Expires Set-Cookie;
```

之前有说过，刚部署 Grav 的时候性能很差，随便用 ab 压一把都能把 CPU 跑满。后来我研究了一下  `fastcgi_cache`，用 NGINX 在 Grav 前面挡了个缓存，性能就好很多了。一开始配置缓存的时候没注意失效策略，在缓存失效的一瞬间，如果有大量并发请求，还是会直接击穿缓存。

面对这种这种缓存击穿问题，我们在做应用的时候，也许会花一番功夫去设计失效和刷新时间，以及在更新缓存的时候用锁把并发请求挡住之类的。NGINX 里面不用这么麻烦，直接配置 `fastcgi_cache_use_stale`，在缓存更新期间还用之前的缓存就可以了，反正就是 GET 请求，拿到之前的缓存页面也没啥大不了的。

---

Grav 的插件生态也算是不错的，我就杂七杂八的安装了 26 个插件。当然这些插件、主题也不是完全让我满意，有些时候难免对它们魔改一番。

比如作为后台管理的 Admin 插件，我就对它的 Markdown 编辑器不太满意，乱七八糟绑定了一大堆快捷键，还和我常用的 `C-n`，`C-b` 系列 Emacs 风格的光标移动快捷键冲突了，害得我每次用 `C-b` 回退光标的时候都给我插入「加粗」。当时我就翻到了定义快捷键所在的 js 代码，然后咔咔咔给他删了个干净。那么问题就来了，我这么简单粗暴地修改了插件的代码，插件该如何升级？

我的答案很简单，不升级。虽然我知道这么做是政治不正确的，会错过很多 new feature，错过很多 bug fix，最终把我的博客系统暴露在危险之中。但是我无所谓，我用 Docker 部署 Grav，隔段时间仔细 diff 本地远程的数据目录仔细同步，就算真被攻击了也没啥大不了的。

但是每次登陆 Grav 后台，它都会去检查更新啊，看看 Grav 有没有新版本，插件有没有新版本，看得我心烦。于是我一不做二不休，直接把 Admin 插件里检查更新的调用给屏蔽了。

![](https://ws1.sinaimg.cn/large/801b780agw1f8auk3gjxej20yb07e408.jpg)

这就让我想到 Golang 那颇显怪异的依赖管理策略。和现代大多数语言用的依赖策略不一样，Golang 用第三方的代码，不是依赖动态库，而是直接依赖源码。这是一种被称为 Copy & Own 的依赖管理策略，它的好处是能够避免类似 Maven 带来的依赖冲突，同时避免 npm 带来的依赖冗余。但是它的坏处也是很明显的，把第三方代码复制到自己的源码树中，后续对依赖的升级、维护会成为一个比较棘手的问题，不再是通过简单地修改一个声明式的描述文件就能实现的。

另外，在整个软件的开发周期，难免会遇到因为第三方代码包含 bug 需要紧急修复的场景。在使用 Maven 等项目和依赖管理工具时，我们会倾向于将包含我们的 bug fix 的三方库，打出一个坐标相同但版本号比较特殊的依赖包，上传到内部仓库中，供有特定的 bug fix 需求的项目使用。然而在 Golang 目前的依赖管理策略中，开发人员很可能就会直接修改 vender 目录中的三方库，因为 Copy & Own 模糊了第三方代码和项目代码的界限。如此一来一颗定时炸弹就埋下了，除非项目有完善的测试套件，否则在未来的某个时刻，项目几经转手，最后背锅的开发者又不知道某个依赖曾经在一次 bug fix 中惨遭魔改，就很可能掉进这深坑。

> Big data is like teenage sex: everyone talks about it, nobody really knows how to do it, everyone thinks everyone else is doing it, so everyone claims they are doing it...

「完善的测试套件」这种东西，也许就像上面这段讽刺大数据的话一样，人人都说自己在做，却没几个人真正做过吧。

---

现在这 Grav 博客的部署还是有点复杂的，走了两层 NGINX 代理，第一层做 HTTPS 截停，第二层则是和 Grav 打在同一个镜像里作为 PHP 的 Web 服务器。

![](https://ws4.sinaimg.cn/large/801b780agw1f8avujzw6aj20et077glx.jpg)

那么问题来了，Grav 并不知道它对外提供的服务是走的 HTTPS 协议，在 Grav 内部渲染 URL 的时候，默认都是用的 HTTP 协议，导致我在页面模板中使用变量 `base_url_absolute`，得到的是 `http://blog.jamespan.me`，实际上我想要的是 `https://blog.jamespan.me`。

跟踪代码发现，Grav 判断当前服务使用 HTTP 还是 HTTPS，依据是 PHP 提供的一个全局变量，`$_SERVER['HTTPS']`，当变量值为字符串 `on` 时，认为 HTTPS 开启。那么如何在一个实际上提供 HTTP 服务的 PHP Server 上，设置 `$_SERVER['HTTPS'] = 'ON'` 呢？这就得借助 NGINX 的 `fastcgi_param` 指令了。

```
fastcgi_param  HTTPS 'on';
```

在 location block 中加上上面这条配置即可。



[1]: /posts/blogging-in-non-static-way
