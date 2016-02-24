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

(1) における $b$ はBiasで、
UnitのInputは前層のOutputにConnectionの重みを掛けたものの和にBiasを足したものである.

ここで

{{% image "/20160224/math_2.png" %}}

のようにBias Unitという特別なUnit (Outputが常に $1$) を導入して、

$$
b_j^{(p)} = w _{j0} z _{0}^{(p-1)} \tag{3}
$$

のように $b$ をあらわすと (1) は

$$
u_j^{(p)} = \sum _{i=0}^{I} w _{ji} z _{i}^{(p-1)} \tag{4}
$$

のように書ける.

(2) における $f$ は __Activation function (活性化関数)__ と呼ばれる.
Activation functionはUnitへの入力から出力を計算する関数で
通常は単調増加する日線形関数を使用し、
一般にHidden LayerとOutput Layerで別の関数を使用する.

今回はHidden Layerで

$$
f(u) = \max(u, 0) \tag{5}
$$

のRectified Linear Unit (正規化線形関数)を使用し、Output Layerで

$$
f(u_k) = \frac{e^{u_k}}{\sum _{j=1}^{K} e^{u_j}} \tag{6}
$$

のSoftmax functionを使用する. ( $K$ はOutput LayerのUnit数、 $k$ はOutput LayerのUnit番号.)


## Error function

順電波型ニューラルネットワークはParameter $w$ を変えるとOutputが変化し、
良い $w$ を選ぶとネットワーク全体として望みの関数として振る舞うようになる.

__Traiting data__を用いて $w$ を調整することを学習という.

このときそれぞれのTraining sampleでのOutputと目標値の近さをあらわす関数を
__Error function (誤差関数)__ と呼ぶ

Error functionはHidden LayerのActivation functionとセットで設計され、
それらは問題の種類ごとに異なる.

今回は Multi-class classification なのでActivation functionにSoftmax functionを使用し、
Error functionには

$$
E(W) = - \sum _{n=1}^{N} \sum _{k=1}^{K} d _{nk} \log y _{nk} \tag{7}
$$

を使用する.
ここで $W$ はネットワークの全体の重みをまとめた行列で (3) によりBiasもここに入る、
$n$ はTrainig dataにおけるTraining sampleの番号、
$K$ はOutput LayerのUnit数、
$k$ はOutput LayerのUnit番号、
$d _{nk}$ は n 番目のData sampleの k 番目のUnitの目標値、
$y _{nk}$ は n 番目のData sampleの k 番目のUnitのOutput.

今回はMulti-class classificationなので、 $d _{nk}$ は

$$
\sum _{k=1}^{K} d _{k} = 1 \tag{8}
$$

で、正解のclassに対応する一つのUnitのOutputが 1 で、残りのUnitのOutputが 0 となる.


## Stachastic Gradient Descent

ネットワークの目的はError functionの値を小さくすることだが、
Error functionは一般に凸関数ではなく、大域的な最小解を直接得ることは通常不可能.

代わりに局所的な極小点を求める.
一般に $E(W)$ の極小点は複数存在するため、得た極小点が大域的な最小解となることはほぼ無いが、
それでもその極小点が十分小さい値ならば目的に貢献し得る.

局所的な極小点の探索方法はいくつかあるが、最も簡単なのが __Gradient Descent Method (勾配降下法)__.

Gradientというのは $W$ の成分数を $M$ として、

$$
\nabla E = \frac{\partial W}{\partial E} = [\frac{\partial E}{\partial w_1} ... \frac{\partial E}{\partial w _M}]^{T} \tag{9}
$$

というVectorで、
Gradient Descent Method は $W$ を $- \nabla E$ 方向に動かし、
これをなんども繰り返すことで局所的な極小点を探索する.

現在の重みを $W^{(t)}$ 、動かした後の重みを $W^{(t+1)}$ とすると

$$
W^{(t+1)} = W^{(t)} - \epsilon \nabla E \tag{10}
$$

とあらわされる.

このときの $\epsilon$ を __Learning rate (学習係数)__ と呼び、
一回の更新での $W$ の更新量を決める定数.
大きいと極小点に収束しない可能性があり、小さいと収束までの反復回数が多くなる.

Learing rateの決定にも手法があるが、今回はとりあえず定数で指定することにする.

Gradient Descent Method はTraining data全体に対してError functionの値を最小化する.

$$
E(W) = \sum _{n=1}^{N} E_n(w) \tag{11}
$$

これに対してTraining dataの一部を使って $W$ の更新を行う (さらに更新ごとにTraining samplesを取り替える) 手法を
__Stochastic Gradient Descent (確率的勾配降下法)__ と呼ぶ.

Stochastic Gradient Descent を使うと、 Gradient Descent Method に潜在する
*相対的に小さくない局所的な極小解にはまるリスク* を小さくできる.


# Impl


# Test

Multi-class classificationをやってみた.

# TODO


- 自動微分
- MNIST
- 畳み込み層
- autoencoder
- Deep LearingではHello, world的な MNIST の手書き文字データの画像解析
- 学習係数の決定
- regularization
    - weight decay
    - weight restriction
    - drop out

# See Also

- [深層学習](http://www.amazon.co.jp/gp/product/B018K6C99A/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN=B018K6C99A&linkCode=as2&tag=rudolph-miller-22)
