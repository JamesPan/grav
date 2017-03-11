---
cc: true
comments: true
date: '2015-01-31 03:38:24'
hljs: true
jscomments:
  id: /2015/01/31/union-find/
  title: 高級數據結構之「并查集」
  url: http://blog.jamespan.me/2015/01/31/union-find/
math: true
routes:
  aliases:
  - posts/union-find
  default: /2015/01/31/union-find
taxonomy:
  category:
  - blog
  - Study
  tag:
  - Data Structure
  - OJ
title: 高級數據結構之「并查集」
---

# 背景

數據結構是計算機科學的基礎學科，其中許多簡單的數據結構早已被各種高級語言抽象成類庫，以方便人們使用，如數組、列表、優先隊列、哈希表等等。

我習慣於把那些比較難以抽象成通用組件的數據結構，稱爲「高級數據結構」。這些數據結構通常只適用於解決某幾類問題，在使用過程中還需要針對問題模型作出一些定製性的優化，如果硬要抽象成通用組建反而限制了它們的性能。

并查集夠高效地判斷兩個元素是否同屬一個集合、合併兩個集合，常用與解決一些不相交集合的合併和查詢問題，比如計算無向圖的聯通分量個數、染色，在 CodeForces 中，并查集的標籤是 [dsu][1]，因爲并查集的英文是 Disjoint Set Union，「并查集」這個翻譯可能更多的來自一個英文別稱 Merge–Find Set 。

===



# 實現

并查集有很多種實現方式，可以用鏈表實現，也可以用森林來實現。然後這兩種數據結構又各自可以用數組和指針來實現。所以說高級數據結構在使用的時候需要根據場景做定製才能發揮最佳性能。

因爲并查集的核心操作只有「合併」與「查找」，所以無論何種實現，都比較簡單。

## 鏈表

早期人們使用鏈表來實現并查集。鏈表的每個結點包含兩個指針，next 指向鏈表中的下一個結點，head 指向鏈表的頭結點。

對於一個有 n 個元素的集合，初始化的時候將他們都置爲鏈表的頭結點，於是我們得到了 n 個鏈表。

在判斷兩個元素是否屬於同一集合的時候，我們其實是判斷兩個元素所在結點是否位於同一個鏈表，既他們是否擁有同一個頭結點。這個操作只是簡單的指針取值+等值判斷，$O(1)$ 時間內完成。

在合併集合的時候，我們至少需要遍歷兩個集合中的一個，將 head 指針指向另一個鏈表的頭結點，然後還得拼接兩個鏈表，$O(n)$ 時間內完成。

由於鏈表實現沒法發揮并查集全部性能，且難以進一步優化，現在比較常見的并查集實現方式是森林。

## 森林

不同於一般的樹形結構，并查集使用的樹形結構的結點沒有指向孩子結點的指針，只有指向父結點的指針。

與鏈表實現類似，初始化的時候集合中的每個元素都是一棵樹的根結點，我們使用樹的根結點作爲集合的代表，這時候每個元素都是一個集合。

在合併集合的時候，只需要把結點 A 所在樹的跟結點的父指針，指向結點 B 或者結點 B 所在樹的跟結點。修改指針的指向在 $O(1)$ 時間內完成，整個合併操作的時間主要花在了尋找跟結點上。

查找跟結點的效率正比與樹的深度，一般來說我們可以認爲查找能在 $O(logN)$ 時間內完成，最快情況莫過於樹形結構退化爲鏈表，因此查找的最壞情況的時間複雜度爲 $O(n)$。

樸素的并查集森林實現如下。

### 結點定義

我們將結點初始化爲根結點，根結點的父結點就是自身。

```
class Node:
    def __init__(self, key=None, value=None):
        self.parent = self
        self.key = key
        self.value = value
```

### 查找結點所在集合

我們使用樹的根結點作爲集合的代表，查找結點所在集合，即返回結點所在樹的根結點。

下面是迭代的實現方式。

```
def find(node):
    p = node.parent
    while p.parent != p:
        p = p.parent
    return p
```

還有遞歸的實現方式。這種遞歸實際上是尾遞歸，現代編譯器可以將尾遞歸優化成迭代。

```
def find(node):
    if node.parent == node:
        return node
    return find(node.parent)
```



### 合併兩個集合

首先計算兩個結點所在樹的根結點，然後修改根結點的父結點指針。

```
def union(node1, node2):
    p1 = find(node1)
    p2 = find(node2)
    p1.parent = p2
```

# 優化

使用森林來作爲并查集的實現，不僅代碼簡單，還可以根據實際的性能需求進行優化。常見的并查集優化手段包括路徑壓縮等。

## 路徑壓縮

查找操作是合併操作中的耗時大戶，也是完成集合構造之後調用最頻繁的函數，對查找操作做優化能得到最大收益。

樸素的查找實現中，我們使用迭代或者遞歸去沿着結點的父指針一路遍歷，直到找到根結點，平均複雜度 $O(logN)$。如果我們在找到根結點之後，將沿途遍歷的結點的父指針全都指向根結點，下次再查找的時候，實際複雜度就是$O(1)$ 了。

遞歸的查找函數實現只需要做一點點修改，就能實現路徑壓縮。遞歸調用一直壓棧，直到遇到根結點開始返回，然後在返回過程中順便把沿途結點的父指針指向了根結點。

```
def find(node):
    if node.parent == node:
        return node
    node.parent = find(node.parent)
    return node.parent
```

遞歸的表達能力遠遠強於迭代，因爲遞歸是有去有回，迭代是一去不回。受馮·諾伊曼結構的限制，現實中的遞歸沒有理論中那麼好用，不但性能上不及迭代，一旦壓棧次數多了還可能棧溢出。迭代版本的路徑壓縮要麼需要使用一個列表來存儲沿途結點（空間換時間），要麼將沿途結點的父結點指針指向其祖父結點（時間換空間）。

```
def find(node):
    l = []
    p = node
    while p.parent != p:
        l.append(p)
        p = p.parent
    for n in l:
        n.parent = p
    return p
```

# 例題

## [277A Learning Languages][4]

這道題目其實是求聯通子圖的個數，直接使用并查集的森林實現即可。由於問題規模在輸入中給出，我們可以直接使用數組來實現。

## [356A Knight Tournament][5]

這道題目屬於區間染色問題，暴力算法的時間複雜度是 $O(n^2)$，直接就會超時。使用并查集的時候需要對合併操作稍加修改，增加染色的動作，同時跳過那些已經被染色過的區間。

# 參考文獻

1. [Disjoint-set data structure](http://en.wikipedia.org/wiki/Disjoint-set_data_structure)

[1]: http://codeforces.com/problemset/tags/dsu
[2]: http://en.wikipedia.org/wiki/Disjoint-set_data_structure
[3]: http://codeforces.com/blog/entry/12524
[4]: http://codeforces.com/problemset/problem/277/A
[5]: http://codeforces.com/problemset/problem/356/A