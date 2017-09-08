---
title: 'Java Fat Jar打包二三事'
date: '2017-09-07 15:18'
taxonomy:
    category:
        - blog
    tag:
        - Java
header_image_file: 'https://ws2.sinaimg.cn/mw1024/006tNc79gy1fjb11zpnd5j30i206v0t6.jpg'
comments: true
---

前几天我在开发一个小型的 Java Web App，用 Undertow 做 HTTP 服务器，Jersey 做 RESTful 路由，在 IDE 中开发那是一个顺风顺水，但是到最后打包的时候遇到了一些奇怪的问题，最后也不走寻常路解决了。

Fat Jar 这种 Java 应用分发方式，近几年随着 DevOps 的潮流渐渐在 Java Web 生态里变得流行起来，SpringBoot 和 Dropwizard 等快速开发框架居功至伟。

===

常用的开源 Java 应用容器不过 Tomcat 和 Jetty 两种，考虑到这次开发的服务器其实是一个 Agent 类的进程，内存限制比较吃紧，我和同事约定只占用了64MB 内存，和平时写服务器进程内存随便用大不一样，我需要一个更加紧凑更加轻量的 Servlet 容器，就是红帽公司开源的 Undertow。

Jersey 是 JAX-RS 的参考实现，是用 Java 写 RESTful 服务的不二选择。

如此政治正确的架构选型，在打包调试的时候却遇到了问题。从 IDEA 里启动服务器的时候一切正常，以 classpath 方式启动服务器也一切正常，以 fat jar 方式启动的时候却出了问题，无论我访问什么路径，access log 都无法正确打印完整信息。

仔细调试了请求路由的过程之后，我发现一个问题，正常工作的服务器，渲染 access log 中来源 IP 之类的信息使用的类是 `io.undertow.attribute.RemoteUserAttribute`，而不正常的服务器，使用的却是 `io.undertow.servlet.attribute.ServletNameAttribute`。

究竟是什么问题导致不同的打包方式带来不同的运行时行为？

全局搜索 `io.undertow.attribute.RemoteUserAttribute`，这个类型在 `undertow-core-1.4.8.Final.jar!/META-INF/services/io.undertow.attribute.ExchangeAttributeBuilder` 中被引用。看到 `META-INF/services` 的瞬间我似乎明白了问题所在，这是 Java 自带的 ServiceLoader 机制的约定，服务使用方在运行时动态加载 ExchangeAttributeBuilder 的实现。至于为什么两种打包方式带来运行时的差异，自然是 fat jar 打包的过程中，破坏了上述的服务描述文件，实际上使用的是 `undertow-servlet-1.4.18.Final.jar!/META-INF/services/io.undertow.attribute.ExchangeAttributeBuilder`，而这里面描述的实现少得可怜。

要想解决这个问题，唯一靠谱的办法就是在打包的时候合并所有的同名 services 文件，在 `maven-shade-plugin` 的配置中加上 [ServicesResourceTransformer][1]：

```xml
<transformer implementation="org.apache.maven.plugins.shade.resource.ServicesResourceTransformer" />
```

如此搞定了 fat jar 的小问题，我又遇到了一个大问题。fat jar 虽好，启动一个 fat jar 还是需要额外的脚本作为辅助，比如组装 JVM 参数什么的，`java -Xms16m -Xmx32m fat.jar`，不像启动一个可执行文件 `./fat.run` 那么方便。Java 应用是否能做到像单一可执行文件一样简便的分发和启动呢？

答案是肯定的，而且我在大一寒假那会（大约是2011年初）就知道这种技巧的存在。当时我刚接触 Linux，在 Ubuntu 上用 Netbeans IDE 写 Cpp，在 OJ 上刷水题度日。Netbeans IDE 的安装程序，就是一个差不多 200MB 的 sh 可执行文件，运行起来之后是一个 Java 写的安装程序。如今的我成为了一条 Java 狗，这是当初的我如论如何也想象不到的事情。

时过境迁，我也不会专门去下载 NetBeans 的安装包下来研究，随便在网上搜索了一下，就找到了可供参考的 [Wiki][2] 和[博文][3]。

出乎意料的是，当我依葫芦画瓢用 maven-antrun-plugin 在打包时自动把可执行文件做出来之后，用可执行文件直接拉起来的服务器，无论访问什么路径，都返回 404 Not Found。直觉告诉我，这一定是 Jersey 的扫包机制出了问题。

在配置 Jersey 应用的时候，我们通常会把一个包路径告诉 Jersey，Jersey 会在启动后自动将这个包下的所有标记了 `@Path` 注解的[资源][4]，注册到 Jersey 框架中，避免了繁琐的手工注册，这个过程俗称扫包。类似的方法在 Spring 和 Guice 等依赖注入框架中也很常见。

调试发现，Jersey 把可执行文件当中一个 jar 文件，并尝试解析该文件获取其中压缩的内容，却一无所获。实际上，可执行文件除了最开头是一段包含了启动相关的 shell script 的纯文本，后面就是完整的 jar 文件。阅读 Jersey 扫包部分的源码后发现，扫包的核心功能是从 jar 文件中读取内容，使用的是 `java.util.jar.JarInputStream`。

我尝试使用 JarInputStream 直接读取 fat.jar，是能够读到预期的内容的，然而直接读取 fat.run 却一无所获。然而当我忽略 fat.run 开头那一部分 shell script，让 JarInputStream 接着读取余下的字节流，结果正如我预期的那样，能够正确解析 jar 中包含的文件。

于是问题的原因变得清晰了，在 jar 文件开头附带了一段 shell script，改变了 jar 文件原本的结构，使得 JarInputStream 无法解析其中包含的文件。

这个问题应该如何解决？这可以说是一个相当棘手的问题，如果不是想要让应用分发变得更加简单，也许我会选择绕过去而不是正面刚，因为无法正常工作的代码，在一个第三方类库中。一般来说要解决外部类库的问题，我们会选择把源码拖下来修改然后重新打包上传，其中的繁琐艰辛自不必言，一旦到了类库升级的时候，还得跟进新版本，把 patch 打上去，再重新打包上传，生命就这样耗费在给第三方类库打 patch 上了，可以说是一项吃力不讨好的工作。

当然这只是一般水平的解决方案。四大天王之一的伞哥曾经说过，具体表述不记得了反正是这个意思，大部分的维护开源软件私有分支的人，是因为没有好好地去掌握开源软件的用法，不管三七二十一就拉分支加代码，把一个通用的开源软件给弄成了专用的软件。其实如果对常见的软件工程方法有所了解的话，很多时候我们是有能力在不对第三方代码做源码级改动的情况下改变其行为的，比如 Monkey Patch，比如 [AOP][5]。

以 Java 生态中的 AOP 而言，我们能在运行时、加载时、编译时这三个阶段，修改几乎任意函数的行为。可惜这项技术一直作为 Java Web 开发中的高阶技术存在，能够在如何使用 AOP 上对答如流的基本都是能独当一面的老司机了。然而大部分人即使用过，也只是用它配合 Spring 来在函数前后记录日志什么的，没有能够发挥 AOP 的真正威力。

既然说到了 AOP，那么这个问题我确实是用 AOP 去解决的，借助 [AspectJ][6] 做的编译时织入。我在 `o.g.j.s.i.s.JarZipSchemeResourceFinderFactory#getInputStream` 这个私有函数上做了环绕织入，对于原函数返回的 InputStream，并不立刻向上返回，而是先读取其中开始部分和 shell script 一样大小的字节流，根据读取结果判断是舍弃这部分字节还是重置字节流，然后再返回，就这样轻而易举地魔改了第三方的代码。



[1]: https://maven.apache.org/plugins/maven-shade-plugin/examples/resource-transformers.html
[2]: https://github.com/maynooth/CS210/wiki/Convert-Java-Executable-to-Linux-Executable
[3]: https://coderwall.com/p/ssuaxa/how-to-make-a-jar-file-linux-executable
[4]: http://restful-api-design.readthedocs.io/en/latest/resources.html
[5]: https://zh.wikipedia.org/wiki/面向侧面的程序设计
[6]: https://eclipse.org/aspectj/