---
title: 'Human Resource Machine 通关大吉'
date: '2016-10-11 01:15'
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Gaming
header_image_file: 'https://ws2.sinaimg.cn/mw1024/006y8lVagw1f8k7zlwz53j31hc0u0k08.jpg'
comments: true
content:
    items: '@self.children'
    limit: '5'
    order:
        by: date
        dir: desc
    pagination: '1'
    url_taxonomy_filters: '1'
---

多图杀流量，非 Wi-Fi 环境慎入。

不知道多久没有这么废寝忘食地玩游戏了。国庆假期的后面几天，我在玩一个叫做 *[Human Resource Machine][1]* 的游戏。最开始得知这个游戏的消息，还是收听的 内核恐慌 最新一期播客 [双侧轮流肾移植][2]。

> 给小职员编程来让他们解决难题。当一名好的员工吧！机器正在过来……夺走你的岗位。

Human Resource Machine 是一个解谜游戏，玩家使用某种简陋的汇编语言，控制小职员去完成各种工作任务。每一关除完成任务外都还有两个目标，一个是要使用尽可能少的指令（不多于 N 个指令），另一个是在运行时使用尽可能少的步骤（不多于 M 个步骤）；

===

这两个指标真是让人感到亲切。这不就是本科时期在 OJ 上刷题时的两个排序指标么，尽可能少的指令，在 Codeforces  上对应 Solution Size，尽可能少的步骤，则是 Execution Time。大三的时候有一段时间，每天在 Codeforces 上刷几道水题，虽然我的数据结构和算法水平烂得掉渣，但是短码编程勉强算是一把好手，配合 Python 的各种高阶函数和语法糖，代码更是短得飞起，这么多年过去了，我的一些提交从 Solution Size 上看，排名不算太糟糕。

![](https://ws2.sinaimg.cn/large/006y8lVagw1f8k8ohehd7j30of0drgpp.jpg)

这游戏实在是太让人着迷，玩起来也是太过于亲切，仿佛回到了刚学计算机时的青葱岁月，看着算法题，对比着 Sample 调试代码，然后一点一点优化。

我也是控制不住记几，连着把游戏打通关了（基本上），除了两个看上去就很复杂的关卡没动（一个是分解质因数的，别说用汇编了，用高级语言我都不知道怎么写，另一个是三排序，跳转逻辑太复杂先放一放），其他关卡都通了，而且基本上都完成两个目标。

下面分享一下我每一关的解法，没玩过的看看也没关系，反正记不住。有些关卡为了达成步骤数的目标，不得不使用一些很脏的技巧，比如循环展开；甚至还有一个需要实现排序算法的关卡，冒泡排序过不了关，非得写个快排。用汇编写快排还真是人生头一回。

### Year 1 - Mail Room 

★★

![](https://ws4.sinaimg.cn/large/006y8lVagw1f8mgbn39bhg30dc07hx6y.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

    INBOX   
    OUTBOX  
    INBOX   
    OUTBOX  
    INBOX   
    OUTBOX  
```

### Year 2 - Busy Mail Room

第二年是第一个无法用一套代码达成两个目标的关卡，恶意满满。不过这一关让我们知道，循环展开是可以在一定程度上减少执行步骤的，这一技巧在后面的关卡中会被反复使用。

★☆

![](https://ws3.sinaimg.cn/large/006y8lVagw1f8mgqeadorg30dc07h7wt.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    OUTBOX  
    JUMP     a
```

☆★

![](https://ws3.sinaimg.cn/large/006y8lVagw1f8mgzm5j6dg30dc07h7ws.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    OUTBOX  
    INBOX   
    OUTBOX  
    JUMP     a
```

### Year 3 - Copy Floor

★★

![](https://ws2.sinaimg.cn/large/006y8lVagw1f8mh61sk12g30dc07h7wr.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

    COPYFROM 4
    OUTBOX  
    COPYFROM 0
    OUTBOX  
    COPYFROM 3
    OUTBOX  
```

### Year 4 - Scrambler Handler

★★

![](https://ws1.sinaimg.cn/large/006y8lVagw1f8mh9xrjcog30dc07hx6y.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
    INBOX   
    OUTBOX  
    COPYFROM 0
    OUTBOX  
    JUMP     a
```

### Year 6 - Rainy Summer

★★

![](https://ws2.sinaimg.cn/large/801b780agw1f8mhdyly8kg20dc07hx6y.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
    INBOX   
    ADD      0
    OUTBOX  
    JUMP     a
```

### Year 7 - Zero Exterminator

★★

![](https://ws2.sinaimg.cn/large/801b780agw1f8mhj8ov12g20dc07h4qz.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
b:
    INBOX   
    JUMPZ    b
    OUTBOX  
    JUMP     a
```

### Year 8 - Tripler Room

★★

![](https://ws2.sinaimg.cn/large/801b780agw1f8mho72hw9g20dc07hb2k.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
    ADD      0
    ADD      0
    OUTBOX  
    JUMP     a
```

### Year 9 - Zero Preservation Initiative

第九年是一个不得不使用作弊才能达成步骤数目标的关卡。可以看到我的第二份代码中，假设第一个数字不可能为 0 可以抛弃，连着用了两个 INBOX 指令，钻了数据的空子才达成「少于 25 步」的目标。

★☆

![](https://ws1.sinaimg.cn/large/801b780agw1f8mhym0dhqg20dc07hkjv.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
b:
    INBOX   
    JUMPZ    c
    JUMP     b
c:
    OUTBOX  
    JUMP     a
```

☆★

![](https://ws3.sinaimg.cn/large/801b780agw1f8mhzmwrwbg20dc07h1l7.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

    INBOX   
    INBOX   
a:
    OUTBOX  
b:
    INBOX   
    JUMPZ    a
    JUMP     b
```

### Year 10 - Octoplier Suite

★★

![](https://ws3.sinaimg.cn/large/801b780agw1f8mi4aexupg20dc07hnpn.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
    ADD      0
    COPYTO   0
    ADD      0
    COPYTO   0
    ADD      0
    OUTBOX  
    JUMP     a
```

### Year 11 - Sub Hallway

★★

![](https://ws4.sinaimg.cn/large/801b780agw1f8mi5w0nrsg20dc07hnpn.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   1
    INBOX   
    COPYTO   2
    SUB      1
    OUTBOX  
    COPYFROM 1
    SUB      2
    OUTBOX  
    JUMP     a
```

### Year 12 - Tetracontiplier

★★

![](https://ws3.sinaimg.cn/large/801b780agw1f8mi9gx8bng20dc07h000.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
    ADD      0
    COPYTO   0
    ADD      0
    COPYTO   0
    ADD      0
    COPYTO   1
    ADD      1
    COPYTO   0
    ADD      0
    ADD      1
    OUTBOX  
    JUMP     a
```

### Year 13 - Equalization Room

又是一个需要魔改才能拿到两星的楼层。第一份代码达成了指令数的目标，蛋疼的是步骤数比目标多了一步。第二份代码中我演示了使用一个冗余的 INBOX 指令来减少一次跳转指令的技巧。

★☆

![](http://ww2.sinaimg.cn/large/801b780agw1f8migh5ve2g20dc07h7wr.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
b:
    INBOX   
    COPYTO   0
    INBOX   
    SUB      0
    JUMPZ    c
    JUMP     b
c:
    COPYFROM 0
    OUTBOX  
    JUMP     a
```

☆★

![](https://ws2.sinaimg.cn/large/801b780agw1f8miif4xc3g20dc07hhe3.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
b:
    COPYTO   0
    INBOX   
    SUB      0
    JUMPZ    c
    JUMP     a
c:
    COPYFROM 0
    OUTBOX  
    INBOX   
    JUMP     b
```

### Year 14 - Maximization Room

★★

![](https://ws1.sinaimg.cn/large/801b780agw1f8mimv7ba0g20dc07hkjv.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   1
    INBOX   
    SUB      1
    JUMPN    b
    ADD      1
    JUMP     c
b:
    COPYFROM 1
c:
    OUTBOX  
    JUMP     a
```

### Year 16 - Absolute Positivity

又一个用冗余来缩减步骤数的楼层。套路，都是套路！

★☆
```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    JUMPN    b
    JUMP     c
b:
    COPYTO   0
    SUB      0
    SUB      0
c:
    OUTBOX  
    JUMP     a
```

☆★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
b:
    INBOX   
    JUMPN    c
    OUTBOX  
    JUMP     b
c:
    COPYTO   0
    SUB      0
    SUB      0
    OUTBOX  
    JUMP     a
```

### Year 17 - Exclusive Lounge

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
b:
    INBOX   
    JUMPN    d
    INBOX   
    JUMPN    e
c:
    COPYFROM 4
    OUTBOX  
    JUMP     a
d:
    INBOX   
    JUMPN    c
e:
    COPYFROM 5
    OUTBOX  
    JUMP     b
```

### Year 19 Countdown

这是一个需要魔改才能达成步骤数目标的关卡，而且需要实现非常紧凑的循环体。

★☆

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
b:
c:
    OUTBOX  
    COPYFROM 0
    JUMPZ    a
    JUMPN    d
    BUMPDN   0
    JUMP     c
d:
    BUMPUP   0
    JUMP     b
```

☆★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

    INBOX   
a:
    COPYTO   0
    JUMPN    c
b:
    JUMPZ    f
    OUTBOX  
    BUMPDN   0
    JUMP     b
c:
d:
    OUTBOX  
    BUMPUP   0
    JUMPZ    e
    JUMP     d
e:
f:
g:
    OUTBOX  
    INBOX   
    JUMPZ    g
    JUMP     a
```

第一份代码的主要部分用高级语言的伪代码描述，大概是这个样子的，循环体内有 if 判断：

```c
scanf &a
do {
	printf a
	if (a < 0) {
		--a
	} else {
		++a
	}
} while (a != 0)
```

而第二份代码则是把 if 判断往外提，循环往 if 分支里放，这样虽然冗余了循环代码，但是循环体变得异常紧凑，执行步骤数反而少了。

```c
scanf &a
if (a < 0) {
  do {
    printf a
    ++a
  } while (a != 0)
} else {
  do {
    printf a
    --a
  } while (a != 0)
}
do {
  printf a
  scanf &a
} while (a == 0)
```

### Year 20 - Multipication Workshop

这一层还是得写两份代码，心累。第一份代码就是很朴素地读取两个数，然后很朴素地做乘法。朴素算法通常实现简单却性能不佳。第二份代码就有点复杂了，先要判断两个数其中是否有 0，如果有就直接输出 0 然后结束了；如果没有 0，就得比一下大小，小的作为循环控制器，让大的数自己和自己做加法，这样能减少循环次数，执行步骤也就想要减少了。

★☆

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   1
    INBOX   
    COPYTO   2
    COPYFROM 9
    COPYTO   0
b:
    BUMPDN   1
    JUMPN    c
    COPYFROM 2
    ADD      0
    COPYTO   0
    JUMP     b
c:
    COPYFROM 0
    OUTBOX  
    JUMP     a
```

☆★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
b:
    INBOX   
    JUMPZ    h
    COPYTO   1
    INBOX   
    JUMPZ    i
    COPYTO   2
    SUB      1
    JUMPN    d
    COPYFROM 2
    COPYTO   0
    BUMPDN   1
c:
    BUMPDN   1
    JUMPN    g
    COPYFROM 2
    ADD      0
    COPYTO   0
    JUMP     c
d:
    COPYFROM 1
    COPYTO   0
    BUMPDN   2
e:
    BUMPDN   2
    JUMPN    f
    COPYFROM 1
    ADD      0
    COPYTO   0
    JUMP     e
f:
g:
    COPYFROM 0
    OUTBOX  
    JUMP     b
h:
    INBOX   
i:
    COPYFROM 9
    OUTBOX  
    JUMP     a
```

### Year 21 - Zero Terminated Sum

两份代码，again。

★☆

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    COPYFROM 5
    COPYTO   0
b:
    INBOX   
    JUMPZ    c
    ADD      0
    COPYTO   0
    JUMP     b
c:
    COPYFROM 0
    OUTBOX  
    JUMP     a
```

☆★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    JUMPZ    d
    COPYTO   0
b:
    INBOX   
    JUMPZ    c
    ADD      0
    COPYTO   0
    JUMP     b
c:
    COPYFROM 0
d:
    OUTBOX  
    JUMP     a
```

减少执行步骤的秘诀是，对第一个数字做特殊处理，对 0 长度的串做特殊处理。第一份代码的伪代码描述是

```c
a = 0
while ((scanf &b) != 0) {
    a = a + b
}
printf a
```

第二份代码则是

```c
scanf &a
if (a != 0) {
    while ((scanf &b) != 0) {
        a = a + b
    }
}
printf a
```

### Year 22 - Fibonacci Visitor

在这一个关卡，我的代码终于一次性突破了两个目标，比目标值都要小。

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
    COPYFROM 9
    COPYTO   1
    COPYTO   2
    BUMPUP   2
b:
    SUB      0
    JUMPN    d
    JUMPZ    c
    JUMP     a
c:
d:
    COPYFROM 2
    ADD      1
    COPYTO   2
    SUB      1
    COPYTO   1
    OUTBOX  
    COPYFROM 2
    JUMP     b
```

### Year 23 - The Littlest Number

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
b:
c:
    INBOX   
    JUMPZ    e
    SUB      0
    JUMPN    d
    JUMP     b
d:
    ADD      0
    COPYTO   0
    JUMP     c
e:
    COPYFROM 0
    OUTBOX  
    JUMP     a
```

### Year 24 - Mod Module

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
    INBOX   
    COPYTO   1
    COPYFROM 0
b:
    SUB      1
    JUMPN    c
    COPYTO   0
    JUMP     b
c:
    COPYFROM 0
    OUTBOX  
    JUMP     a
```

### Year 25 - Cumulative Countdown

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    JUMPZ    d
    COPYTO   0
    COPYTO   1
b:
    BUMPDN   1
    JUMPZ    c
    ADD      0
    COPYTO   0
    JUMP     b
c:
    COPYFROM 0
d:
    OUTBOX  
    JUMP     a
```

### Year 26 - Small Divide

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
    INBOX   
    COPYTO   1
    COPYFROM 9
    COPYTO   8
b:
    COPYFROM 0
    SUB      1
    JUMPN    c
    COPYTO   0
    BUMPUP   8
    JUMP     b
c:
    COPYFROM 8
    OUTBOX  
    JUMP     a
```

### Year 28 - Three Sort

逻辑有点复杂，没拿到星。

☆☆

### Year 29 - Storage Floor

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   12
    COPYFROM [12]
    OUTBOX  
    JUMP     a
```

### Year 30 - String Storage Floor

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   24
b:
    COPYFROM [24]
    JUMPZ    a
    OUTBOX  
    BUMPUP   24
    JUMP     b
```

### Year 31 - String Reverse

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
b:
    INBOX   
    JUMPZ    c
    COPYTO   [14]
    BUMPUP   14
    JUMP     a
c:
d:
    BUMPDN   14
    COPYFROM [14]
    OUTBOX  
    COPYFROM 14
    JUMPZ    b
    JUMP     d
```

### Year 32 - Inventory Report

这个是我疯狂优化之后的版本，同样都是 16 个指令，最后的运行步骤比第二份代码少了 40 个左右。

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   15
    COPYFROM 14
    COPYTO   16
    BUMPDN   16
    COPYTO   19
b:
    BUMPUP   19
c:
    BUMPUP   16
    COPYFROM [16]
    JUMPZ    d
    SUB      15
    JUMPZ    b
    JUMP     c
d:
    COPYFROM 19
    OUTBOX  
    JUMP     a
```

★☆

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   15
    COPYFROM 14
    COPYTO   16
    COPYTO   19
b:
    COPYFROM [16]
    JUMPZ    e
    SUB      15
    JUMPZ    c
    JUMP     d
c:
    BUMPUP   19
d:
    BUMPUP   16
    JUMP     b
e:
    COPYFROM 19
    OUTBOX  
    JUMP     a
```

### Year 34 - Vowel Incinerator

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
b:
    INBOX   
    COPYTO   6
    COPYFROM 5
    COPYTO   9
c:
    COPYFROM [9]
    JUMPZ    d
    SUB      6
    JUMPZ    a
    BUMPUP   9
    JUMP     c
d:
    COPYFROM 6
    OUTBOX  
    JUMP     b
```

### Year 35 - Duplicate Removal

第一份代码也是中规中矩地写，不出意料地没能达成步骤数的目标。

★☆

```
-- HUMAN RESOURCE MACHINE PROGRAM --

    COPYFROM 14
    COPYTO   13
a:
b:
    INBOX   
    COPYTO   10
    COPYFROM 13
    COPYTO   12
c:
    BUMPDN   12
    JUMPN    d
    COPYFROM 10
    SUB      [12]
    JUMPZ    a
    JUMP     c
d:
    COPYFROM 10
    COPYTO   [13]
    OUTBOX  
    BUMPUP   13
    JUMP     b
```

第二份代码针对第一个输入做了优化，跳过了不少步骤，效果拔群，但是还是没有达成步骤数的目标。

☆☆

```
-- HUMAN RESOURCE MACHINE PROGRAM --

    INBOX   
    COPYTO   0
    OUTBOX  
    BUMPUP   14
    COPYTO   13
a:
    INBOX   
    COPYTO   10
    COPYFROM 13
    COPYTO   12
b:
c:
    BUMPDN   12
    JUMPN    d
    COPYFROM [12]
    SUB      10
    JUMPZ    a
    JUMP     c
d:
    COPYFROM 10
    COPYTO   [13]
    OUTBOX  
    BUMPUP   13
    COPYTO   12
    INBOX   
    COPYTO   10
    JUMP     b
```

第三份代码在第二份的基础上魔改一番，对第一个、第二个、第三个输入都做了特殊处理，相当于把这三个输入从循环体中拿出来就地展开了，代码行数暴增，但是最终还是满足了执行步骤的要求，点亮了第二盏灯。

☆★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

    INBOX   
    COPYTO   0
    OUTBOX  
    INBOX   
    COPYTO   1
    SUB      0
    JUMPZ    a
    COPYFROM 1
    OUTBOX  
    BUMPUP   14
    INBOX   
    COPYTO   2
    SUB      0
    JUMPZ    c
    COPYFROM 2
    SUB      1
    JUMPZ    b
    COPYFROM 2
    OUTBOX  
    BUMPUP   14
a:
b:
c:
    BUMPUP   14
    COPYTO   13
d:
    INBOX   
    COPYTO   10
    COPYFROM 13
    COPYTO   12
e:
f:
    BUMPDN   12
    JUMPN    g
    COPYFROM [12]
    SUB      10
    JUMPZ    d
    JUMP     f
g:
    COPYFROM 10
    COPYTO   [13]
    OUTBOX  
    BUMPUP   13
    COPYTO   12
    INBOX   
    COPYTO   10
    JUMP     e
```

### Year 36 - Alphabetizer

这一关能同时达成两个目标的解法还挺多，如果用先把两个字符串都存下来再比较的方法，优化优化代码也能实现。但是我后来改成了另一种方法，不但指令数比目标少，步骤数也比目标少，这种思路就是区分对待两个字符串，先把第一个字符串存下来，第二个字符串则是一边读区一边比较，这样子如果读取过程中发现第二个字符串不是要输出的那个，就可以中止读入，直接输出第一个串了。

★★

![](https://ws1.sinaimg.cn/large/801b780agw1f8nn6i7e2tg20dc07hb2r.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   [23]
    JUMPZ    b
    BUMPUP   23
    JUMP     a
b:
    COPYTO   23
    COPYTO   20
    COPYTO   19
    COPYFROM 24
    COPYTO   21
c:
d:
    INBOX   
    COPYTO   [21]
    JUMPZ    i
    COPYFROM 19
    JUMPN    f
    COPYFROM [20]
    JUMPZ    h
    SUB      [21]
    JUMPZ    e
    JUMPN    g
    BUMPDN   19
    BUMPUP   21
    JUMP     d
e:
    BUMPUP   20
f:
    BUMPUP   21
    JUMP     c
g:
h:
    COPYFROM 23
    JUMP     j
i:
    COPYFROM 24
j:
    COPYTO   20
k:
    COPYFROM [20]
    JUMPZ    l
    OUTBOX  
    BUMPUP   20
    JUMP     k
l:
```

### Year 37 - Scavenger Chain

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
b:
    COPYTO   12
    COPYFROM [12]
    OUTBOX  
    BUMPUP   12
    COPYFROM [12]
    JUMPN    a
    JUMP     b
```

### Year 38 - Digit Exploder

目前仅点亮第一盏灯，距离第二盏灯很接近了但就是拿不到。

★☆

![](https://ws4.sinaimg.cn/large/801b780agw1f8nnhylpjwg20dc07h4r4.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    INBOX   
    COPYTO   0
    SUB      10
    JUMPN    g
    COPYFROM 0
    SUB      11
    JUMPN    d
    COPYFROM 9
    COPYTO   2
b:
    COPYFROM 0
    SUB      11
    JUMPN    c
    COPYTO   0
    BUMPUP   2
    JUMP     b
c:
    COPYFROM 2
    OUTBOX  
d:
    COPYFROM 9
    COPYTO   2
e:
    COPYFROM 0
    SUB      10
    JUMPN    f
    COPYTO   0
    BUMPUP   2
    JUMP     e
f:
    COPYFROM 2
    OUTBOX  
g:
    COPYFROM 0
    OUTBOX  
    JUMP     a
```

为了加快执行速度，我用了一个叫做「预处理」的技巧，在处理输入之前先做好 5，50，500 三个数字，如果输入恰好比它们大，就可以省去 5 次循环的步骤。于是步骤数从 204 下降到了 173，但还是没达成目标，技差一筹，功亏一篑。

☆☆

![](https://ws2.sinaimg.cn/large/006y8lVagw1f8nny4o1r2g30dc07hb2m.gif)

```
-- HUMAN RESOURCE MACHINE PROGRAM --

    COPYFROM 9
    COPYTO   6
    BUMPUP   6
    BUMPUP   6
    BUMPUP   6
    BUMPUP   6
    BUMPUP   6
    COPYFROM 10
    COPYTO   7
    ADD      7
    COPYTO   7
    ADD      7
    ADD      10
    COPYTO   7
    COPYFROM 11
    COPYTO   8
    ADD      8
    COPYTO   8
    ADD      8
    ADD      11
    COPYTO   8
a:
    INBOX   
    COPYTO   0
    SUB      10
    JUMPN    i
    COPYFROM 0
    SUB      11
    JUMPN    e
    COPYFROM 9
    COPYTO   2
    COPYFROM 0
    SUB      8
    JUMPN    b
    COPYTO   0
    COPYFROM 6
    COPYTO   2
b:
c:
    COPYFROM 0
    SUB      11
    JUMPN    d
    COPYTO   0
    BUMPUP   2
    JUMP     c
d:
    COPYFROM 2
    OUTBOX  
e:
    COPYFROM 9
    COPYTO   2
    COPYFROM 0
    SUB      7
    JUMPN    f
    COPYTO   0
    COPYFROM 6
    COPYTO   2
f:
g:
    COPYFROM 0
    SUB      10
    JUMPN    h
    COPYTO   0
    BUMPUP   2
    JUMP     g
h:
    COPYFROM 2
    OUTBOX  
i:
    COPYFROM 0
    OUTBOX  
    JUMP     a
```

### Year 39 - Re-Coordinator

★★

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    COPYFROM 14
    COPYTO   3
    INBOX   
b:
    SUB      15
    JUMPN    c
    COPYTO   0
    BUMPUP   3
    COPYFROM 0
    JUMP     b
c:
    ADD      15
    OUTBOX  
    COPYFROM 3
    OUTBOX  
    JUMP     a
```

### Year 40 - Prime Factory

分解质因数……别说让我用汇编写了， 让我用 Python 写我都不会写。幸好这关不是通关的关键路径，不然硬着头皮也得上了，先跳过。

### Year 41 - Sorting Floor

排序。写了个类似于冒泡的平方复杂度的排序，是真的完完整整的两层循环，所以指令数目标达成，但是步骤数的差距大得令人绝望，目标 714 实际 1642，估计得上次线性复杂度的排序了。

用汇编写快排你敢信！

★☆

```
-- HUMAN RESOURCE MACHINE PROGRAM --

a:
    COPYFROM 24
    COPYTO   20
b:
    INBOX   
    COPYTO   [20]
    JUMPZ    c
    BUMPUP   20
    JUMP     b
c:
d:
    COPYFROM 24
    COPYTO   21
e:
f:
    COPYFROM [21]
    COPYTO   23
    BUMPUP   21
    COPYFROM [21]
    JUMPZ    h
    COPYTO   19
    SUB      23
    JUMPN    g
    JUMP     f
g:
    COPYFROM 23
    COPYTO   [21]
    BUMPDN   21
    COPYFROM 19
    COPYTO   [21]
    BUMPUP   21
    JUMP     e
h:
    BUMPDN   20
    JUMPZ    i
    JUMP     d
i:
j:
    COPYFROM [20]
    JUMPZ    a
    OUTBOX  
    BUMPUP   20
    JUMP     j
```


[1]: http://tomorrowcorporation.com/humanresourcemachine
[2]: https://ipn.li/kernelpanic/43/
