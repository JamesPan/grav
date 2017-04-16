---
title: '在 Google Cloud 上自豪地采用 Grav '
date: '2017-03-19 22:57'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Docker
        - Grav
        - 'Google Cloud'
header_image_file: 'https://ws1.sinaimg.cn/mw1024/e724cbefgy1fdshgtlzw0j20p008cdkj.jpg'
comments: true
show_header_image: true
---

前几天 Google Cloud 放出了一个号称 [Always Free][1] 的套餐，除了一个乞丐版的计算节点（1 Core 0.6G RAM 30G HDD），还有其他一系列的体验容量。资本主义的羊毛还是得好好薅一把，于是我果断注册了一发。

实测 us-west1-a 可用区的机器，到杭州电信的 RTT 大约在 300ms，作为博客机器还是勉强可以在 2s 左右打开网页的。其实现在我已经不像刚开始写博客那会那么关注博客的加载速度了，因为我相信人们并不会因为我的博客能秒开而访问它，人们访问它是因为它的内容有价值。

===

之前部署 Grav 的时候用的是比较粗放的手法，基于 Alpine Linux 打包一个 PHP7 + NGINX 的 Docker 镜像，然后把 Grav 目录（博文和站点配置也在这个目录里）整个挂载到容器的 `/var/www/html` 目录上就算是把博客拉起来了。备份的工作也是在宿主机上写了个 Cron Job，每天晚上 10 点把 Grav 目录排除缓存后压一个 tar.gz，然后复制到 Dropbox 目录里自动同步。

许久没关注 Grav 的版本变化，这才发现我在用的 Grav 已经落后最新的稳定版许多许多了。由于各种各样的原因，我还魔改了一些 Grav 的插件，这也给我升级全套 Grav 和插件带来了麻烦。看来是我之前使用 Grav 的姿势不适合它这种还在频繁演进中的生态。而且我也是比较喜欢以前用 Hexo 时打出来的镜像，不管到哪里，只要有 Docker，不再需要其他依赖，只需要执行一个简单的 `docker run -p 8080:80 jamespan/blog`，就能把我的博客给拉起来，不管是临时迁移还是布道都挺方便。相比之下，现在基于 Grav 部署的博客就复杂了许多，不仅要拉起镜像，还要从 Dropbox 拉最新的备份。

我决定把前后两个博客镜像的优点整合一下，搞出一个既要开箱即用的博客镜像，又要保持 Grav 可以通过后台维护的优点，还要在 Grav 或者插件发布了我感兴趣的新版本时能够轻易升级而且不丢失我的魔改特性。嗯，既要又要还要。

首先，我需要维护一个[魔改版的 Grav 分支][3]，用之前[魔改 Grafana 时使用的分支策略][2]，不仅包含稳定版本的 Grav，还包含我用到的所有插件，以及我对插件的魔改；最最重要的是要包含我的博文和站点配置。

然后，写一个 [Dockerfile][4]，从魔改分支构建出博客镜像。

最后，写一个 [docker-compose.yml][5]，在目标机器上把博客镜像拉起来，自动挂载放在机器上的各种目录，确保不因为容器重启而造成数据丢失。

于是一个开箱即用的博客容器就这么做出来啦~当我需要布道 Grav 或者有同事/同行在部署 Grav 遇到困难的时候，我可以直接把这个镜像分享出去。而且我通过把魔改[从上游代码中隔离并集中保存][6]的策略，配合[容器启动时实施魔改][7]的方式，使得同一个镜像，在挂载不同的目录时，能够得到不同的魔改效果。这不就是传说中的在易用性上满足初级用户，在定制性上满足高级用户吗？

于是我愉快地使用 `jamespan/gravbox` 镜像把博客迁移到了 Google Cloud。

最近有好几个同事来咨询我关于 Grav 的问题了，看来部署 Grav 也不是我想的那么简单，如果想要快速在本地体验一下 Grav，可以试尝试执行这个命令：

```bash
docker run -it --rm -e GRAV_SERVER_PORT=8080 -e GRAV_HTTPS_STATUS=off -p 8080:8080 jamespan/gravbox
```

然后应该也许就能在 <http://127.0.0.1:8080> 访问到一个超级棒的博客了吧~

顺便对容器的用法发表一些观点。一直以来我都是比较倾向于「胖容器」这种风格的，特别是那些注定要捆绑部署的进程，比如 PHP-FPM 和 NGINX，或者 Tomcat 和 NGINX，反正注定要在业务进程前面挡一个 NGINX，何必多此一举弄出 PHP/Tomcat 和 NGINX 两个镜像？直接在一个镜像里用 chaperone 编排一下进程的启动顺序就可以了。

甚至还可以极端一点，如果一个分布式系统里有多个角色，在输出软件的时候，也可以把这些角色的可执行文件统统都打包在一个叫 XXX-Box 的镜像里，然后通过传不同的环境变量或者参数，在不同的物理节点上拉起不同的进程。仔细想想，这不就是 busybox 在容器时代的传承吗哈哈~

如果从一个 SaaS 系统的日常演进的角度来考虑，这种 All in One 的打包方式的确太重，不同进程的可执行文件分散到各个小镜像里的确有利于打包和发布，但是在整体输出的时候，分发一个 XXX-Box 的镜像就比分发几十个 XXX-Role 的简洁太多太多了。

[1]: https://cloud.google.com/free/
[2]: https://blog.jamespan.me/posts/what-i-learned-from-modifying-grafana
[3]: https://github.com/JamesPan/gravbox
[4]: https://github.com/JamesPan/gravbox/blob/mod/master/Dockerfile
[5]: https://github.com/JamesPan/gravbox/blob/mod/master/mod/config/compose-pro.yml
[6]: https://github.com/JamesPan/gravbox/tree/mod/master/mod
[7]: https://github.com/JamesPan/gravbox/blob/mod/master/mod/config/chaperone.conf#L1-L8
