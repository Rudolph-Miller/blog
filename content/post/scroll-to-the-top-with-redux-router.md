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

1. [Scroll to the top with Redux Router]({{< relref "#scroll-to-the-top-with-rudex-router" >}})
2. [See Also]({{< relref "#see-also" >}})


# Scroll to the top with Redux Router

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


# See Also
