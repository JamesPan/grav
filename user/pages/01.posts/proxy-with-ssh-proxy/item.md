---
cc: true
comments: true
date: '2015-10-07 21:57:18'
hljs: true
jscomments:
  id: /2015/10/07/proxy-with-ssh-proxy/
  title: 使用 SSH Proxy 托管 OS X 的网络代理
  url: http://blog.jamespan.me/2015/10/07/proxy-with-ssh-proxy/
routes:
  aliases:
  - posts/proxy-with-ssh-proxy
  default: /2015/10/07/proxy-with-ssh-proxy
taxonomy:
  category:
  - blog
  - Study
  tag:
  - OS X
  - Tool
thumbnail: https://ws2.sinaimg.cn/small/e724cbefgw1ewsvsttdujj2074074gls.jpg
title: 使用 SSH Proxy 托管 OS X 的网络代理
---

出于这样那样的原因，这个世界上的一部分人，在上网的时候需要一个东西，叫做「代理」。在无数前辈高人前仆后继的努力下，我们终于能够用各种姿势花样代理。

> Across the Great Firewall, you can reach every corner in the world.

就我个人而言，我不但买了 VPN，买了某牌子的代理，还有一台位于香港的 ECS。于是我也就可以换着花样玩代理，最近常用的代理方式是 SSH Tunnel[^1]。

[^1]: [实战 SSH 端口转发][1]

===



更确切地说，我用的是 ssh 动态端口转发[^2]。说穿了其实简单到不行，一行命令搭建代理服务器。

[^2]: [SSH dynamic port forwarding with SOCKS][2]

```bash
ssh -N -D port [user@]hostname
```

这行命令启动一个 SOCKS 代理服务器，绑定在 `-D` 参数后面的端口上。然后把系统代理设置到 127.0.0.1:port 上即可。

按理说，这种代理方式在网上流传已久，在无数博客中流转，我再多传播一次其实没什么意义。但是当我真的用起来，作为日常代理使用的时候，其实体验并不好，特别是我主力浏览器是 Safari，附属浏览器是 Chrome 和 Opera 的时候。

先说 Safari 的代理设置。不像 Chrome 系和 Firefox，Safari 在代理的设置上就和 IE 一个德行，只能从系统设置里头修改，没有轻量便捷的修改方式。其次，在代理策略上，常用的手法是搞一个 PAC 文件，里面指定了 ssh 搞出来的 SOCKS 代理；然后本机启动 Apache，让系统设置从本机的 80 端口获得这个 PAC 文件。

这种方式拼凑出来的代理机制，仅仅是可用，远谈不上好用。假如一个常见的场景，有一个网站打不开，用户想让这个网站通过代理访问，需要几步操作？下面是几个可能的方案。

1.  直接把代理从 PAC 换成 SOCKS

    系统设置→网络→高级→代理→填写 IP 和 端口→确定→应用

2.  修改 PAC 文件，增加网站域名
3.  在 Chrome 中打开该网站，修改该网站的代理策略，刷新

第三种方案是相对操作比较少的了，但是依旧繁琐，而且需要开启一个非常用的浏览器。这还没考虑 ssh 进程僵死、连接断开等种种乱七八糟的情况。全考虑进去之后，体验简直糟糕。

其实我之前想造一个把 ssh tunnel 包装起来的轮子，作为系统流量的总代理，能够支持代理策略、断线重连等等特性，但是由于我没搞过类似的东西，缺乏相应的知识储备，只好搁置了。这几天我在 App Store 发现了一个应用，虽然距离我理想的轮子还有一定差距，但是也相差不远了。这个应用就是 [SSH Proxy][3]。

这个应用基本上实现了我想要造的轮子的所有功能，仅售 25 RMB，我就毫不犹豫地买下了。代理策略上，SSH Proxy 有 4 种默认策略：全部走代理，仅白名单走代理，仅黑名单不走代理，全不走代理。

![](https://ws1.sinaimg.cn/large/e724cbefgw1ewsrd283wuj20ho0b0wfv.jpg)

我们平时最常用的代理策略是「仅白名单走代理」，于是我就想着，只需要把一个域名集合导入到 SSH Proxy 就万事大吉了！

带着这样的想法，我去看了一眼「gfwlist」，希望能得到一点神谕，直接把域名集搞到手。然而我悲伤地发现，gfwlist 是用 AdBlock 的特殊标记来标识域名的，还有正则表达式什么的，不是 google.com 这样的简单域名。

开源大法好，我在 npm 上面发现了一个叫 [autoproxy2pac][4] 的工具，能够自动下载然后把 gfwlist 转换成 PAC 文件，并且在某种参数组合下，能够产生我想要的域名集合。

于是我就用这个工具，加上一点 Python 脚本，拼凑了一份适用于 SSH Proxy 的白名单域名集合。

```python
#!/usr/bin/env python
# filename: ssh-proxy-whitelist.py
import json
import fileinput
domain_settings = []
for domain in fileinput.input():
    d = {
        "enabled" : True,
        "subdomain_settings" : True,
        "address" : domain.rstrip()
    }
    domain_settings.append(d)
output = {
    "whitelist": {
        "Default" : domain_settings
    }
}
print json.dumps(output)
```

把这段 Python 代码保存起来，然后执行几个命令，就得到可以导入 SSH Proxy 的白名单了。

```bash
autoproxy2pac -p "SOCKS 127.0.0.1:6666"
node -e "$(< ./proxy.pac);for(var key in domains){console.log(key)}" | python ./ssh-proxy-whitelist.py > whitelist.json
```

当然，autoproxy2pac 参数中的代理不能不写可以乱写，反正这个不是重点。得到 PAC 文件之后就是让 node 加载这个名为 PAC 实际上是 JavaScript 的文件，并把文件中的一个叫 domains 的哈希表的 key 输出，这样就得到域名集合了~

当时我在使用 SSH Proxy 的时候遭遇了一些影响使用体验的性能问题，然后就给开发者邮件反馈了下，在最近发布的版本（16.03）中他们已经搞定了~

> 版本 16.03 中的新功能
> 1. 增加: 现在支持 SOCKS4 和 SOCKS4A 代理协议
> 2. **修正: 当黑/白名单条目上千时, 进入首选项会导致 App 卡住**
> 3. 修正: 连接成功后, 首次数据交换更迅速
> 4. 修正: 即便设置项被关闭, SSH Proxy 仍然执行 "严格检查主机密钥"
> 5. 改进: 大幅提高数据交换效率
> 6. 改进: 对一些只允许访问 80 (HTTP) 和 443 (HTTPS) 的防火墙, 这个版本提高了穿透性
> 7. 其它小幅改进

这个版本号还是比较有趣的，模仿 Ubuntu 么，16 年 3 月释出的版本号就叫 16.03。

更让我感到意外的是，我的英文名 James Pan 还出现在了 SSH Proxy 的 About 界面，这还是人生头一回呢，感觉自己萌萌哒~

![](https://ws2.sinaimg.cn/large/e724cbefgw1f236hfziukj213k0ru44w.jpg)

[1]: https://www.ibm.com/developerworks/cn/linux/l-cn-sshforward/
[2]: https://www.debian-administration.org/article/449/SSH_dynamic_port_forwarding_with_SOCKS
[3]: https://itunes.apple.com/cn/app/ssh-proxy/id597790822
[4]: https://www.npmjs.com/package/autoproxy2pac