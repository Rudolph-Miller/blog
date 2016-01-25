+++
Description = "Redux RouterでLocationの変更時にScrollをtopに持っていく方法"
Tags = ["React.js", "Redux", "Redux Router"]
date = "2016-01-24T21:29:54+09:00"
draft = true
title = "Scroll to the top with Redux Router"
slug = "scroll-to-the-top-with-redux-router"
+++

Redux RouterでLocationの変更時にScrollをtopに持っていく方法.

<!--more-->

1. [Scroll position after transition]({{< relref "#scroll-position-after-transition-with-redux-router" >}})
2. [Scroll to the top]({{< relref "#scroll-to-the-top-with-redux-router" >}})
3. [See Also]({{< relref "#see-also" >}})


# Scroll position after transition

[Redux Router](https://github.com/acdlite/redux-router) は [Redux Routerの紹介]({{< relref "post/redux-router.md" >}}) で紹介した通り、React.jsでde facto standardとなっているRouting libraryの [React Router](https://github.com/rackt/react-router) の [Redux](https://github.com/rackt/redux) bindings.

Redux Routerを実際にApplicationで使用していると `Link` での遷移時にScrollが元の位置のままで困ったので、 `Link` での遷移で `window.scrollTo(0, 0)` するよう実装した.


# Scroll to the top

## Example

とりあえずRedux Routerを使用したApplicationを用意する.

```js
import React, { Component, PropTypes } from 'react';
import { render } from 'react-dom';
import { createStore, combineReducers } from 'redux';
import { connect, Provider } from 'react-redux';
import { IndexRoute, Route, Redirect, Link } from 'react-router';
import { reduxReactRouter, routerStateReducer, ReduxRouter } from 'redux-router';
import createHistory from 'history/lib/createHashHistory';

const Styles = {
  linkContainer: {
    marginTop: '1000px'
  }
}

class App extends Component {
  render() {
    return (
      <div>
        {this.props.children}
      </div>
    );
  }
}

class Hoge extends Component {
  render() {
    return (
      <div>
        <div>Hoge</div>
        <div style={Styles.linkContainer}>
          <Link to="/fuga">
            To Fuga
          </Link>
        </div>
      </div>
    );
  }
}

class Fuga extends Component {
  render() {
    return (
      <div>
        <div>Fuga</div>
        <div style={Styles.linkContainer}>
          <Link to="/hoge">
            To Hoge
          </Link>
        </div>
      </div>
    );
  }
}

const routes = (
  <Route>
    <Redirect path="/" to="hoge" />
    <Route path="/" component={App}>
      <Route path="hoge" component={Hoge} />
      <Route path="fuga" component={Fuga} />
    </Route>
  </Route>
);

const reducer = combineReducers({
  router: routerStateReducer
});

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

{{% image "20160125/scroll_step1.gif" %}}

上のGIFの通り、このままだと `Link` での遷移時にScrollが元の位置のままだ.  
本来なら、遷移したらScrollを最上部にもっていくべきだろう.


## Scroll to the top

Redux Routerでも数行でこれが実装できる.

```diff
@@ -66,7 +66,18 @@
const reducer = combineReducers({
   router: routerStateReducer
 });
 
-const store = reduxReactRouter({routes, createHistory})(createStore)(reducer);
+const history = createHistory();
+
+history.listen(location => {
+  setTimeout(() => {
+    if (location.action === 'POP') {
+      return;
+    }
+    window.scrollTo(0, 0);
+  });
+});
+
+const store = reduxReactRouter({routes, history})(createStore)(reducer);
 
 class Root extends Component {
   render() {
     return (
       <Provider store={store}>
         <ReduxRouter />
       </Provider>
     );
   }
 }
```

変更点は、

- `reduxReactRouter` に `createHistory` ではなく、 `history` として `createHistory()` の返り値を渡す.
- `history` に対して `location` の変更のEventの `listen` を行い、 `location.action` が `'POP'` 以外の時に `window.scrollTo(0, 0)` を実行する.

だけ.

{{% image "20160125/scroll_step2.gif" %}}


## pushState

[pushState in Redux Router]({{< relref "post/pushstate-in-redux-router.md" >}}) で紹介した通り、
Redux Routerにも `pushState` のAPIがあり `pushState` ででもPageの遷移ができるが、
この改修により `pushState` での遷移でもScrollを最上部に持っていくことができる.


# See Also
- [Redux Routerの紹介]({{< relref "post/redux-router.md" >}})
- [Redux Router](https://github.com/acdlite/redux-router)
- [React Router](https://github.com/rackt/react-router)
- [Redux](https://github.com/rackt/redux)
