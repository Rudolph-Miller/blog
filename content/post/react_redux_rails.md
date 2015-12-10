+++
Description = "React Redux Rails"
Tags = ["React.js", "Redux", "Ruby on Rails"]
date = "2015-12-11T00:00:06+09:00"
draft = false
slug = "react-redux-rails"
title = "React Redux Rails"
+++

React.js & Redux & Ruby on Railsでserver-side rendering.

<!--more-->

この記事は[React.js Advent Calendar 2015](http://qiita.com/advent-calendar/2015/reactjs)の10日目の記事であり、  
[仮想DOM/Flux Advent Calendar 2015](http://qiita.com/advent-calendar/2015/vdom-flux)の10日目の記事です. (欲張り.)

Source codeは[React Rails Example](https://github.com/Rudolph-Miller/react_rails_example).

1. [React Redux Rails]({{< relref "#react-redux-rails" >}})
1. [See Also]({{< relref "#see-also" >}})


# React Redux Rails

## React.js

React.jsはFacebook製のJavaScriptのUI Library.  
Viewの状態管理をさぼれる.

- [React.js](https://github.com/facebook/react)
- [一人React.js Advent Calendar 2014](http://qiita.com/advent-calendar/2014/reactjs)

## Redux

Reduxは今一番熱いFlux architecture frameworkで状態管理をatomitにする.

- [Redux](https://github.com/rackt/redux)
- [React Redux](https://github.com/rackt/react-redux)
- [人気のFluxフレームワークReduxをさわってみた](http://amagitakayosi.hatenablog.com/entry/2015/07/30/000000)

## react-rails

Ruby on RailsにはReact.jsのserver-side renderingを容易にするGemがある.

```rb
<%= react_component('HelloMessage', name: 'John') %>
<!-- becomes: -->
<div data-react-class="HelloMessage" data-react-props="{&quot;name&quot;:&quot;John&quot;}"></div>
```

こんな感じにViewにReact.jsのComponentを埋め込むことができる.

`react_component` の3つ目の引数として `{prerender: true}` を渡すだけで、server-side renderingができる.

```rb
<%= react_component('HelloMessage', {name: 'John'}, {prerender: true}) %>
<!-- becomes: -->
<div data-react-class="HelloMessage" data-react-props="{&quot;name&quot;:&quot;John&quot;}">
  <h1>Hello, John!</h1>
</div>
```

- [react-rails](https://github.com/reactjs/react-rails)
- [react-railsを使ってReactのTutorialをやってみる](http://qiita.com/joe-re/items/96f12dda4a62470d1d7c)

## Try

これらを合わせて、Reduxで状態管理をして、ReactでComponentを組み立て、Ruby on Railsでserver-side renderingをしてみた.

BaseのAppはReduxのBasic tutorialになっている[tiny todo app](http://rackt.org/redux/docs/basics/ExampleTodoList.html).

```rb
<%= react_component('Root', {presetTodos: @todos}, {prerender: true}) %>
```

[app/views/todos/index.html.erb](https://github.com/Rudolph-Miller/react_rails_example/blob/ab95d682a10b91358f01bb431be2cdb397795cdd/app/views/todos/index.html.erb#L1)

とRuby on RailsのViewに埋め込むことにより、初回は server-side renderingで `@todos` を `props` に渡して `componentDidMount` でDataをsetし、
それ以外で `Root` をrenderした時は `componentDidMount` でDataをfetchする.  
(今回のExampleではこの遷移は実装していないが、 `{presetTodos: @todos}` をはずぜばこの挙動となる.)


```js
componentDidMount() {
	const { dispatch, presetTodos } = this.props;
	if (presetTodos) {
		dispatch(setTodos(presetTodos));
	} else {
		dispatch(fetchTodos());
	}
}
```

[app/assets/javascripts/containers/App.js](https://github.com/Rudolph-Miller/react_rails_example/blob/ab95d682a10b91358f01bb431be2cdb397795cdd/app/assets/javascripts/containers/App.js#L38-L45)


軽くポイントを掻い摘む.

- JavaScriptのLibrary管理はnpmでbrowserify-railsを使ってBabelでbuildした.
  - `application.js` は `//= require react_ujs` と `//= require components` のみ. ([app/assets/javascripts/application.js](https://github.com/Rudolph-Miller/react_rails_example/blob/c07553236da0464393fccf75ecb6a3d61f48b4e2/app/assets/javascripts/application.js#L1-L2))
- Babel 6だとDecorationが未supportだったため、Babel 5を使用した. ([Implement new decorator proposal when finalized](http://phabricator.babeljs.io/T2645))
- ReduxでAsync.
  - [Async Actions](http://rackt.org/redux/docs/advanced/AsyncActions.html)
  - [app/assets/javascripts/actions/index.js](https://github.com/Rudolph-Miller/react_rails_example/blob/ab95d682a10b91358f01bb431be2cdb397795cdd/app/assets/javascripts/actions/index.js#L34-L54)


詳しくはSourceに.
質問があればTwitterで [#Rudolph_Miller](https://twitter.com/Rudolph_Miller) に聞いて下さい.


意外とすんなり書け、すんなり動いたので、どこかで実戦投入したいと思う.


# See Also

- [React Rails Example](https://github.com/Rudolph-Miller/react_rails_example)
- [React.js](https://github.com/facebook/react)
- [Flux](https://github.com/facebook/flux)
- [Redux](https://github.com/rackt/redux)
- [React Redux](https://github.com/rackt/react-redux)
- [react-rails](https://github.com/reactjs/react-rails)
- [Babel](https://github.com/browserify-rails/browserify-rails)
- [browserify-rails](https://github.com/browserify-rails/browserify-rails)
