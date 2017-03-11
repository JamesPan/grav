---
title: Blog
sitemap:
    changefreq: hourly
body_classes: 'header-image fullwidth'
child_type: item
content:
    items: '@self.children'
    limit: 10
    order:
        by: date
        dir: desc
    pagination: true
    url_taxonomy_filters: true
blog_url: blog
feed:
    description: 'James Pan''s Blog'
    limit: 10
pagination: true
routes:
    aliases:
        - /atom
---

<img src="https://i.imgur.com/ddkDCh6.png" alt="Simplicity is prerequisite for reliability">
