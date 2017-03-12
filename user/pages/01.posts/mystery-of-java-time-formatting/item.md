---
title: 'Java 时间格式化：有去无回之谜'
date: '2016-11-18 01:10'
taxonomy:
    category:
        - blog
    tag:
        - Java
header_image_file: 'https://ws4.sinaimg.cn/mw1024/006tNbRwgw1f9vlk6yr4jj31jk0rsgs7.jpg'
math: true
comments: true
---

很长一段时间里，我一直以为，对于同一个时间格式，我们把一个时间对象序列化成字符串之后，还能反序列化成和原对象表达同一个时间的时间对象，至少在不考虑时区之类的问题时，这个命题应该成立。

$$
\forall F \in DateFormat, F(D)=S \rightarrow F^{-1}(S)=D
$$

然而就在这两天，我遇到了一个打破上述认知的奇怪问题，Date 对象格式化之后再解析回来，就完全乱套了。

===

```java
import java.text.SimpleDateFormat;
import java.util.Date;

public class WeekOfDay {

    public static void main(String[] args) throws Exception {
        SimpleDateFormat format = new SimpleDateFormat("YYYY-MM-dd");

        Date date = new Date(2016-1900, 11-1, 11);

        String formatted = format.format(date);
        System.out.println(formatted); // 2016-11-11

        Date fromTimestamp = format.parse(formatted);
        System.out.println(fromTimestamp); // Sun Dec 27 00:00:00 CST 2015
    }
}
```

这段代码可以重现这个问题。一番搜索之后发现，`YYYY` 是 Week Year，而 `yyyy` 是 Year，这里如果使用 `yyyy` 就可以避免 parse 之后时间混乱的问题。

但是为什么 parse 之后时间会变的这么离谱呢？调试代码一直跟踪到 `java.util.GregorianCalendar#setWeekDate`，才发现了其中奥秘。

![](https://ws4.sinaimg.cn/large/006tNbRwgw1f9vl94cztjj30no0aidhc.jpg)

由于格式中不包含 `WEEK_OF_YEAR`、`DAY_OF_WEEK` 等对应的标识，代码第 143 行将日历对象设置为 2016 年第一周第一天所在的日期和时间，这一天正好是 2015 年 12 月 27 日。

![](https://ws2.sinaimg.cn/large/006tNbRwgw1f9vld0bkefj30pz06pt92.jpg)

parse 的问题弄明白了，那么为什么 format 能正常工作呢？其实只是因为没有踩到边界条件而已。`YYYY` 是 Week Year，就是这一周第一天所处的年份，这几天还没到元旦，所以 format 的时候误打误撞拿到了正确的结果。

最后，全称量词果然还是要改成存在量词的~

$$
\exists F\in DateFormat, F(D)=S \wedge F^{-1}(S)=D
$$

