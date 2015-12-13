+++
Description = "React Bootstrap Star Rating"
Tags = ["React.js"]
date = "2015-12-13T23:00:37+09:00"
draft = false
slug = "react-bootstrap-star-rating"
title = "React Bootstrap Star Rating"
+++

React Bootstrap Star Ratingを作った.

<!--more-->

作ったので軽く紹介する.  
GitHubは[React Bootstrap Star Rating](https://github.com/Rudolph-Miller/react-bootstrap-star-rating).

1. [React Bootstrap Star Rating]({{< relref "#react-bootstrap-star-rating" >}})
2. [See Also]({{< relref "#see-also" >}})

# React Bootstrap Star Rating

作り始めた動機はあるプロジェクトでBowerでjQueryが使われており、
commitするにあたってそれらを殲滅しnpmとReactを導入しようと思ったが、
どうもReactには良い感じのStar rating libraryが無かったから.


## Star Rating in React

npmのdownload statsで一番だったのは[react-star-rating](https://www.npmjs.com/package/react-star-rating) (939 downloads in the last month) で、
それ以外はほとんど使われていないようだった.

[react-star-rating](https://www.npmjs.com/package/react-star-rating)はどうかというと、GitHubのcommitはa month agoで[Project page](http://cameronjroe.com/react-star-rating/)もあり、
ある程度は開発されていそうだったが、どうも件のProjectのowner曰くstyleがイケていないらしい.

{{% image "/20151213/react-star-rating.png" %}}

ということで、件のProjectで使用していたjQuery pluginをReactでwrapして使うことした.
([DEMO](http://plugins.krajee.com/star-rating/demo)をみる限り、色々customizableっぽい.)

{{% image "/20151213/bootstrap-star-rating.gif" %}}


## Wrap jQuery plugin

作ったといってもjQuery pluginをwrapしただけ (どうもnpmにpublishしていなかっただけで、package.jsonはあった.) なので、
wrapする際の常套patternを軽く紹介する.


### DOM node

jQuery pluginなのでDOM nodeに対して操作を行う.

```js
$('#rating').rating();
```

これをReactで実装する際は `ref` を使用する.

```js
class StarRating extends Component {
  componentDidMount() {
    $node.rating();
  }

  render() {
    return (
      <input
        ref={node => { this.$node = $(node); }} />
    );
  }
}
```


### Export API

今回の[bootstrap-star-rating](https://www.npmjs.com/package/react-star-rating)は強制にvalueをupdateするAPIがあった.

```js
$('#rating').rating('update', 5);
```

これをReactで実装する際は `method` として定義して、 `ref` を通して呼び出す.

```js
class StarRating extends Component {
  componentDidMount() {
    $node.rating();
  }

  render() {
    return (
      <input
        ref={node => { this.$node = $(node); }} />
    );
  }

  update(value) {
    $node.rating('update', value);
  }
}

class App extends Component {
  componentDidMount() {
    setTimeout(() => {
      this.starRating.update(5);
    }, 1000);
  }

  render() {
    return (
      <StarRating
        ref={ref => { this.starRating = ref; }} />
    );
  }
}
```


## Result

簡単にwrapして別のLibraryとして切り出しただけなのでjQueryを無くせたわけでは無いが、  
直接の依存からはremoveできるようになったので心のざわつきは無くせたかな.

# See Also

- [React Bootstrap Star Rating](https://github.com/Rudolph-Miller/react-bootstrap-star-rating)
- [Bootstrap Star Rating](http://plugins.krajee.com/star-rating)
- [bootstrap-star-rating](https://github.com/kartik-v/bootstrap-star-rating)
