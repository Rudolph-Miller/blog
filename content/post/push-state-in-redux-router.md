+++
Description = "Redux Routerの `pushState` の使い方と、 `connect` の `mapDispatchToProps` について"
Tags = ["React.js", "Redux", "Redux Router"]
date = "2015-12-25T12:34:52+09:00"
draft = false
title = "pushState in Redux Router"
+++

Redux Routerの `pushState` の使い方と、 `connect` の `mapDispatchToProps` について.

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

これに `pushState` で、 `/decr` を1秒後に `/incr` にredirectするという無駄な機能をつける.

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

`pushState` をRedux Routerから `import` し、 `pushState` を `connect` の第二引数に `{ pushState: pushState }` の形で渡し、
`componentDidMount` の中で `setTimeout` を使って `this.props.pushState` を呼んでいる.

Redux Routerの `pushState` は [ここ](https://github.com/acdlite/redux-router/blob/master/src/actionCreators.js#L56)で定義されていて、どうもAction creatorのようだ.

`connect` の第二引数って何だろう.

[react-redux](https://github.com/rackt/react-redux)のTutorialの `connect` の解説にこう書いてある.

> In most cases you will only pass the first argument to connect(), which is a function we call a selector.

ほとんどの場合、第一引数しか使わないらしい.

仕方ないので[Source code](https://github.com/rackt/react-redux/blob/b35f8be00dae2af16a2b4eb12947ed616bc39279/src/components/connect.js#L24)を読むと、 `mapDispatchToProps` と呼ぶものらしい.


# mapDispatchToProps

もう少し `mapDispatchToProps` を追ってみる.


## connect

`connect` の定義は[ここ](https://github.com/rackt/react-redux/blob/b35f8be00dae2af16a2b4eb12947ed616bc39279/src/components/connect.js#L24-L275)だが、簡単に言うと、4つの引数をとって、1つの引数をとる関数を返す.

```js
export default function connect(mapStateToProps, mapDispatchToProps, mergeProps, options = {}) {
  return function wrapWithConnect(WrappedComponent) {
    class Connect extends Component {
      render() {
        return createElement(WrappedComponent, this.mergeProps);
      }
    }
  }
}
```


## mapDispatchToProps

`Object` なら `wrapActionCreators` でwrapされて、 `Object` でないならそのままで、 `finalMapDispatchToProps` に入る.
`mapDispatchToProps` として何も渡さなかった場合は `defaultMapDispatchToProps` がdefaultで入るようになっている. `defaultMapDispatchToProps` の定義は、

```js
const defaultMapDispatchToProps = dispatch => ({ dispatch });
```

となっていて、 `dispatch` を受け取り `{ dispatch: dispatch }` として返している.


## wrapActionCreators

`mapDispatchToProps` が `Object` だったときは `wrapActionCreators` でwrapされるが、 `wrapActionCreators` の定義は[ここ](https://github.com/rackt/react-redux/blob/b35f8be00dae2af16a2b4eb12947ed616bc39279/src/utils/wrapActionCreators.js#L3)にあり、 Reduxの `bindActionCreators` を呼んでいる.
`bindActionCreators` は引数が `Object` の時は、その `values` にたいして `bindActionCreator` を `map` している. `bindActionCreator` の定義は、

```js
function bindActionCreator(actionCreator, dispatch) {
  return (...args) => dispatch(actionCreator(...args));
}
```

で、引数でAction creatorを呼んで、Actionを生成して、 `dispatch` する関数を返している.


## finalMapDispatchToProps

`finalMapDispatchToProps` は `computeDispatchProps` の中で `dispatch` を引数として呼ばれており、その返り値が `Connect#updateDispatchPropsIfNeeded` の中で `this.dispatchProps` に入る. この `this.dispatchProps` は `Connect#updateMergedProps` で `computeMergedProps` を通して `this.mergedProps` に入る.


## computeMergedProps

`computeMergedProps` は `stateProps`, `dispatchProps` と `parentProps` を受け取り、 `finalMergeProps` にそれらを渡し、その返り値を返している.


## finalMergeProps

`finalMergeProps` は `connect` の第三引数である `mergeProps` が入っている. `connect` に第三引数が指定されていない場合は `defaultMergeProps` が入り、その定義は、

```js
const defaultMergeProps = (stateProps, dispatchProps, parentProps) => ({
  ...parentProps,
  ...stateProps,
  ...dispatchProps
})
```

で、 `stateProps`, `dispatchProps` と `parentProps` を受け取り、それらをexpandしてまとめて返している.
`Connect#updateMergedProps` でこれらが `this.mergedProps` に入り、最終的に `createElement` で `connect` の返す関数の引数として渡される `WrappedComponent` に渡される.

```js
createElement(WrappedComponent, this.mergedProps); 
```

## mapDispatchToProps again

結局 `mapDispatchToProps` は何だったかと言うと、 `dispatch` を `createElement` にどのように渡すかを定義する引数だった.

```js
@connect(null, { pushState })
class Decrement extends Component {
  ...
}
```

とすると、

```js
createElement(Decrement, { pushState: (...args) => { dispatch(pushState(..args)); } });
```

となって、 `class Decrement` の中で `this.props.pushState` が使えるようになる.

さらに `mapDispatchToProps` のdefaultが

```js
const defaultMapDispatchToProps = dispatch => ({ dispatch });
```

であったように、 `dispatch` 自体もmappingしないと `this.props.dispatch` は使えないので `this.props.dispatch` が必要な際は、

```js
functiton mapDispatchToProps(dispatch) {
  return {
    dispatch,
    pushState: bindActionCreators(pushState, dispatch)
  };
}
@connect(null, mapDispatchToProps)
class Decrement extends Component {
  ...
}
```

と、 `dispatch` もmappingするような関数 ( `mapDispatchToProps` ) を作り、 `connect` の第二引数として渡す.


# See Also

- [Redux Routerの使い方](http://blog.rudolph-miller.com/2015/12/23/redux-router/)
- [Redux Router](https://github.com/acdlite/redux-router)
- [React Router](https://github.com/rackt/react-router)
- [Redux](https://github.com/rackt/redux)
