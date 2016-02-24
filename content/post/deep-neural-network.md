+++
Description = "Deep Neural NetworkをCommon Lispで実装してみた話."
Tags = ["Common Lisp", "Deep Learning"]
date = "2016-02-23T23:10:20+09:00"
draft = true
title = "Deep Neural Network in Common Lisp"
slug = "deep-neural-network-in-common-lisp"
+++

Deep Neural Network (Multi-layer perceptroy) をCommon Lispで実装してみた話.

<!--more-->

そろそろ Deep Learing ぐらい勉強するかと思い [深層学習](http://www.amazon.co.jp/gp/product/B018K6C99A/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN=B018K6C99A&linkCode=as2&tag=rudolph-miller-22) という本を読んでいて、
ほんまにこんなんで学習できるんかいなと思ったので実装してみた.

<a rel="nofollow" href="http://www.amazon.co.jp/gp/product/B018K6C99A/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN=B018K6C99A&linkCode=as2&tag=rudolph-miller-22"><img border="0" src="http://ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=B018K6C99A&Format=_SL160_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=rudolph-miller-22" ></a><img src="http://ir-jp.amazon-adsystem.com/e/ir?t=rudolph-miller-22&l=as2&o=9&a=B018K6C99A" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

今回実装したのは順伝播型ニューラルネットワーク (Feed Forward Neural Network) で、
テストしたのは `Fisher's iris flower data set` (統計の有名なデータセット) の多クラス分類 (Multi-class classification) .

1. [Math]({{< relref "#math" >}})
2. [Impl]({{< relref "#impl" >}})
3. [Test]({{< relref "#test" >}})
4. [TODO]({{< relref "#todo" >}})
5. [See Also]({{< relref "#see-also" >}})


# Math


# Impl


# Test

Multi-class classificationをやってみた.

# TODO


- 自動微分
- MNIST
- 畳み込み層
- autoencoder
- Deep LearingではHello, world的な MNIST の手書き文字データの画像解析

# See Also

- [深層学習](http://www.amazon.co.jp/gp/product/B018K6C99A/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN=B018K6C99A&linkCode=as2&tag=rudolph-miller-22)
