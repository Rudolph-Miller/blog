+++
Description = "React Native on Android device."
Tags = ["React.js", "JavaScript", "React Native", "Android"]
date = "2015-09-16T10:06:16+09:00"
draft = false
slug = "react-native-on-android-device"
title = "React Native on Android device"
+++

React Native for Androidを実機で動かす.

<!--more-->

1. [Run on device]({{< relref "#run-on-device" >}})
1. [See Also]({{< relref "#see-also" >}})


Run on device
---

まずUSB Debugging ModeをONにする.

するとAndroid端末を開発機にUSBで接続して、`react-native run-android`を実行すると、
端末にApplicationのインストールが可能と起動が可能となる.

そしてこの真っ赤なエラー画面に遭遇して面食らう.

![Error on device](/images/20150916/error.png)

なにが起こっているか.

`index.android.bundle`を`localhost:8081`から取ってこようとして、接続できなくエラーとなっている.
つまりbundleしたJavaScriptファイルを開発機から取ってこようとして失敗したと.

そのため開発サーバーに接続すれば良く、とりあえず2通りの方法がある.


### Using adb reverse

`adb reverse`を使用して、端末の`tcp:8081`で開発機の`tpc:8081`を参照できるようにする.

```sh
adb reverse tcp:8081 tcp:8081
```

これだけで他の設定を変更することなく端末上で`Reload JS`などの開発オプションが使用できるようになる.


### Configure device to connect to the dev server via Wi-Fi

端末の`Dev Settings`で`Debug server host`の設定を変更する.
この方法で開発機に接続するためには端末と開発機が同じWi-Fiに接続している必要がある.

Applicationで`menu`を表示する.
(端末のメニューボタンを押すかApplicationを開いた状態で端末を振ると表示される.)

`Dev Settings`、`Debug server host for device`と遷移し、開発機のIPアドレスを入力する.  
(OS XのIPアドレスは`システム環境設定`、`ネットワーク`と遷移して、接続中のネットワークのタブで確認できる.)

すると端末上で`Reload JS`などの開発オプションが使用できるようになる.


See Also
---

- [Running On Device(Android)](http://facebook.github.io/react-native/docs/running-on-device-android.html)
- [Using Handware Devices](http://developer.android.com/tools/device.html)
