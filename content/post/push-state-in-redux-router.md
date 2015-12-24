+++
Description = "pushState in Redux Router"
Tags = ["React.js","Redux","Redux Router"]
date = "2015-12-23T14:03:05+09:00"
draft = true
title = "pustState in Redux Router"
+++

`pushState` を Redux Routerで使用する.

<!--more-->

1. [Redux Router]({{< relref "#redux-router" >}})
2. [pushState]({{< relref "#pushstate" >}})
3. [Usage]({{< relref "#usage" >}})
4. [mapDispatchToProps]({{< relref "#mapdispatchtoprops" >}})
5. [See Also]({{< relref "#see-also" >}})


# Redux Router


[Redux Router](https://github.com/acdlite/redux-router)は[前回](htpp://blog.rudolph-miller.com/2015/12/23/redux-router/)で紹介した通り、
React.jsでde facto standardとなっているRouting libraryの[React Router](https://github.com/rackt/react-router)の[Redux](https://github.com/rackt/redux) bindings.


# pushState

`pushState` はReact RouterでURLを書き換えるAPIで、元はBrowserのHistory API.
Redux Routeの `pushState` はこれをwrapしたもの.

# Usage

# mapDispatchToProps

# See Also

- [Redux Routerの使い方](http://blog.rudolph-miller.com/2015/12/23/redux-router/)
