+++
Description = "Redux Fetch Action"
Tags = ["React.js", "Redux"]
date = "2015-12-15T00:35:49+09:00"
draft = true
title = "Redux Fetch Action"
slug = "redux-fetch-action"
+++

Redux Fetch ActionというReduxのFetch actionのutilityを作った.

<!--more-->

1. [Redux Fetch Action]({{< relref "#redux-fetch-action" >}})
2. [See Also]({{< relref "#see-also" >}})


# Redux Fetch Action

最近[Redux](https://github.com/rackt/redux)を使っているが、DataのFetchが似たようなAction creatorとReducerのpatternになったので、
切り出してpublishした. (`POST` もFetchかよって違和感はありますが.)

[Redux Fetch Action](https://github.com/Rudolph-Miller/redux-fetch-action)

FluxのActionには[非公式のCoding規約](https://github.com/acdlite/flux-standard-action)があるらしく、
それに則るため[redux-actions](https://github.com/acdlite/redux-actions)をbaseとしている.


# See Also

- [Redux Fetch Action](https://github.com/Rudolph-Miller/redux-fetch-action)
- [redux-actions](https://github.com/acdlite/redux-actions)
- [Redux](https://github.com/rackt/redux)
- [Redux: Actionのコーディング規約 と redux-actions](http://qiita.com/yasuhiro-okada-aktsk/items/a14f7f37262fb6cf0bf8)
