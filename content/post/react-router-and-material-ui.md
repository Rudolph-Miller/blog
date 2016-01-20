+++
Description = "React Router and Material-UI"
Tags = ["React.js", "Material-UI", "React Router"]
date = "2016-01-12T13:12:40+09:00"
draft = true
title = "React Router and Material-UI"
slug = "react-router-and-material-ui"
+++

Material-UIのButtonでReact RouterのLinkを使う.

<!--more-->

1. [Button in Material-UI]({{< relref "#button-in-material-ui" >}})
2. [React Router and Material-UI]({{ relref "#react-router-and-material-ui" >}})
3. [See Also]({{< relref "#see-also" >}})


# Button in Material-UI

Material-UIにはButtonのComponentが複数ある.
どれも `link-button` propertyでlinkにできる.


# React Router and Material-UI

React Routerの `Link` をMaterial-UIで使うには `container-element` propertyを使う.

```js
<FlatButtor
  linkButton={true}
  container-element={<Link to='/' />} />
```


# See Also
