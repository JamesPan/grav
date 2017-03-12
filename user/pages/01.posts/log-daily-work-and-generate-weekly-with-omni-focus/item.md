---
title: '准备再次尝试用 OmniFocus 记录工作并生成周报'
date: '2016-10-04 01:25'
taxonomy:
    category:
        - blog
        - Work
    tag:
        - Tool
        - Python
        - 'OS X'
        - AppleScript
header_image_file: 'https://ws1.sinaimg.cn/large/006y8lVagw1f8fhdef41vj30go09gt9l.jpg'
comments: true
---

> 春花秋月何时了？往事知多少。小楼昨夜又东风，故国不堪回首月明中。雕栏玉砌应犹在，只是朱颜改。问君能有几多愁？恰似一江春水向东流。

问君能有几多愁？为了一份周报想破头。

要说工作之后最让我头大的事情，其中一件就是每周都得写周报了。实习的时候，还曾经因为周报太简单，被大老板批评「要是再这么写周报，以后都别写了」。

===

为了逃脱因为周报简陋而在实习期被开除的厄运（误，我当时请教了几个组里的同事，得到了一些人生的经验：把周报分散到平时去写，每天写一点，到发周报之前汇总整理一下。

知易行难啊！一开始我也尝试着「每天写一点」，但更多的时候是不愿意去写，与其每天睡前怀着无奈写这周报的一部分，不如每周无奈一次。后来也有尝试用 GTD 的工具去记录每天的工作，到了写周报的时候把这周干的事情清单拉出来，对照着写。

那时候我处理的事情还没现在这么多，即使不用 GTD 工具去记录，也能回想起来写到周报里。于是 GTD 工具反而给我添加了麻烦，后来就放弃了，全靠记忆力硬扛。

后来事情渐渐变得不一样了，经常干了一周，忙这忙那，到了写周报的时候却想不起几件，搞得自己看起来好像摸了一周的鱼，实际上却已经累成了狗。之前我曾经有在 issue tracker 上做过程记录的尝试，把自己处理问题、设计方案过程中的操作、数据、思考等记录下来，方便日后重用、改进或者分享给同事使用、讨论等。借助 issue tracker 我是能捞出这一周我干了哪些事情，但是还是有些琐碎的不值得做过程记录或者直接照着之前的记录重做的事情给漏掉了，而且 issue 捞出来之后我还是得照着写周报，并不能自动生成一份，这让我很苦恼。

既然已经发展到了用 issue tracker，我又重新思考起用 GTD 工具结合 issue tracker 来生成周报的事情。如果我能在 GTD 中记录工作事件和一些重要的元数据，issue 中记录过程，然后用程序自动生成周报，岂不美哉？可惜 issue tracker 是内部轮子，接口不好搞，否则直接基于 issue tracker 做个周报生成器也不是不行。

有时候还真是羡慕那些能从 commit log 直接生成周报的同行，只要无忧无虑的提交代码就好，我已经好些日子没往团队的主仓库提交生产代码了，说多了都是泪。

说起来 macOS 上能支持自动化的 GTD 工具还真不多。本着越简单越好的想法，我先考察了 [todo.txt][1] 这种用纯文本做 GTD 的生态。todo.txt 是一套简单到简陋的规则，其中第一条就是，每一行文本都是一个待办事项，各种元数据比如结束时间、优先级都得换着花样和待办事项的标题混排在同一行文本中。在 todo.txt 中，我甚至没法另起一行去给 todo 附上详细描述和 issue 的链接。最后，更加坚定我放弃 todo.txt 的决心的，是 macOS 上一个看起来很不错的 todo.txt 的 App，TodoTxtMac，在中文支持上简直烂到不能用的程度。我当然不可能在 GTD 上开个文本编辑器来装作很 Geek 的样子，要不然我早把 Emacs 收拾收拾用 Org-Mode 了。

最后还是得用 OmniFocus，借助 Pro 版本提供的 Apple Script 支持来完成自动生成周报的工作。我也是参考了 [OmniFocus AppleScript Directory][2] 里的一些脚本，特别是 Daily Task Report，最后用 Python 调用 ScriptingBridge 而不是直接写 Apple Script 来完成的。当然 ScriptingBridge 的用法不是重点，经历了一开始各种摸不着头脑的 ScriptingBridge 瞎折腾并把 OmniFocus 的数据读出来存到 Python 对象中之后，剩下的就是常见的 Python 面向对象编程和 Jinja2 模板编程了。

对于这样的 OmniFocus 项目内容，

![](https://ws1.sinaimg.cn/large/006y8lVagw1f8flqncfkij30vk0msq62.jpg)

生成这样的周报，

![](https://ws2.sinaimg.cn/large/006y8lVagw1f8flq79m6pj30g80gc75c.jpg)

嘿嘿，还不错吧~或许这一次真的能把 OmniFocus 用起来。



[1]: http://todotxt.com
[2]: https://learnomnifocus.com/resources/applescript/

