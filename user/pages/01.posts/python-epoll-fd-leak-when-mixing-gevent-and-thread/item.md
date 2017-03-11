---
title: 'Python 坑：混合使用 gevent 和 thread 造成 epoll fd 泄露'
published: false
taxonomy:
    category:
        - blog
        - Study
    tag:
        - Python
        - Linux
---

这是去年圣诞节前后遇到的真实问题。那时我正在和组里的同事们一起去外面浪，浪着浪着