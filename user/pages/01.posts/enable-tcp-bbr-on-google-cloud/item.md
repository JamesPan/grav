---
title: '在 Google Cloud 上自豪地开启 BBR'
date: '2017-04-12 01:09'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Linux
        - 'Google Cloud'
        - Cloud
header_image_file: 'https://ws1.sinaimg.cn/mw1024/e724cbefgy1fej6zk27wqj20dn03r0tb.jpg'
comments: true
---

之前把博客从 Alibaba Cloud 迁移到 Google Cloud 之后，页面访问速度下降了一两倍，虽然我并不太在意页面访问速度，但还是能感觉到明显的延迟，毕竟虚拟机的物理位置从香港跑到了美西，RTT 翻倍是逃不掉的。延迟增大之后我访问后台的等待时间也变长了，这一点我还是比较在意的，但是也懒得把博客迁移回去了，将就将就也还好。

===

晚上在网上到处乱转的时候，不知道是怎么想的就登陆到服务器上了，然后看到有软件包需要更新，而且还需要重启。

![](https://ws1.sinaimg.cn/large/e724cbefgy1fej7eg82rbj20fm079gmc.jpg)

反正都要重启服务器了，干脆顺便把内核升级到 4.9，感受一下传说中的 BBR 算法吧。

在网上找了一圈升级内核和开启 BBR 的教程博文之后，照猫画虎成功开启 BBR。对于 Ubuntu 系统，找一个不低于 4.9 版本的[主线内核][1]，比如这会最新的 4.9.x 是 [4.9.21][2]，就下载对应版本和架构（amd64）的内核镜像（`linux-image.+_amd64.deb`）、内核头文件（`linux-headers.+.deb`），然后用 dpkg 安装并重启系统。

重启进入 4.9.x 的内核之后，执行如下命令开启 BBR：

```bash
sudo bash -c 'echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf'
sudo bash -c 'echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf'
sudo sysctl -p
```

执行如下命令确认 BBR 成功开启，两个命令的预期输出都是 1：

```bash
sysctl net.ipv4.tcp_available_congestion_control | grep bbr | wc -l
lsmod | grep tcp_bbr | wc -l
```

开启 BBR 的效果还是蛮明显的，浏览器关闭缓存访问博客，完整加载耗时缩短将近一半。

开启前：

![开启前](https://ws1.sinaimg.cn/large/e724cbefgy1fej8a9ftr9j214d0q1h0l.jpg)

开启后：

![开启后](https://ws1.sinaimg.cn/large/e724cbefgy1fej8b3maczj214d0q1aqm.jpg)

从之前对 BBR 的了解，以为它只是在那种传统 VPS 共享带宽的场合下表现优异，可以抢占更多的带宽资源，云计算租户的带宽上限被 SDN 限制得死死的 BBR 应该没多大作用，但是从实际效果来看还是低估了。云计算租户也能在一定程度上从 BBR 中获益，因为它能不考虑丢包强行增大发送窗口。

在 Web 这种小文件远距离传输占大头的应用场景下，经常发送窗口还在按照「加性增，乘性减」的规则慢慢爬坡的时候来个丢包，整体延迟就被坑得死死的；BBR 在慢启动阶段不考虑丢包，强行继续增大发送窗口，结果就是页面开得更快了，适合在网关、CDN 等直接和用户设备交互的服务器上部署，至于内部系统之间的 TCP 通信就无所谓啦，反正内网带宽那么大网络条件那么好，用什么都一样。

[1]: http://kernel.ubuntu.com/~kernel-ppa/mainline/
[2]: http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.21/
