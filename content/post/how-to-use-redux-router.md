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

この記事は[仮想DOM/Flux Advent Calendar 2015](http://qiita.com/advent-calendar/2015/vdom-flux)の23日目の記事.

[React.js Advent Calendar 2015](http://qiita.com/advent-calendar/2015/reactjs)でRedux Routerの記事を見かけた気がするが、他所は気にしない.


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

```js
import React, { Component } from 'react';
import { render } from 'react-dom';
import { combineReducers, createStore } from 'redux';
import { connect, Provider } from 'react-redux';
import { createAction, handleActions } from 'redux-actions';

const INCR_COUNTER = 'INCR_COUNTER';
const incrCounter = createAction(INCR_COUNTER);
const DECR_COUNTER = 'DECR_COUNTER';
const decrCounter = createAction(DECR_COUNTER);

const handleCounter = handleActions({
  INCR_COUNTER: (counter = 0, action) => {
    return counter + 1;
  },
  DECR_COUNTER: (counter = 0, action) => {
    return counter - 1;
  }
}, 0);

const reducer = combineReducers({
  counter: handleCounter
});

@connect(state => {
  return {
    counter: state.counter
  };
})
class App extends Component {
  render() {
    const { dispatch, counter } = this.props;
    return (
      <div>
        <p>{`COUNTER: ${counter}`}</p>
        <button onClick={() => { dispatch(incrCounter()); }}>
          INCREMENT
        </button>
        <button onClick={() => { dispatch(decrCounter()); }}>
          DECREMENT
        </button>
      </div>
    );
  }
}

const store = createStore(reducer);

class Root extends Component {
  render() {
    return (
      <Provider store={store}>
        <App />
      </Provider>
    );
  }
}

render(<Root />, document.getElementById('app'));
```

{{% image "/20151222/initial-impl.gif" %}}

`@connect` して `state.counter` を表示し、その `state.counter` を増減させるボタンがあるだけのApplicationで、とくに解説することはない.

### React Router

```js
mport React, { Component, PropTypes } from 'react';
import { render } from 'react-dom';
import { combineReducers, createStore } from 'redux';
import { connect, Provider } from 'react-redux';
import { createAction, handleActions } from 'redux-actions';
import { Router, IndexRoute, Route, Redirect, Link } from 'react-router';

const INCR_COUNTER = 'INCR_COUNTER';
const incrCounter = createAction(INCR_COUNTER);
const DECR_COUNTER = 'DECR_COUNTER';
const decrCounter = createAction(DECR_COUNTER);

const handleCounter = handleActions({
  INCR_COUNTER: (counter = 0, action) => {
    return counter + 1;
  },
  DECR_COUNTER: (counter = 0, action) => {
    return counter - 1;
  }
}, 0);

const reducer = combineReducers({
  counter: handleCounter
});

@connect(state => {
  return {
    counter: state.counter
  };
})
class App extends Component {
  render() {
    const { counter } = this.props;
    return (
      <div>
        <p>{`COUNTER: ${counter}`}</p>
        {this.props.children}
      </div>
    );
  }
}

@connect()
class CounterButton extends Component {
  static propTypes = {
    type: PropTypes.oneOf(['incr', 'decr']).isRequired
  }

  render() {
    const { dispatch } = this.props;
    return (
      <button
        onClick={() => {
          if(this.props.type === 'incr') {
            dispatch(incrCounter());
          } else {
            dispatch(decrCounter());
          }
        }} >
        {this.props.children}
      </button>
    );
  }
}

class Increment extends Component {
  render() {
    return (
      <div>
        <CounterButton type='incr'>INCREMENT</CounterButton>
        <Link to='/decr'>
          TO DECREMENT
        </Link>
      </div>
    );
  }
}

class Decrement extends Component {
  render() {
    return (
      <div>
        <CounterButton type='decr'>DECREMENT</CounterButton>
        <Link to='/'>
          TO INCREMENT
        </Link>
      </div>
    );
  }
}

const routes = (
  <Route>
    <Redirect from="/" to="incr" />
    <Route path="/" component={App}>
      <Route path="incr" component={Increment} />
      <Route path="decr" component={Decrement} />
    </Route>
  </Route>
);

const store = createStore(reducer);

class Root extends Component {
  render() {
    return (
      <Provider store={store}>
        <Router routes={routes} />
      </Provider>
    );
  }
}

render(<Root />, document.getElementById('app'));
```

{{% image "/20151222/second-impl.gif" %}}

React Routerを導入して `Increment` と `Decrement` をRoutingで分けただけ.  
共通で `CounterButton` をrenderしていて、 `this.props.type` でボタンがクリックされた時に、
`incrCounter()` か `decrCounter()` のどちらを `dispatch` するか分岐している.

`this.props.type` ではなく、__URLというApplicationが持つState__で分岐させたいとする.

```diff
 @connect()
 class CounterButton extends Component {
-  static propTypes = {
-    type: PropTypes.oneOf(['incr', 'decr']).isRequired
+  static contextTypes = {
+    location: React.PropTypes.object.isRequired
   }
 
   render() {
     const { dispatch } = this.props;
     return (
       <button
         onClick={() => {
-          if(this.props.type === 'incr') {
+          if(this.context.location.pathname === '/incr') {
             dispatch(incrCounter());
           } else {
             dispatch(decrCounter());
					 }
        }} >
        {this.props.children}
      </button>
    );
  }
}
```

```diff
class Increment extends Component {
   render() {
     return (
       <div>
-        <CounterButton type='incr'>INCREMENT</CounterButton>
+        <CounterButton>INCREMENT</CounterButton>
         <Link to='/decr'>
           TO DECREMENT
         </Link>
      </div>
    );
  }
}
```

```diff
class Decrement extends Component {
     return (
       <div>
-        <CounterButton type='decr'>DECREMENT</CounterButton>
+        <CounterButton>DECREMENT</CounterButton>
         <Link to='/'>
           TO INCREMENT
         </Link>
      </div>
    );
  }
}
```

`static contextTypes` を定義して、 `this.context.location` を使用する.

__Application全体のState__の管理に一貫性がなくなった.


### Redux Router

一貫性を取り戻すためにRedux Routerを導入する.

```diff
-import { Router, IndexRoute, Route, Redirect, Link } from 'react-router';
+import { IndexRoute, Route, Redirect, Link } from 'react-router';
+import { reduxReactRouter, routerStateReducer, ReduxRouter } from 'redux-router';
+import createHistory from 'history/lib/createHashHistory';
```

```diff
 const reducer = combineReducers({
+  router: routerStateReducer,
   counter: handleCounter
 });
```

```diff
-@connect()
+@connect(state => {
+  return {
+    location: state.router.location
+  }
+})
class CounterButton extends Component {
-  static contextTypes = {
-    location: React.PropTypes.object.isRequired
-  }

   render() {
     const { dispatch } = this.props;
 
     return (
       <button
         onClick={() => {
-          if(this.context.location.pathname === '/incr') {
+          if(this.props.location.pathname === '/incr') {
             dispatch(incrCounter());
           } else {
             dispatch(decrCounter());
					 }
        }} >
        {this.props.children}
      </button>
    );
  }
}
```

```diff
-const store = createStore(reducer);
+const store = reduxReactRouter({routes, createHistory})(createStore)(reducer);
```

```diff
 class Root extends Component {
   render() {
     return (
       <Provider store={store}>
-        <Router routes={routes} />
+        <ReduxRouter />
       </Provider>
     );
   }
```

上から順に解説する.

- 色々 `import` .
- `combineReducers` で `router:` を `routerStateReducer` がhandleするようset.
- `this.context.location` を `this.props.location` とできるよう、 `@connect` で `location:` に `state.router.location` をset.
- `this.context.location` の代わりに `this.props.location` を使用.
- `store` を `reduxReactRouter` でwrapして、 `router` のStateを `store` で管理するようにする.
  - `createBrowserHistory` を使用して、 `<Router history={history} />` をしていた場合は、 `createBrowserHistory` を `reduxReactRouter` の第二引数に渡す.
    - `<ReduxRouter history={history} />` とはしない.
- `<Router routes={routes} />` を `<ReduxRouter />` で置き換える.

これでReduxでURLのStateも `router` として管理できるようになった.

__秩序を取り戻した. ╭( ･ㅂ･)و__


# See Also

- [Redux Router](https://github.com/acdlite/redux-router)
- [React Router](https://github.com/rackt/react-router)
- [Redux](https://github.com/rackt/redux)
- [redux-simple-router](https://github.com/rackt/redux-simple-router)
