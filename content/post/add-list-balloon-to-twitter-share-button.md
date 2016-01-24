+++
Description = "Twitterのshare buttonにList-balloonを追加する"
Tags = ["Twitter", "CSS"]
date = "2016-01-24T22:23:30+09:00"
draft = true
title = "Add List-balloon to Twitter share button"
slug = "add-list-balloon-to-twitter-share-button"
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

Twitter、 はてなブックマーク、Facebook、Google+のシェアボタンがBalloon付きでならんでいたが、TwitterのシェアボタンだけがBalloon無しとなり、統一感がなくなった.
違和感を感じつつも放置していたのだが、最近あるBlogでTwittenのシェアボタンの上にBalloonで `list` と表示し、
*https://twitter.com/search* のその記事のPermalinkの検索結果へのLinkとなるようにしているのを見かけたので実装してみた.


# Add List-balloon


# See Also

- [持続的なプラットフォームのための難しい決断](https://blog.twitter.com/ja/2015/buttons)
