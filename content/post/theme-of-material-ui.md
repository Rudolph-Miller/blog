+++
Description = "Theme of Material-UI"
Tags = ["React.js", "Material Design", "Material-UI"]
date = "2016-01-05T10:57:35+09:00"
draft = true
title = "Theme of Material-UI"
slug = "theme-of-material-ui"
+++

Material-UIのThemeの使い方を紹介.

<!--more-->

1. [Material-UI]({{< relref "#material-ui" >}})
2. [Theme]({{< relref "#theme" >}})
3. [See Also]({{< relref "#see-also" >}})


# Material-UI

Material-UIとMaterial Designについては[前回]({{< relref "post/material-ui.md" >}})の記事を参照.


# Theme

Material Designでは色をPrimary color paletteとSecondary color (Accent color) paletteに限定することにより、
直感的で統一感のあるDesignを作り出している.

Material-UIではこれをThemeとして管理する.


## Usage

[前回]({{< relref "post/material-ui.md" >}})の記事の[Example]({{< relref "post/material-ui.md#example" >}})でThemeを使用してみる.

```js
import ThemeManager from 'material-ui/lib/styles/theme-manager';
import ThemeDecorator from 'material-ui/lib/styles/theme-decorator';
import Colors from 'material-ui/lib/styles/colors';
import ColorManipulator from 'material-ui/lib/utils/color-manipulator';
import LightRawTheme from 'material-ui/lib/styles/raw-themes/light-raw-theme';

export default ThemeManager.modifyRawThemePalette(
  ThemeManager.getMuiTheme(LightRawTheme),
  {
    primary1Color: Colors.cyan500,
    primary2Color: Colors.cyan700,
    primary3Color: Colors.lightBlack,
    accent1Color: Colors.green400,
    accent2Color: Colors.grey100,
    accent3Color: Colors.grey500,
    textColor: Colors.blueGrey800,
    alternateTextColor: Colors.white,
    canvasColor: Colors.white,
    borderColor: Colors.grey300,
    disabledColor: ColorManipulator.fade(Colors.darkBlack, 0.3),
    pickerHeaderColor: Colors.cyan500
  }
)
```

```diff
 import { render } from 'react-dom';
 import React, { Component, PropTypes } from 'react';
 import injectTapEventPlugin from 'react-tap-event-plugin';
 injectTapEventPlugin();
 
 import {
   Avatar, Card, CardActions,
   CardHeader, CardMedia, CardTitle,
-  RaisedButton, FlatButton, CardText
+  RaisedButton, FlatButton, CardText,
+  ThemeWrapper
 } from 'material-ui';
+import ThemeDecorator from 'material-ui/lib/styles/theme-decorator';

+import Theme from './theme';
 
+@ThemeDecorator(Theme)
 class App extends Component {
 ...
}
```

簡単にPrimary colorなどを変更できるが、Themeとして変更することにより、統一感が崩れない.


## Font Family

日本語でMaterial DesignならNotoをMaterial-UIで使う.


# See Also

- [Material-UIの紹介]({{< relref "post/material-ui.md" >}})
