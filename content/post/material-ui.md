+++
Description = "Material-UI"
Tags = ["React.js","Material Design"]
date = "2015-12-28T10:56:18+09:00"
draft = true
title = "Material-UI"
+++

Material-UIの紹介.

<!--more-->

1. [Material Design]({{< relref "#material-design" >}})
2. [Material-UI]({{< relref "#material-ui" >}})
3. [See Also]({{< relref "#see-also" >}})


# Material Design

Material DesignはGoogleが開発しているDesign Guidelineで  
__一貫性と実世界と同じ挙動でユーザーの負担を軽くする__  
ことが目標で、 __マテリアル（素材）のある世界__ が特徴.

あらゆるDeviseを対象とした__一貫性__と__周りの世界と連続的で、同じ物理的性質や同じ動き__で、ユーザーがあらゆるApplicationをあらゆるDeviseで、それぞれでの操作を学習する必要無く、自然に使えるようになる.


# Material-UI

## About

[Material-UI](https://github.com/callemall/material-ui)はMaterial DesignのReact.js実装.

Component群とThemeで簡単にMaterial Designを試すことができる.


## Install


```sh
npm install --save material-ui
```

で `material-ui` をinstallする.

いくつかのComponentで[React-Tap-Event-Plugin](https://github.com/zilverline/react-tap-event-plugin)を使用して、touch eventsをlistenしているので、

```sh
npm install --save react-tap-event-plugin
```

でinstallし、`Tap Event` を有効にするために、

```js
import injectTapEventPlugin from 'react-tap-event-plugin';
injectTapEventPlugin();
```

をApplicationのstart timeに実行する.


## Usage


# See Also

- [Material UI](https://github.com/callemall/material-ui)
- [react-tap-event-plugin](https://github.com/zilverline/react-tap-event-plugin)
