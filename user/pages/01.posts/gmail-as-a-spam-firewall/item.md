---
title: '把 Gmail 当作垃圾邮件过滤器'
date: '2016-09-24 02:21'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Gmail
        - Tips
header_image_file: 'https://ws1.sinaimg.cn/mw1024/72f96cbagw1f841qz81jgj20zk0k078f.jpg'
comments: true
---

在之前的一篇扯淡向博文「[轮询与回调][1]」中，有提到我把各种邮箱的邮件都转发到 iCloud 邮箱，然后由 iCloud 给我推送到各种设备上。这种方式能让我在及时收到邮件的同时，避免邮箱客户端轮询邮箱服务器，以及没有梯子就收不到邮件的尴尬。

使用一段时间之后，总体来说效果不错，但是 iCloud 在垃圾邮件的处理上并不让我满意，常常使我被推送过来的垃圾邮件所困扰，即使标记了多次垃圾邮件也无济于事，这让我十分怀念 Gmail。

===

我希望能同时拥有 Gmail 强大的垃圾过滤和 iCloud 的主动推送，为此我做了一些微小的工作，先把各个邮箱的邮件都转发到 Gmail，然后再从 Gmail 把邮件转发到 iCloud。

![](https://ws1.sinaimg.cn/large/72f96cbagw1f844txmijzj20fz06fmxs.jpg)

然后在 Gmail 中配置过滤器如下：

```
符合: to:(panjiabang@gmail.com) -{is:spam}
执行该操作: 标记为已读、 应用标签“已转发”、 转发给 xxx@icloud.com
```

就能让各种邮箱收到的邮件先走 Gmail 过滤垃圾邮件然后再发送到 iCloud 邮箱了。

[1]: https://blog.jamespan.me/posts/polling-and-callback