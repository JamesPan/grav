---
title: 'Java Fat Jar打包二三事'
published: false
taxonomy:
    category:
        - blog
    tag:
        - Java
---

前几天我在开发一个小型的 Java Web App，用 Undertow 做 HTTP 服务器，Jersey 做 RESTful 路由，在 IDE 中开发那是一个顺风顺水，但是到最后打包的时候遇到了一些奇怪的问题，最后也不走寻常路解决了。

Fat Jar 这种 Java 应用分发方式，近几年随着 DevOps 的潮流渐渐在 Java Web 生态里变得流行起来，SpringBoot 和 Dropwizard 等快速开发框架居功至伟。

===

常用的开源 Java 应用容器不过 Tomcat 和 Jetty 两种，考虑到这次开发的服务器其实是一个 Agent 类的进程，内存限制比较吃紧，我和同事约定只占用了64MB 内存，和平时写服务器进程内存随便用大不一样，我需要一个更加紧凑更加轻量的 Servlet 容器，就是红帽公司开源的 Undertow。

Jersey 是 JAX-RS 的参考实现，是不是用 Java 写 RESTful 服务的不二选择。

如此政治正确的架构选型，在打包调试的时候却遇到了问题。从 IDEA 里启动服务器的时候一切正常，直接启动 fat jar 的时候却炸了，无论我访问什么地址，返回的都是 404 Not Found。