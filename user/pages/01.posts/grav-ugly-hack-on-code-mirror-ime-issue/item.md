---
title: 'Grav 魔改录之 CodeMirror 和 IME 不对付'
date: '2016-10-22 23:48'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Grav
header_image_file: 'https://ws1.sinaimg.cn/large/801b780agw1f91havi94yj20gl07b3yy.jpg'
comments: true
---

我使用 Grav 作为博客系统已经好几个月了，基本上还算满意，除了一直没法愉快地在手机上写博客。

Grav 的 Admin 插件是一个功能完善的后台系统，在电脑上的用户体验尤其不错，可以说是我尝试过的各种博客系统中最让我满意的。最让我满意的是它的扩展性，允许用户通过增加 YAML 语法的 blueprint，为系统增加可视化配置编辑页面，靠着这个功能我已经把 Pastime、Links、Author 等页面或者 Sidebar 的内容做成可视化编辑的配置文件，从模板中剥离了。美中不足的是，Admin 插件集成的一个代码编辑器，在移动端输入中文时有致命缺陷。

===

这是一个由来已久的问题，无论是 CodeMirror 还是 ACE，只要是运行在浏览器里头的代码编辑器，似乎都和手机上的输入法存在冲突，输入法无法获取到键盘的输入事件，键盘的输入直接上屏了。然而 Grav 作为软件的集成商，才不会去关心这种上游依赖的问题呢，有问题也假装没看见。

在我昨天对 Grav 的 Admin 插件进行魔改之前，对于这个问题我只能捏着鼻子认了。昨天不知道怎么回事，我实在是感到不爽，非得把这问题给解决了不可。

虽然我不能 fix，但是我可以 workaround，只要在手机上别用 CodeMirror 去渲染编辑器，直接给我用 textarea 就挺好的。与此同时，我需要确保电脑上访问后台的时候依旧使用 CodeMirror，毕竟哪个平台有问题就解决那个平台的问题，不要扩大矛盾。

![](https://ws3.sinaimg.cn/large/801b780agw1f91gvud4ehj21ba0bg7a1.jpg)

魔改如上，Admin 插件里有一个模板文件 `editor.html.twig` 为 Markdown 和 YAML 编辑器渲染模板，Grav 提供了一个 [`browser`][1] 对象作为 User-Agent 的抽象，其 `getPlatform` 方法返回用户使用的平台，比如桌面平台 Windows、Linux、Macintosh，移动平台 iPhone、Android 之类的。虽然我木有 Android 设备，但是也加上，考虑到未来的扩展性哈哈。

于是我就又可以在手机上直接从博客后台愉快地写博客了！

[1]: https://learn.getgrav.org/themes/theme-vars#browser-object

