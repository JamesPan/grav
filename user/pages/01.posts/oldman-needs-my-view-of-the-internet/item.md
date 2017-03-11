---
cc: true
comments: true
date: '2016-02-10 15:01:46'
hljs: true
jscomments:
  id: /2016/02/10/oldman-needs-my-view-of-the-internet/
  title: 与家人分享我的成长和我眼中的互联网
  url: http://blog.jamespan.me/2016/02/10/oldman-needs-my-view-of-the-internet/
routes:
  aliases:
  - posts/oldman-needs-my-view-of-the-internet
  default: /2016/02/10/oldman-needs-my-view-of-the-internet
taxonomy:
  category:
  - blog
  - Study
  tag:
  - Docker
thumbnail: https://i.imgur.com/8zGk8yK.png
title: 与家人分享我的成长和我眼中的互联网
---

往年的春节，过的并不像个假期的样子，反而比上学上班更累。回到海口没两天就回到乡下祖屋，和家族成员一起以海南传统的方式过新年：除夕年夜饭、初一祭祖、初四社戏……

今年我家看开了这一切，不再被所谓的传统绑架，一家三口在海口过年，吃饭、聊天、看书。晚上出去和家父的朋友们（看着我长大我的叔叔伯伯们）吃饭，下午出去和我的朋友们喝茶，距离我想要的春节假期有点接近了。

===



大年初一和家父出门走走晒晒太阳，顺着龙华路走到解放路的海口市新华书店，再走到骑楼老街。

新华书店门可罗雀，两人从一层转到五层，再从五层转回一层，都没发现什么值得购买的书。

五层摆放的是各种专业书籍，电脑的，工业制造的，农业生产的，武术气功的，林林总总。有趣的是，我在摆放 M$ Office 系列书籍的书架上，发现了几本「React——引领未来的用户界面开发框架」，顿时笑趴在地，这大概是 React 有史以来被黑得最惨的一次了吧。

![](https://i.imgur.com/evihxc6l.jpg)

转着转着转到了摆放数据库技术的书架区，我指着其中的几本书，向家父解释我这段时间在工作中接触和学习的 Redis，我在前段时间学习的 MySQL 和它那我不熟悉的分支 MariaDB，以及号称世界上最先进的开源数据库的 PostgreSQL 和它的分布式版本 Greenplum。

晚上，家父和我聊起未来几年的个人发展。自从我投身计算机工业界（其实就是没考上研究生灰溜溜滚出来当个小码农），家父一直不忘念叨着要我出去读个洋博士。

为了让家父明白博士头衔对于我这种混不了学术界只好混工业界的小码农来说并不是必需品，有了博士并不意味着今后会走得更好更远，为了学位而去读学位的代价有多沉重，我安利他收听「[内核恐慌][4]」，覃超专访。


<blockquote>
等我渐渐长大之后，我发现原来出国、读名校、念博士、买房、泡美女、进大企业等等事情，就像钱钟书先生所谓的“出水痘”一样，出过之后就产生了免疫力，之后便不再惦念了。这个过程其实是破除迷信的过程，你会发现，原来向往乃至崇拜的价值，其实也不值一提。自信若建立在这些水痘上，真就成了自卑了。

<footer>
<cite>@豆瓣狗剩爹 http://weibo.com/1711402453/zxItm2fIi</cite>
</footer>
</blockquote>


甲之蜜糖，乙之砒霜。有些话，从自己口中说出来，效果并不明显，要是从一个在计算机天赋上比你高得多的人口中说出，效果就不一样了。这也许就是意见领袖存在的意义，也许就是我等草民热衷于转发而不是创作的原因，天天就指望着意见领袖把自己想说的话说了，然后可以在朋友圈里转发一个，仿佛搞出了个大新闻。

能投身自己喜爱的行业是一种幸运。云计算，恰好是我喜欢的。无论后面的路怎么走，先把这些嘈杂的声音排除，免得在我做决定的时候被影响。

多年以来，我能随意穿行于长城内外，因此在互联网上拥有了比家人开阔的视野。如今，我这份视野，终于能和家人分享了。

我有两台位于海外的服务器，用 Docker 部署了 [影梭][3] 服务，如果需要，可以从 Docker Hub 获取我维护的镜像，然后在服务器上启动服务。如果不知道如何使用 Docker，那么我的建议是学习一下，不然就 out 了。

```bash
docker pull jamespan/shadowsocks-go
docker run -d --restart=always --name ss-proxy -p port:8388 -v path-to-config.json:/tmp/shadowsocks-config.json jamespan/shadowsocks-go
```

如果不挂载外部配置文件的话，影梭会使用我打包在镜像里的默认配置，在 8388 端口提供服务，密码是 password，加密算法是 aes-128-cfb。我当然是强烈建议自行挂载配置文件的。

默认的配置文件长这个样子，可以修改一下，让它使用别的密码，或者暴露多个端口，或者用其他的加密算法。

```json
{
    "port_password": {
         "8388": "password"
    },
    "method": "aes-128-cfb",
    "timeout":600
}
```

部署了影梭之后呢，我发现一个很严重的问题，就是访问 Google 的时候，会出现间歇性的找不到服务器。

```
error connecting to: www.google.com.hk:80 dial tcp: lookup www.google.com.hk on 100.100.2.138:53: no such host
```

一番 Google 之后发现，这是因为阿里云的服务器，即使在海外，用的还是国内的被污染的 DNS。解决办法自然是用纯天然无污染的 DNS 啦。于是我 ping 了一下 8.8.8.8，RTT 竟如此感人，2ms！莫非我这台服务器居然和 8.8.8.8 在同一个机房！

![](https://i.imgur.com/rbEINft.png)

那么我接下来就是要修改 DNS 了！Docker 容器启动的时候，如果启动参数中没有 `--dns` 系列参数，Docker daemon 就会去翻宿主机的 `/etc/resolv.conf` 把里面的 name server 捞出来给容器使用。一开始的时候我用了简单粗暴的方法，修改宿主机的 `/etc/resolv.conf`，在里面加上两个 Google 提供的 name server。

```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

这样子做好像也没什么大问题，毕竟动作还是大了些，不符合最小化变更的原则，明明是只有一个容器需要的 DNS 服务器，为什么要强加给其他的容器呢？

Docker 提供了 `--dns` [系列参数][2]，能够在启动容器的时候指定一个或多个 name server，或者其他各种相关的东西。

我们在配置 DNS 的时候呢，一般都是直接配置一对作为主备。使用 Docker 命令行指定多个 name server 的时候，要这么搞：

```
docker run -d --restart=always --dns=8.8.8.8 --dns=8.8.4.4 --name ss-proxy -p port:8388 -v path-to-config.json:/tmp/shadowsocks-config.json jamespan/shadowsocks-go
```

Docker 系列命令行参数的一个特点是，如果你想要表达列表，需要自己把参数重复多次，比如设置多个 DNS name server 就把 `--dns` 参数多写几遍，设置多个端口映射就把 `-p` 参数多写几遍……

至于客户端就比较简单，下了个影梭的 Windows 客户端，配置了两个服务器，然后选择高可用模式，虽然我并不知道这个所谓的「高可用」背后是如何做可用切换的，于是呢，我就搞出了一个「高可用的影梭集群」哈哈哈！

之前我一直都用的 SSH Tunnel，原因就是之前部署影梭的时候，总是莫名其妙的在访问 Google 的时候找不到服务器，如今可算解决了。也是出于这个原因，一开始我并没有直接用的影梭，而是想着用 PuTTY 搞一个隧道，但是折腾了半天效果都不理想，还超级难用，只好放弃。



[1]: https://hub.docker.com/r/jamespan/shadowsocks-go/
[2]: https://docs.docker.com/engine/userguide/networking/default_network/configure-dns/
[3]: https://shadowsocks.org/en/index.html
[4]: http://ipn.li/kernelpanic/