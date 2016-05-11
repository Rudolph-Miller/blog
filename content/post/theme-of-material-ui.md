+++
Description = "Theme of Material-UI"
Tags = ["React.js", "Material Design", "Material-UI"]
date = "2016-01-11T21:15:39+09:00"
draft = false
slug = "theme-of-material-ui"
title = "Theme of Material-UI"
images = ["/20160111/theme-applied.png"]
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


## Color

[前回]({{< relref "post/material-ui.md" >}})の記事の[Example]({{< relref "post/material-ui.md#example" >}})にThemeを適用し、Colorを変更する.

Colorの指定は[Color palette](https://www.google.com/design/spec/style/color.html#color-color-palette)とMaterial-UIの[customization/colors](http://www.material-ui.com/#/customization/colors)を参照.

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

を `theme.js` に書き込み、

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

`@ThemeDecorator` で適用する.

{{% image "/20160111/theme-applied.png"  %}}

簡単にColorなどを変更できるが、Themeとして管理することにより、統一感が崩れない.


## Font Family

Material-UIのdefaultの `font-family` は `'Roboto', sans-serif` だが、日本語などの `Roboto` でカバーされていない言語の場合 `Noto` を使用したい.  
(Material Designの[Typography](https://www.google.com/design/spec/style/typography.html#typography-typeface)参考.)

今回は `Noto Sans JP` を使用するため、あらかじめHTMLに

```html
<link href='http://fonts.googleapis.com/earlyaccess/notosansjp.css' rel='stylesheet' type='text/css'>
```

を差し込む.

あとは上記の `theme.js` で

```diff
 export default ThemeManager.modifyRawThemePalette(
-  ThemeManager.getMuiTheme(LightRawTheme),
+  ThemeManager.modifyRawThemeFontFamily(
+    ThemeManager.getMuiTheme(LightRawTheme),
+    "'Roboto', 'Noto Sans JP', sans-serif"
+  ),
   {
     primary1Color: Colors.cyan500,
     primary2Color: Colors.cyan700,
```

のように `ThemeManager.modifyRawThemeFontFamily` で `font-family` を変更する.

{{% image "/20160111/font-family-not-changed.png" %}}

{{% image "/20160111/font-family-changed.png" %}}


# See Also

- [Material-UIの紹介]({{< relref "post/material-ui.md" >}})
- [Color palette](https://www.google.com/design/spec/style/color.html#color-color-palette)
- [Material-UI customization/colors](http://www.material-ui.com/#/customization/colors)
- [Typography](https://www.google.com/design/spec/style/typography.html#typography-typeface)
