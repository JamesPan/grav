---
title: 关于「开闭原则」的一点体会
published: false
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Architecture
---

> 在面向对象编程领域中，开闭原则规定“软件中的对象（类，模块，函数等等）应该对于扩展是开放的，但是对于修改是封闭的”，这意味着一个实体是允许在不改变它的源代码的前提下变更它的行为

最近打算把 Java 9 用在生产系统上，用模块化系统裁剪出一个极小的运行时，配合羽量级的 RESTful 框架 Restlet 和 新语言 Kotlin，做一些之前一般用 Python 来做的事情。

===

裁剪出来的运行时，除了能够运行 Web 框架和业务代码外，还包含了远程调试、JMX 监控以及常用的 jstack、jstat 等命令，不过占用 28MB 的磁盘空间，可以说跟 Python 解释器差不多大小了，可以作为软件的一部分一起分发到机器上执行。Java 软件的部署在过去几年里完成了从外置容器到嵌入式容器的转变，接下来连 JVM 这个运行时都将嵌入了。

拉起 Restlet 会占用 MetaSpace 20MB 的内存，而且如果系统比较简单，没有使用依赖注入和扫包，系统可以在 400ms 之内完成初始化，在今天这个时间点，流行的 Java Web 框架中几乎就没有能够秒起的，这个速度可以算是快得飞起了，如果没使用 ServiceLoader 和 JAX-RS 的话，这个启动时间还会更短。

比较遗憾的是，Restlet 并不支持 JAX-RS 2.0，像 @Suspended 这样的异步注解是没法用的。之前一个类似的项目中我用了 Jersey + Undertow 这套方案，基本上和 Restlet + JDK HTTP 是对应的组合，Jersey/Restlet 是 RESTful 框架，Undertow 是一个异步的基于 Reactor 模型的 HTTP 服务器，而 JDK HTTP 则基于线程模型。

Undertow 也是号称轻量而且性能优异，但是 Jersey 可就比 Restlet 复杂多了，于是 Jersey + Undertow 在内存的占用上也就水涨船高，不过不多，也就多用了 5MB MetaSpace 和 1MB Heap 而已。大多数时候，用 6MB 内存换一个全功能的 Servlet 3.0 服务器还是一笔划算的交易。

但是我发现一个问题，Jersey + Undertow 启动耗时明显比 Restlet 方案多，大约需要 1.1s，其中 Jersey 的初始化就需要 700ms，这还是没开扫包，而且只注册了一个资源的情况。之前有一次跟跟同事讨论 Java Web 启动速度的时候，我就说过依赖注入、扫包和读取资源文件是时间杀手，可是 Jersey 自带依赖注入，还有一大堆通过 ServiceLoader 来加载的部件，这 700ms 想必很难优化掉。

我想到两个强行优化的手段，要么用鸵鸟算法，放弃在启动时初始化 Jersey，将初始化延后至第一次访问时完成，要么开启后台线程并发地去初始化。

说回开闭原则。

Undertow 提供了 Access Log 机制，可以在初始化 AccessLogHandler 时传入日志格式，格式中的不同字段会被分配到不同的属性操作器（ExchangeAttribute）上独立提取。每个属性操作器都实现 ExchangeAttribute 接口，通过 ServiceLoader 机制构造实例。