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

`pushState` はReact RouterでURLを遷移するAPIで、元はBrowserのHistory API.
Redux Routeの `pushState` はこれをwrapしたもの.


# Usage

[前回](http://blog.rudolph-miller.com/redux-router)で使ったApplicationを用意する.

```js
import React, { Component, PropTypes } from 'react';
import { render } from 'react-dom';
import { combineReducers, createStore } from 'redux';
import { connect, Provider } from 'react-redux';
import { createAction, handleActions } from 'redux-actions';
import { IndexRoute, Route, Redirect, Link } from 'react-router';
import { reduxReactRouter, routerStateReducer, ReduxRouter } from 'redux-router';
import createHistory from 'history/lib/createHashHistory';

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
  router: routerStateReducer,
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

@connect(state => {
  return {
    location: state.router.location
  }
})
class CounterButton extends Component {
  render() {
    const { dispatch } = this.props;

    return (
      <button
        onClick={() => {
          if(this.props.location.pathname === '/incr') {
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
        <CounterButton>INCREMENT</CounterButton>
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
        <CounterButton>DECREMENT</CounterButton>
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

const store = reduxReactRouter({routes, createHistory})(createStore)(reducer);

class Root extends Component {
  render() {
    return (
      <Provider store={store}>
        <ReduxRouter />
      </Provider>
    );
  }
}

render(<Root />, document.getElementById('app'));
```

{{% image "/20151225/without-push-state.gif" %}}

これに `pushState` で `/decr` を1秒後に `/incr` にredirectする無駄な機能をつける.

```diff
-import { reduxReactRouter, routerStateReducer, ReduxRouter } from 'redux-router';
+import { reduxReactRouter, routerStateReducer, ReduxRouter, pushState } from 'redux-router';
```

```diff
+@connect(null, { pushState })
class Decrement extends Component {
+  componentDidMount() {
+    const { pushState } = this.props;
+
+    setTimeout(() => {
+      pushState(null, '/incr');
+    }, 1000)
+  }

  render() {
    return (
      <div>
        <CounterButton>DECREMENT</CounterButton>
        <Link to='/'>
          TO INCREMENT
        </Link>
      </div>
    );
  }
}
```

{{% image "/20151225/with-push-state.gif" %}}

一つ目のdiffは `pushState` をRedux Routerから `import` している.
二つ目のdiffで `pushState` を `@connect` の第二引数に `{ pushState: pushState }` の形で渡し、
`componentDidMount` の中で `setTimeout` を使って `this.props.pushState` をcallしている.

Redux Routerの `pushState` は [ここ](https://github.com/acdlite/redux-router/blob/master/src/actionCreators.js#L56)で定義されていて、どうもAction creatorのようだ.

`@connect` の第二引数って何だろう.

[react-redux](https://github.com/rackt/react-redux)のTutorialの `connect` の解説にこう書いてある.

> In most cases you will only pass the first argument to connect(), which is a function we call a selector.

ほとんどの場合、第一引数しか使わないらしい.

仕方ないので[Source code](https://github.com/rackt/react-redux/blob/b35f8be00dae2af16a2b4eb12947ed616bc39279/src/components/connect.js#L24)を読むと、 `mapDispatchToProps` と呼ぶものらしい.


# mapDispatchToProps


# See Also

- [Redux Routerの使い方](http://blog.rudolph-miller.com/2015/12/23/redux-router/)
