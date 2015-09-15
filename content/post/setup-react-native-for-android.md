+++
Description = "Setup React Native for Android"
Tags = ["React.js", "JavaScript", "React Native", "Android"]
date = "2015-09-15T10:39:31+09:00"
draft = false
slug = "setup-react-native-for-android"
title = "Setup React Native for Android"
+++

OS XでのReact Native for Androidのセットアップを紹介.

<!--more-->

ようやくReact Native for Androidが公開されたので、
まずはOS Xでのセットアップを紹介.

1. [Install and configure SDK]({{< relref "#install-and-configure-sdk" >}})
1. [Install and run Android stock emulator]({{< relref "#install-and-run-android-stock-emulator" >}})
1. [Setup]({{< relref "#setup" >}})
1. [See Also]({{< relref "#see-also" >}})


Install and configure SDK
---

SDKのインストールと設定をする.

まずは[JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)の最新版をインストール.

`android-sdk`を`brew`でインストールします.

```sh
brew install android-sdk
```

次に

```sh
export ANDROID_HOME=/usr/local/opt/android-sdk
```

を`~/.zshrc`又は`~/.bashrc`に追加し再読み込み.

```sh
source ~/.zshrc
# source ~/.bashrc
```

`Android SDK Manager`を起動.

```sh
android
```

- Android SDK Build-tools version 23.0.1
- Android 6.0 (API 23)
- Android Support Repository

にチェックを入れて`Install Packages`.


Install and run Android stock emulator
---

Android emulatorをインストールして起動する.

```sh
android
```

で`Android SDK Manager`を起動して

- Intel x86 Atom System Image (for Android 5.1.1 - API 22)
  - `Android 5.1.1 (API 22)`のタブ中にあるので注意.
- Intel x86 Emulator Accelerator (HAXM installer)

にチェックを入れて`Install Packages`.  

### Configure HAXM

[HAXM](http://developer.android.com/tools/devices/emulator.html#vm-mac)の設定をする.

```
open /usr/local/Cellar/android-sdk/24.3.4/extras/intel/Hardware_Accelerated_Execution_Manager/IntelHAXM_1.1.4.dmg
```

`IntelHAXM_1.1.4.mpkg`をダブルクリックし、画面の指示に従ってインストールする.

インストール終了後、新しい`kernel extension`が正しく処理されていることを確認するため、

```sh
kextstat | grep intel
```

を実行し`com.intel.kext.intelhaxm`が表示されることを確認する.

これでHAXMの設定は完了.

### Run Android emulator

Android emulatorを起動する.

```sh
android avd
```

でAVD Managerを立ち上げ`Create...`でAVDを作成し`Start...`でEmulatorを立ち上げる.

![Create AVD](/images/20150915/CreateAVD.png)

又はすでに`~/.android/avd/`に`.avd`ファイルがあれば、  

```sh
# ls ~/.android/avd/
# => Nexus_5_API_23_x86.avd Nexus_5_API_23_x86.ini
emulator -avd Nexus_5_API_23_x86
```

でファイル名を指定してEmulatorを起動できる.


Setup
---

最後にReact Native本体のセットアップをする.

[NVM](https://github.com/creationix/nvm)や[nodenv](https://github.com/wfarr/nodenv)
などで`io.js 1.0 or newer`を準備する.  
(今回はnodenvとNode.js v4.0.0を使用.)

```sh
nodenv install v4.0.0
# nodenv global v4.0.0
```

npmでコマンドラインインターフェースの`react-native-cli`をインストールする.

```sh
npm install -g react-native-cli
# nodenv rehash
```

すると`react-native`コマンドが使用可能になるので、適当なディレクトリで

```sh
react-native init AwesomeProject
```

を実行すると、iOS用に`AwesomeProject/iOS/AwesomeProject.xcodeproj`と  
Android用に`AwesomeProject/android/app`とが生成される.

後は

```sh
cd AwesomeProject
react-native run-android
```

でEmulator又は(接続してsetupしていれば)実機でApplicationが立ち上がる.

![Welcome to React Native](/images/20150915/welcome-to-react-native.png)


See Also
---

- [React Native](http://facebook.github.io/react-native/)
- [Getting Started - React Native](http://facebook.github.io/react-native/docs/getting-started.html#content)
- [Android Setup - React Native](http://facebook.github.io/react-native/docs/android-setup.html)
- [Tutorial - React Native](http://facebook.github.io/react-native/docs/tutorial.html#content)
- [React Native for Android: How we built the first cross-platform React Native app](https://code.facebook.com/posts/1189117404435352)
