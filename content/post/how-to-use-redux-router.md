+++
Description = "How to use Redux Router"
Tags = ["React.js", "Redux"]
date = "2015-12-22T00:27:25+09:00"
draft = true
title = "How to use Redux Router"
slug = "how-to-user-redux-router"
+++

Redux Routerの使い方.

<!--more-->

1. [Redux Router]({{< relref "#redux-router" >}})
2. [See Also]({{< relref "#see-also" >}})


# Redux Router

## About

[Redux Router](https://github.com/acdlite/redux-router)はReact.jsでde facto standardとなっているRouting libraryの
[React Router](https://github.com/rackt/react-router)の[Redux](https://github.com/rackt/redux) bindings.

React RouterのRedux bindingsはReact RounterもReduxも抱えているOrganizationの[rackt](https://github.com/rackt)が作っている
[redux-simple-router](https://github.com/rackt/redux-simple-router)もあるが、Redux Routerの方が現時点でGitHubのStar数は多い.
(名前の通り、redux-simple-routerの方がよりsimpleで、Redux Routerはfatでcomplexだが機能は多い.)

{{% image "/20151222/rackt.gif" %}}

これは[rackt.org](http://rackt.org/). サイトではもっと綺麗にうねうねしてる.


## Why

ReduxはStateの管理を容易に (一様に) するが、単体でReact Routerを使用すると、
Application上の重要なStateであるURLがReduxでの管理からはずれてしまう.  
Redux RouterによりURLのStateもReduxで管理できる.


## Usage

とりあえずReduxでApplicationを作って、そこにReact Routerを導入、最後にRedux Routerを導入する手順で紹介する.


### Redux


### React Router


### Redux Router


# See Also

- [Redux Router](https://github.com/acdlite/redux-router)
- [React Router](https://github.com/rackt/react-router)
- [Redux](https://github.com/rackt/redux)
- [redux-simple-router](https://github.com/rackt/redux-simple-router)
