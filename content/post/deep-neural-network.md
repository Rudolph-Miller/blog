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

そろそろ Deep Learing ぐらい勉強するかと思い
[深層学習](http://www.amazon.co.jp/gp/product/B018K6C99A/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN=B018K6C99A&linkCode=as2&tag=rudolph-miller-22)
という本を読んでいて、
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
$d _{nk}$ は n 番目のTraining sampleの k 番目のUnitの目標値、
$y _{nk}$ は n 番目のTraining sampleの k 番目のUnitのOutput.

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


## Back propagation

Gradient Descent Method を実行するには

$$
\nabla E = \frac{\partial W}{\partial E} = [\frac{\partial E}{\partial w_1} ... \frac{\partial E}{\partial w _M}]^{T} \tag{9}
$$

を計算する必要があるが、微分の連鎖規則のため、Output Layerから遠いLayerになると微分計算が困難になる.

これを解決するのが __Back propagation (誤差逆伝播法)__.
Back propagation はOutput LayerからInput Layerに向かって、連鎖的に勾配を計算していく方法.

n 番目のTraining sampleのError functionの値 $E_n$ をLayer $p$ におけるParameter $w _{ji}^{(p)}$ に関して微分すると、
$w _{ji}^{(p)}$ は

$$
u_j^{(p)} = \sum _{i=0}^{I} w _{ji} z _{i}^{(p-1)} \tag{4}
$$

により $u_j^{(p)}$ の中にのみ存在するので、

$$
\frac{\partial E_n}{\partial w _{ji}^{(p)}} = \frac{\partial E_n}{\partial u _{j}^{(p)}} \frac{\partial u _{j}^{(p)}}{\partial w _{ji}^{(p)}} \tag{12}
$$

となる.

$u_j^{(p)}$ の変動が $E_n$ に与える影響は、
このUnit $j$からのOutput $z_j^{(p)}$ を通じて、$p+1$ LayerのOutputを変化させることによってのみ生じるので、
(12) の右辺第1項は

$$
\frac{\partial E_n}{\partial u _{j}^{(p)}} = \sum _k \frac{\partial E_n}{\partial u_k^{(p+1)}} \frac{\partial u_k^{(p+1)}}{\partial u_j^{(p)}} \tag{13}
$$

となる.

左辺の $\frac{\partial E_n}{\partial u _{j}^{(p)}}$ と右辺の $\frac{\partial E_n}{\partial u _{j}^{(p+1)}}$ に注目して、

$$
\delta _j^{p} = \frac{\partial E_n}{\partial u _{j}^{(p)}} \tag{14}
$$

とおく.

$$
u_k^{(p+1)} = \sum _j w _{kj}^{(p+1)} z_j^{(p)} = \sum _j w _{kj}^{(p+1)} f(u_j^{(p)}) \tag{15}
$$

より、

$$
\frac{\partial u_k^{(p+1)}}{\partial u_j^{(p)}} = w _{kj}^{(p+1)} f'(u_j^{(p)}) \tag{16}
$$

となるので、 (13) は

$$
\delta _j^{(p)} = \sum _k \delta _j^{(p+1)} (w _{kj}^{(p+1)} f'(u_j^{(p)})) \tag{17}
$$

となる. これは $\delta _j^{(p)}$ が $\delta _k^{(p+1)} (k = 1, 2, ...)$ から計算できることを意味する.

(12) の右辺第1項はこのように $\delta$ を計算することで得られる.
第2項は $u_j^{(p)} = \sum _i w _{ji}^{(p)} z_i^{(p-1)}$ から

$$
\frac{\partial u _{j}^{(p)}}{\partial w _{ji}^{(p)}} = z_i^{(p-1)} \tag{18}
$$

が得られるので、目的の微分は

$$
\frac{\partial E_n}{\partial w _{ji}^{(p)}} = \delta _j^{(p)} z_i{(p-1)} \tag{19}
$$

となり、 $p-1$ Layerと $p$ LayerをつなぐConnectionの重み $w _{ji}^{(p)}$ に関する微分は、
Unit $j$ に関する $\delta _j^{(p)}$ と Unit $i$ のOutput $z_i^{(p-1)}$ のただの積で与えられる.
$\delta$ はOutput LayerからInput Layerに順に (17) を適用すれば求められる.
Output Layerでの $\delta$ は

$$
\delta _j^{(P)} = \frac{\partial E_n}{\partial u_j^{(P)}} \tag{20}
$$

で計算できる.

今回はOutput LayerのError functionは (7) を使用し
( n 番目のTrainig sampleに関しては $-\sum _{k=1}^{K} d _{nk} \log y _{nk}$)、
Activation functionにSoftmax functionを使用しているので、

$$
E_n = - \sum _k d_k \log y_k = - \sum _k d_k log (\frac{e^{u_k^{(P)}}}{\sum _i e^{u_i^{(P)}}}) \tag{21}
$$

となり、

$$
\delta _j^{(P)} = - \sum _k d_k \frac{1}{y_k} \frac{\partial y_k}{\partial u_j^{(P)}}
= -d_j(1-y_j) - \sum _{k \neq j} d_k(-y_j)
= \sum _k d_k (y_j - d_j)
\tag{22}
$$

で $\delta$ が求められる.

(20) ( 今回は具体的には (22) ) と (17) により任意のLayerの $\delta$ が求められるので、 (19) により任意のConnectionの重み $w$ を更新できる.


# Impl

順電波型ニューラルネットワークのcoreなところを追ったところで実装.
数式の流れをちゃんと理解できてたら大したこと無い.

※以下のCodeは動く状態では書いてないので脳内である程度補完.

{{% image "/20160226/impl_1.png" %}}

上の図を `CLOS` に落とし込む.

```common-lisp
(defclass unit ()
  ((input-value ...)
   (output-value ...)
   (left-connections ...)
   (right-connections ...)
   (delta ...)))

(defclass bias-unit (unit) ())

(defclass connection ()
  ((left-unit ...)
   (right-unit ...)
   (weight ...)
   (weight-diff ...)))

(defclass layer ()
  ((bias-unit ...)
   (units ...)))

(defclass input-layer (layer) ())

(defclass hidden-layer (layer)
  ((bias-unit :initform (make-instance 'bias-unit))))

(defclass output-layer (layer)
  ((bias-unit :initform (make-instance 'bias-unit))))

(defclass dnn ()
  ((layers ...)
   (connections ...)))
```

Input Layer以外のLayerのUnitのInputは (4) なので

```common-lisp
(defun calculate-unit-input-value (unit)
  (reduce #'+
          (mapcar #'(lambda (connection)
                      (* (unit-output-value (connection-left-unit connection))
                         (connection-weight connection)))
                  (unit-left-connections unit))))
```

で、OutputはBias Unit (Outputが1) 以外は (2) なので

```common-lisp
(defgeneric calculate-unit-output-value (unit)
  (:method ((unit unit))
    (funcall activatinon-function (unit-input-value unit)))
  (:method ((unit bias-unit))
    (declare (ignore unit))
    1))
```

のように計算できる.

これをInput LayerからOutput Layerまで繰り返してネットワークの出力を得る.

```common-lisp
(defun predict (dnn input)
  (dolist (layer (dnn-layers dnn))
    (etypecase layer
      (input-layer
       (map nil
            #'(lambda (input-unit value)
                (setf (unit-input-value input-unit) value
                      (unit-output-value input-unit) value))
            (layer-units layer)
            input))
      ((or hidden-layer output-layer)
       (let ((units (layer-units layer)))
         (dolist (unit units)
           (let ((input-value (calculate-unit-output-value unit)))
             (setf (unit-input-value unit) input-value
                   (unit-output-value unit)
                   (calculate-unit-output-value unit))))))))
  (mapcar #'unit-output-value
          (layer-units (output-layer (dnn-layers dnn)))))
```

これにError functionを適用する.

```common-lisp
(defun test (dnn data-set)
  (/ (reduce #'+
             (mapcar #'(lambda (data)
                         (funcall error-function
                                  (predict dnn (data-input data))
                                  (data-expected data)))
                     data-set))
     (length data-set)))
```

あとは (20) と (17) で $\delta$ を計算し、

```common-lisp
(defgeneric calculate-delta (layer unit)
  (:method ((layer output-layer) unti)
    ...)
  (:method ((layer hidden-layer) unit)
    ...))
```

Back propagationで `connection` の `weight` を更新すれば学習ができる.

```common-lisp
(defun train (dnn data-set)
  (dolist (data data-set)
    (predict dnn (data-input data))
    (dolist (layer (reverse (cdr (dnn-layers dnn))))
      (dolist (unit (layer-units layer))
        (let ((delta (calculate-delta layer unit)))
          (setf (unit-delta unit) delta)
          (dolist (connection (unit-left-connections unit))
            (incf (connection-weight-diff connection)
                  (* delta
                     (unit-output-value
                      (connection-left-unit connection))))))))
    (dolist (outer-connections (dnn-connections dnn))
      (dolist (inner-connectios outer-connections)
        (dolist (connection inner-connectios)
          (decf (connection-weight connection)
                (* (dnn-learning-coefficient dnn)
                   (connection-weight-diff connection)))
          (setf (connection-weight-diff connection) 0))))))
```

これだけで順電波型ニューラルネットワークが実装できる.  
(実際は `connection` の `weight` を平均0で分散1の正規乱数で初期化や、
Inputの正規化や、Mini-batchで学習の実装もしている.)


# Test

`Fisher's iris flower data set` (統計の有名なデータセット) の多クラス分類 (Multi-class classification) をやってみる.

データセット自体は R で `iris` とかやると出てくるもので、
`iris dataset` とかで検索すれば手に入る.

どういうデータかというと、4つのInputと1つのLabelの集まりで、Labelは3種類ある.
そのためテストではInput Layerは4 Units、Hidden Layerは10 Units、Output Layerは3 Unitsで組んだ.
Hidden LayerのLayer数やUnit数は適当.

今回使ったデータセットは150サンプルあるので、それを15サンプルずつの10セットに分ける.
そのうち1セットをテストデータとして取り、残りを教師データとして学習に使用する.
教師データでの学習の度に学習データを `test` にかけ Error function の値をとり、
それが一定以下になるか、指定の学習回数を経るとと学習を打ち切る.
学習のあとにテストデータで `predict` を行って正解数を記録する.
それを10セット繰り返す.
最後に正解率を出す.


```common-lisp
(defun data-sets ()
  ...)

(defun main (&optional (training-count 0))
  (let* ((layers (make-layers (list (list 'input-layer 4)
                                    (list 'hidden-layer 10 'rectified-linear-unit)
                                    (list 'output-layer 3 'softmax))))
         (connections (connect layers))
         (dnn (make-instance 'dnn
                             :layers layers
                             :connections connections
                             :learning-coefficient 0.001))
         (data-sets (data-sets))
         (correc-count 0)
         (test-count 0))
    (dolist (test-data-set data-sets)
      (let ((train-data-set (apply #'append (remove test-data-set data-sets))))
        (loop repeat training-count
              do (train dnn train-data-set)
              until (< (test dnn train-data-set) 0.01))
        (dolist (data test-data-set)
          (incf test-count)
          (let ((result (predict dnn (data-input data))))
            (when (= (position (apply #'max result) result)
                     (data-expected data))
              (incf correc-count))))))
    (format t "Accuracy: ~,2f%~%" (* 100 (/ correc-count test-count)))))
```

学習回数を0から10000で増やしながら順に実行する.

```common-lisp
(dolist (times (list 0 10 100 1000 10000))
  (format t "TIMES: ~a~%" times)
  (loop repeat 3
        do (main times)))
```

結果は

```
```



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

組織も理想に近い人からちゃんと (理想の方向に向かって) 学習していけば末端まで学習でき、
それを繰り返せば極小点が見つかる.
いくらやってもだめなときは相対的に小さく無い極小点にはまってるから、
別のsampleで学習する必要がある.


# See Also

- [深層学習](http://www.amazon.co.jp/gp/product/B018K6C99A/ref=as_li_tf_il?ie=UTF8&camp=247&creative=1211&creativeASIN=B018K6C99A&linkCode=as2&tag=rudolph-miller-22)
