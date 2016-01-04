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

Material DesignはGoogleが開発しているDesign Guidelineで__一貫性と実世界と同じ挙動でユーザーの負担を軽くする__ことが目標で、 __マテリアル（素材）のある世界__ が特徴.

あらゆるdeviceを対象とした__一貫性__と__周りの世界と連続的で、同じ物理的性質や同じ動き__で、ユーザーがあらゆるdeviceであらゆるApplicationで、それぞれでの操作を学習する必要無く、自然に使えるようになる.


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

```js
import { render } from 'react-dom';
import React, { Component, PropTypes } from 'react';
import injectTapEventPlugin from 'react-tap-event-plugin';
injectTapEventPlugin();

import {
  Avatar, Card, CardActions,
  CardHeader, CardMedia, CardTitle,
  FlatButton, CardText
} from 'material-ui';

class App extends Component {
  render() {
    return (
      <Card>
        <CardHeader
          title="Title"
          subtitle="Subtitle"
          avatar={<Avatar style={{color: 'red'}}>A</Avatar>}/>
        <CardHeader
          title="Demo Url Based Avatar"
          subtitle="Subtitle"
          avatar="http://lorempixel.com/100/100/nature/"/>
        <CardMedia overlay={<CardTitle title="Title" subtitle="Subtitle"/>}>
          <img src="http://lorempixel.com/600/337/nature/"/>
        </CardMedia>
        <CardTitle title="Title" subtitle="Subtitle"/>
        <CardActions>
          <FlatButton label="Action1"/>
          <FlatButton label="Action2"/>
        </CardActions>
        <CardText>
          Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          Donec mattis pretium massa. Aliquam erat volutpat. Nulla facilisi.
          Donec vulputate interdum sollicitudin. Nunc lacinia auctor quam sed pellentesque.
          Aliquam dui mauris, mattis quis lacus id, pellentesque lobortis odio.
        </CardText>
      </Card>
    );
  }
}

render(<App />, document.getElementById('app'));
```

{{% image "20160104/example.png" %}}

こんな感じにComponentに `props` を渡すだけ.


# See Also

- [Material UI - GitHub](https://github.com/callemall/material-ui)
- [Material UI - Document](http://www.material-ui.com/#/home)
- [react-tap-event-plugin](https://github.com/zilverline/react-tap-event-plugin)
- [Materail Design](https://www.google.com/design/spec/material-design/introduction.html)
