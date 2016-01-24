+++
Description = "Twitterのshare buttonにList-balloonを追加する"
Tags = ["Twitter", "CSS"]
date = "2016-01-24T23:57:30+09:00"
draft = true
slug = "add-list-balloon-to-twitter-share-button"
title = "Add List-balloon to Twitter share button"
+++

Twitterのshare buttonにlist balloonを追加する.

<!--more-->

1. [Twitter share button]({{< relref "#twitter-share-button" >}})
2. [Add List-balloon]({{< relref "#add-list-balloon" >}})
3. [See Also]({{< relref "#see-also" >}})


# Twitter share button

Blogなどに埋め込まれているTwitterのshareボタンだが、以前は上にBalloonでTweet数が表示されていた.

{{% image "20160124/previous_twitter.png" %}}

それがTwitter内部でのCassandraの廃止に付随して、昨年末なくなった.  
(参照: [持続的なプラットフォームのための難しい決断](https://blog.twitter.com/ja/2015/buttons))

{{% image "20160124/new_twitter.png" %}}

Twitter、 はてなブックマーク、Facebook、Google+のshareボタンがBalloon付きでならんでいたのだが、TwitterのshareボタンだけがBalloonが無くなり、統一感が失われた.
違和感を感じつつも放置していたのだが、最近あるBlogでTwittenのshareボタンの上にBalloonで `list` と表示し、
*https://twitter.com/search* のその記事のPermalinkの検索結果へのLinkとなるようにしているのを見かけたので実装してみた.


# Add List-balloon

まず従来のshareボタンだが、

```html
<div class="social-button">
  <a class="twitter-share-button" href="https://twitter.com/share" data-dnt="true" data-count="vertical">Tweet</a>
</div>
```

と

```html
<script>
  window.twttr=(function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],t=window.twttr||{};if(d.getElementById(id))return;js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);t._e=[];t.ready=function(f){t._e.push(f);};return t;}(document,"script","twitter-wjs"));
</script>
```

を埋め込む.

以前は一つ目のHTML codeの `a` tagの `data-conut="vertical"` によりTweet数のBalloon付きでshareボタンが表示されていたが、今はこのように表示される.

{{% image "20160124/new_twitter.png" %}}

とりあえず、Balloonを表示する.  
BalloonはCSSで一つの `span` とその `::before` と `::after` を使って描けるので、とりあえず一つ `span` を追加する.

```diff
 <div class="social-button">
+  <span class="balloon-bottom">list</span>
   <a class="twitter-share-button" href="https://twitter.com/share" data-dnt="true" data-count="vertical">Tweet</a>
 </div>
```

{{% image "20160124/step1.png" %}}

これにBalloonを描くようCSSを当てる.

```css
.balloon-bottom {
  position: relative;
  display: inline-block;
  padding: 0 15px;
  width: 75px;
  min-width: 75px;
  height: 33px;
  line-height: 33px;
  color: #000;
  text-align: center;
  background-color: #fff;
  border: 1px solid #B0C1D8;
  border-radius: 3px;
  z-index: 0;
}

.balloon-bottom:before {
  content: "";
  position: absolute;
  bottom: -4px;
  left: 50%;
  margin-left: -4px;
  width: 0px;
  height: 0px;
  border-style: solid;
  border-width: 5px 4px 0 4px;
  border-color: #fff transparent transparent transparent;
  z-index: 0;
}

.balloon-bottom:after {
  content: "";
  position: absolute;
  bottom: -6px;
  left: 50%;
  margin-left: -5px;
  width: 0px;
  height: 0px;
  border-style: solid;
  border-width: 6px 5px 0 5px;
  border-color: #B0C1D8 transparent transparent transparent;
  z-index: -1;
}
```

{{% image "20160124/step2.png" %}}

(下の吹き出しの大きさの変更は `:before` と `:after` の `bottom`, `margin-left`, `border-width` をsynchronouslyに変更する.)

次はこれを縦に並べる.

```diff
 <div class="social-button">
-  <span class="balloon-bottom">list</span>
-  <a class="twitter-share-button" href="https://twitter.com/share" data-dnt="true" data-count="vertical">Tweet</a>
+  <ul class="twitter-share-button-with-balloon">
+    <li>
+      <span class="balloon-bottom">list</span>
+    </li>
+    <li>
+      <a class="twitter-share-button" href="https://twitter.com/share" data-dnt="true" data-count="vertical">Tweet</a>
+    </li>
+  </ul>
 </div>
```

```css
.twitter-share-button-with-balloon {
  list-style: none;
}

.twitter-share-button-with-balloon > :first-child + * {
  margin-top: 7px;
}
```

{{% image "20160124/step3.png" %}}

見た目はこれで完成.  
あとはLinkだが、このBlogは[Hugo](https://gohugo.io/)を使っているので、


```diff
 <div class="social-button">
   <ul class="twitter-share-button-with-balloon">
     <li>
+    <a href="https://twitter.com/search?q={{ .Permalink }}" target="_blank">
       <span class="balloon-bottom">list</span>
+    </a>
     </li>
     <li>
       <a class="twitter-share-button" href="https://twitter.com/share" data-dnt="true" data-count="vertical">Tweet</a>
     </li>
   </ul>
 </div>
```

のように `a` tagで囲えば完成.


# See Also

- [持続的なプラットフォームのための難しい決断](https://blog.twitter.com/ja/2015/buttons)
