+++
Description = "How to setup PiTFT."
Tags = ["Raspberry Pi", "PiTFT"]
date = "2015-07-05T23:14:29+09:00"
title = "How To Setup PiTFT."

+++


***
PiTFT Mini Kitのセット方法
===

***
![](/images/20150705/pitft.jpg)


1. <a href="#pos1">What is PiTFT Mini Lit</a>
2. <a href="#pos2">Get PiTFT</a>
3. <a href="#pos3">Assemble PiTFT</a>
4. <a href="#pos4">Set PiTFT</a>

<a id="pos1"></a>
1. PiTFT Mini Kitとは
---

* PiTFT Mini Kitは販売元の[adafruit](https://www.adafruit.com/products/1601)から引用すると
>Is this not the cutest little display for the Raspberry Pi? It features a 2.8" display with 320x240 16-bit color pixels and a resistive touch overlay.

で、つまりRaspberry Pi用の2.8インチのカラータッチディスプレイのことです。

* adafruit industriesはNew Yorkの電子部品、電子工作の何でも屋。
* Raspberry Pi持っている方は上の写真をどこかしらで見かけたことがあるはず。
* ただ海外から注文だし、作り方とかむずかしそうっ手思っている方は意外と簡単にできるので、この記事を参考にしてみてください。

<a id="pos2"></a>
2. PiTFTを手に入れる。
---

* まずadafruitでの注文の仕方からはじめます。
adafruitのアカウントを持っておられない方はまずアカウントを取得して下さい。
* [サイト](http://www.adafruit.com/)右上のlog inからNew? Please Provide Your Billing Informationを埋めてSUBMIT
* 取得したアカウントでログインして、[商品ページ](https://www.adafruit.com/products/1601)に飛びます。adafruitから直接でもいいし、サイト内検索ボックスでPiTFTでもでできます。
* [商品ページ](https://www.adafruit.com/products/1601)の右側のAdd to Cart:<input type="test" size="5" value="1"></input>のボックスを必要な個数にして、<button>ADD TO CART</button>します。
* カートの中身を確認して<button>CHECK OUT</button>します。
* 配送方法を選択。
* 支払い方法を選択。
* 内容を確認してokなら<button>CONFIRM</button>します。
* Adafruit Industries <support@adafruit.com>から確認のメールが来るので確認します。
* あとはまっていたら届きます。
* 入力がめんどうなだけで、ほとんど国内サイトでの買い物と同様で購入することができます。
* Tips: _Google自動入力_で英語で名前と住所を登録しておくと自動で入力補完してくれるので便利です。

<a id="pos3"></a>
3. PiTFTの組み立て方
---
>[adafruit tutorials](http://learn.adafruit.com/adafruit-pitft-28-inch-resistive-touchscreen-display-raspberry-pi/assembly)

* 必要なもの
1. 半田ごて
2. 半田
3. 作業場所
* 小さいものなので机の上でも十分可能。ただし半田ごての際はまわりに気をつけて。
* 作業場所にPiTFT Mini KitとRaspberry Pi(__絶対に電源は抜いておいて下さい。__)と半田ごて、半田を用意します。
![](/images/20150705/raspberry_pi_parts.jpg)
* 写真右下のGPIOピンソケット(female header)をRaspberry Piの黒いとげとげ(GPIO port)に差し込みます。
![](/images/20150705/raspberry_pi_tallheader.jpg)
* その上にPiTFT本体を、画面を上にしてピンがコネクター全部を通るよう差し込みます。
* あとはすべてのピンを半田付けしていくだけです。  
![](/images/20150705/raspberry_pi_solder1.jpg)
![](/images/20150705/raspberry_pi_solder2.jpg)
<div style="clear: both;"> </div>
* すべて半田付けできたら、ディスプレイ裏のシールをはがして、基盤にはりつけます。
* これで組み立ては完成です。

<a id="pos4"></a>
4. ソフトのインストールと設定
---
* これに一番手間取りました。
>参考: [adafruit tutorials](http://learn.adafruit.com/adafruit-pitft-28-inch-resistive-touchscreen-display-raspberry-pi/software-installation)
* まずはじめにこのソフトはRaspbianで動くようになっているのですが、最新版のRaspbianでは動かないようです。なので推奨されている[September 2013]( http://downloads.raspberrypi.org/raspbian/images/raspbian-2013-09-27/2013-09-25-wheezy-raspbian.zip)をダウンロード、解凍してSDに焼いて準備(`$ sudo raspe-config`や`$ sudo apt-get updare`、さらにモニターに繋ぐかSSHで接続)します。
* まずカレントディレクトリに必要なファイルをダウンロードします。
```sh
$ cd ~
$ wget http://adafruit-download.s3.amazonaws.com/libraspberrypi-bin-adafruit.deb
$ wget http://adafruit-download.s3.amazonaws.com/libraspberrypi-dev-adafruit.deb
$ wget http://adafruit-download.s3.amazonaws.com/libraspberrypi-doc-adafruit.deb
$ wget http://adafruit-download.s3.amazonaws.com/libraspberrypi0-adafruit.deb
$ wget http://adafruit-download.s3.amazonaws.com/raspberrypi-bootloader-adafruit-112613.deb
```
* 次にそれらをインストールします。
```sh
$ sudo dpkg -i -B *.deb
```
* 再起動します。(PiTFTをすでにセットしている場合は
```sh
$ sudo reboot
```
まだの場合は
```sh
$ sudo shutdown -h now
```
で電源を切ったあとで、PiTFTをセットして起動して下さい。)
* ドライバをインストールします。
```sh
$ sudo modprobe spi-bcm2708
$ sudo modprobe fbtft_device name=adafruitts rotate=90
```
* PiTFTの画面が白から黒に変わったと思います。(代わりが無ければもう一度実行。)
* PiTFTでXserverを走らせて見ます。
```sh
$ export FRAMEBUFFER=/dev/fb1
$ startx
```
* PiTFTにデスクトップが映っていれば成功です。Ctrl-cか、デスクトップをマウス操作してログアウトします。
* 次に起動時にこれらのモジュールが自動でロードされるようにします。
* ここからのコマンドはVimが入っている前提で、エディタはVimで実行していきます。なぜなら__Vimmerだから__。
* `$ sudo vim /etc/modules`でmodulesを開き、以下の2行を加え保存します。
```
spi-bcm2708
fbtft_device
```
* 次に設定ファイルを作ります。
`$ sudo vim /etc/modprobe.d/adafruit.conf`で、次を書き込み保存します。
```
options fbtft_device name=adafruitts rotate=90 frequency=32000000
```
※rotateの値は画面の傾きです。0でadafruitのロゴが下で、そこから時計回りです。
* 再起動してみて、コンソールの表示が以下のようになっているかみます。
![](/images/20150705/raspberry_pi_dmesgdetect.png)
* 次にタッチスクリーンの設定をします。
```sh
$ sudo mkdir /etc/X11/xorg.conf.d
$ sudo vim /etc/X11/xorg.conf.d/99-calibration.conf
```
でファイルを作成して以下を書き込み保存します。
```
Section         "InputClass"
Identifier      "calibration"
MatchProduct    "stmpe-ts"
Option          "Calibration"   "3800 200 200 3800"
Option          "SwapAxes"      "1"
EndSection
```
![](/images/20150705/raspberry_pi_xorgconf.png)
* 動作するか確認します。
```sh
FRAMEBUFFER=/dev/fb1 startx
```
* `FRAMEBUFFER=`を毎回入力するのが面倒な場合は、
`$ sudo vim ~/.profile`に以下を上の方に追加して保存し、再起動して反映させます。
```
export FRAMEBUFFER=/dev/fb1
```
* タッチスクリーンの調整を行います。
> [adafruit tutorials](http://learn.adafruit.com/adafruit-pitft-28-inch-resistive-touchscreen-display-raspberry-pi/touchscreen-install-and-calibrate)

* コンソールを表示させます。
* boot configulationファイルを更新して、起動時にHDMI/TV出力の/dev/fb0の変わりにPiTFTの/dev/fb1を使用するようにします。
`$ sudo vim /boot/cmdline.txt`開いて、_rootwait_という文字列を探し、そのすぐ後に
```
fbcon=map:10 fbcon=font:VGA8x8
```
と書き込んで保存します。
![](/images/20150705/raspberry_pi_fbcon.png)
* 次の起動からPiTFTにコンソールが表示されるはずです。
![](/images/20150705/raspberry_pi_1601console_LRG.jpg)

* あといくつかPiTFTでの遊び方や設定、アドバンスド名トピックが公式の[tutolials](http://learn.adafruit.com/adafruit-pitft-28-inch-resistive-touchscreen-display-raspberry-pi/overview)では扱われています。

* 長かったですがお疲れ様でした。PiTFTを使用したlike Hackingなideaがありましたらぜひ教え下さい。
