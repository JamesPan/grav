---
title: '在 Java 9 上使用 AspectJ，没那么麻烦吧？'
date: '2018-03-31 18:34'
taxonomy:
    category:
        - blog
        - Work
    tag:
        - Java
        - Maven
header_image_file: 'https://ws4.sinaimg.cn/mw1024/006tNbRwgy1fpw6keikjqj30ji09cmy2.jpg'
comments: true
hljs: true
---

> 在软件业，AOP 为 Aspect Oriented Programming 的缩写，意为：面向切面编程，通过预编译方式和运行期动态代理实现程序功能的统一维护的一种技术。 AOP 是 OOP 的延续，是软件开发中的一个热点，也是 Spring 框架中的一个重要内容，是函数式编程的一种衍生范型。

AOP 是我最常用的一种黑魔法了，在 Java 中它常常作为依赖注入框架的一个重要功能为人所知，在 Python 中它披上马甲，以 Monkey Patch 的名义行走江湖。

Java 9 是半年前推出的新版本，以模块化系统这个近乎于 Breaking Change 的特性为主要卖点之一，其发行版在目录结构上与 Java 8 相比有了巨大差异，原本巨大的 rt.jar 被拆散到各个「精心规划」的模块中，tools.jar 也不见了踪影。

===

tools.jar 提供了存在于 JDK 而不存在于 JRE 的功能集，有些时候我们也能在工具类库的 POM 文件中看到如下依赖：

```xml
<dependency>
    <groupId>com.sun</groupId>
    <artifactId>tools</artifactId>
    <version>${java.version}</version>
    <scope>system</scope>
    <systemPath>${java.home}/../lib/tools.jar</systemPath>
</dependency>
```

正是由于 tools.jar 被拆分转移到模块中去了，原本在 Java 8 下用得好好的 aspectj-maven-plugin 开始抗议，即使升级到最新版本 1.11 也无济于事。

按照惯例遇到技术问题是要先问 Google 的，我发现了相关[问题单][1] 和爆栈的[提问][2]，但是这帮参与讨论渣渣并没有拿出一个靠谱的解决方案，不是贴一个不知道啥时候能进下个版本的 PR，就是要在 JDK 所在目录中伪造一个 tools.jar，把一个没用的文件放在那。

有 PR 固然是好，问题最终能够解决，可是远水救不了近火；在 JDK 目录下放文件的，自己这的电脑上是能跑了，CI 上得来一遍吧，应付同事得出个文档说明这么搞的原因和步骤吧，想想都麻烦。

真是让人看不下去，一个能打的都没有，是时候展示一下真正的技术了！不就是欺骗一下 Maven 的依赖管理系统，有那么难吗？

```xml
<dependency>
    <groupId>com.sun</groupId>
    <artifactId>tools</artifactId>
    <version>${java.version}</version>
    <scope>system</scope>
    <systemPath>${project.basedir}/pom.xml</systemPath>
</dependency>
```

反正都是弄一个假文件去让 Maven 能找到依赖，何苦要去 JDK 下加文件，直接在依赖声明中用当前模块的 pom.xml 来顶包，显然这是一个不可能不存在的文件，简单稳定可靠。

雕虫小技，不足挂齿。

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fpw7kqdf3cj30w00w076u.jpg)

[1]: https://github.com/mojohaus/aspectj-maven-plugin/issues/24
[2]: https://stackoverflow.com/questions/48173963/maven-aspectj-plugin-fails-to-build-with-java-9-due-to-missing-tools-jar
[3]: https://github.com/mojohaus/aspectj-maven-plugin/pull/35