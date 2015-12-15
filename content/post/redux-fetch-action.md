+++
Description = "Redux Fetch Action"
Tags = ["React.js", "Redux"]
date = "2015-12-15T12:53:17+09:00"
draft = false
slug = "redux-fetch-action"
title = "Redux Fetch Action"
+++

Redux Fetch ActionというReduxのFetch actionのutilityを作った.

<!--more-->

この記事は[仮想DOM/Flux Advent Calendar 2015](http://qiita.com/advent-calendar/2015/vdom-flux)の15日目の記事.

1. [Redux Fetch Action]({{< relref "#redux-fetch-action" >}})
2. [See Also]({{< relref "#see-also" >}})


# Redux Fetch Action

## Why

最近[Redux](https://github.com/rackt/redux)を使っているが、DataのFetchが似たようなAction creatorとReducerのpatternになったので、
切り出してpublishした. (`POST` もFetchかよって違和感はある.)

[Redux Fetch Action](https://github.com/Rudolph-Miller/redux-fetch-action)

FluxのActionには[非公式のCoding規約](https://github.com/acdlite/flux-standard-action)があるらしく、
それに則るため[redux-actions](https://github.com/acdlite/redux-actions)をbaseとしている.


## API

APIは `createFetchAction` と `handleFetchAction` がある.

`createFetchAction` はAction creatorを返す.

```js
const FETCH_DATA = 'FETCH_DATA';
const fetchAction = createFetchAction(FETCH_DATA, '/data.json');
```

のように使用する.

`handleFetchAction` はReducerを返す.

```js

const reducer = handleFetchAction(FETCH_DATA, {
  request: (state = {}, action) => {
    return state;
  },
  receive: (state = {}, action) => {
    return action.payload;
  },
  error: (satet = {}, action) => {
    return state;
  }
});
```

のように使用する.


## Example

二つのAPIを合わせ、

```js
import { createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import { handleActions } from 'redux-actions';
import { createFetchAction, handleFetchAction } from 'redux-fetch-action';
import { Server }from 'node-static';
import { createServer } from 'http';

const file = new Server();
createServer((request, response)  => {
  request.addListener('end', () => {
    file.serve(request, response);
  }).resume();
}).listen(8080);

const FETCH1 = 'FETCH1';
const FETCH2 = 'FETCH2';
const FETCH3 = 'FETCH3';

const reducer1 = handleFetchAction(FETCH1, {
  request: (posts = [], action) => {
    console.log('REQUEST 1');
    return posts;
  },
  receive: (posts = [], action) => {
    console.log('RECEIVED 1');
    console.log(action.payload);
    return action.payload.posts;
  },
  error: (posts = [], action) => {
    console.log('ERROR 1');
    return posts;
  }
});

const reducer2 = handleFetchAction(FETCH2, {
  request: (posts = [], action) => {
    console.log('REQUEST 2');
    return posts;
  },
  receive: (posts = [], action) => {
    console.log('RECEIVED 2');
    console.log(action.payload);
    return action.payload.posts;
  },
  error: (posts = [], action) => {
    console.log('ERROR 2');
    return posts;
  }
});

const reducer3 = handleFetchAction(FETCH3, {
  request: (posts = [], action) => {
    console.log('REQUEST 3');
    return posts;
  },
  receive: (posts = [], action) => {
    console.log('RECEIVED 3');
    console.log(action.payload);
    return action.payload.posts;
  },
  error: (posts = [], action) => {
    console.log('ERROR 3');
    return posts;
  }
});

const reducer = handleActions({
  FETCH1: reducer1,
  FETCH2: reducer2,
  FETCH3: reducer3
}, {});

const store = applyMiddleware(
  thunk
)(createStore)(reducer);

const fetchAction1 = createFetchAction(FETCH1, 'http://localhost:8080/data.json');
const fetchAction2 = createFetchAction(FETCH2, 'http://localhost:8080/sample.html');
const fetchAction3 = createFetchAction(FETCH3, 'http://localhost:8080/unknown.json');

store.dispatch(fetchAction1());
store.dispatch(fetchAction2());
store.dispatch(fetchAction3());

/*
REQUEST 1
REQUEST 2
REQUEST 3
ERROR 3
RECEIVED 1
{ posts:
   [ { id: 1, text: 'Sample text 1' },
     { id: 2, text: 'Sample text 2' } ] }
RECEIVED 2
<div>
  sample
</div>
*/
```

このようにFetchのhandleができる.


# See Also

- [Redux Fetch Action](https://github.com/Rudolph-Miller/redux-fetch-action)
- [redux-actions](https://github.com/acdlite/redux-actions)
- [Redux](https://github.com/rackt/redux)
- [Redux: Actionのコーディング規約 と redux-actions](http://qiita.com/yasuhiro-okada-aktsk/items/a14f7f37262fb6cf0bf8)
