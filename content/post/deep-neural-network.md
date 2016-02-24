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


1. [Deep Neural Netwok]({{< relref "#deep-neural-network" >}})
2. [Math]({{< relref "#math" >}})
3. [Impl]({{< relref "#impl" >}})
4. [Test]({{< relref "#test" >}})
5. [TODO]({{< relref "#todo" >}})
6. [See Also]({{< relref "#see-also" >}})


# Deep Neural Network

Deep Neural Networkは多層構造のNeural Network.

{{% image "/20160224/dnn.png" %}}

Input Layer (入力層)、多層の Hidden Layer (中間層)、Output Layer (出力層) で構成され、
それぞれの層は単数または複数のUnitで構成される.

順電波型ニューラルネットワークではすべてのUnitがその前後の層のすべてのUnitと結合している.

学習というのは、ネットワークに与えたInputからのOutputを正解に近づけるようにParameterを調整すること.


# Math

とりあえず数式として俯瞰する.


## Activation function

{{% image "/20160224/math_1.png" %}}

連続した$p-1$層と$p$層を考える.

$u$はUnitの入力、$z$はUnitの出力、$w$はUnit間のConnectionの重みを表す.

これらの関係は

$$
u_j^{(p)} = \sum _{i=0}^{I} w _{ji} z _{i}^{(p-1)} + b_j^{(p)} \tag{1}
$$

$$
z_j^{(p)} = f(u_j^{(p)}) \tag{2}
$$

のようにあらわせる.

(1) における $b$ はBiasで、UnitのInputは前層のOutputにConnectionの重みを掛けたものの和にBiasを足したものである.

(2) における $f$ は __Activation function (活性化関数)__ と呼ばれる.

ここで

{{% image "/20160224/math_2.png" %}}

のようにBias Unitという特別なUnit (出力が常に $1$ となる) を導入して、

$$
b_j^{(p)} = w _{j0} z _{0}^{(p-1)} \tag{3}
$$

のように $b$ をあらわすと (1) は

$$
u_j^{(p)} = \sum _{i=0}^{I} w _{ji} z _{i}^{(p-1)} \tag{4}
$$

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
