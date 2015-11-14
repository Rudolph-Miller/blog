+++
Description = "Daily Log in Slack"
Tags = ["Slack", "Common Lisp"]
date = "2015-11-14T11:30:41+09:00"
draft = true
title = "Daily Log in Slack"
slug = "daily-log-in-slack"
+++

Slackでの分報を日報にするToolを作った.

<!--more-->

1. [Slackで社内Twitter]({{< relref "#slackで社内twitter" >}})
2. [Slack Nippo]({{< relref "#slack-nippo" >}})
3. [See Also]({{< relref "#see-also" >}})

## Slackで社内Twitter

[Slackで簡単に「日報」ならぬ「分報」をチームで実現する3ステップ 〜 Problemが10分で解決するチャットを作ろう](http://c16e.com/1511101558)

先日こんな記事があり、Kaizen Platform社内Slackにも技術顧問先導で `#times_${username}` channelが開設された.

![channel](/images/20151114/channel.png)

やってみて感じたことと、これに関してToolを書いているので報告する.

毎日日報を[Kobito](http://kobito.qiita.com/)で書いて、[Qiita:Team](https://teams.qiita.com/)に投稿しているのだが、二つ不満があった.

一つは、普段Vimを使っているので、余分にApplicationとしてEditorを立ち上げたくないこと.

もう一つは、上の記事にも書かれていたが、"チームとしてのスピード感がでない"ってこと.
ある程度の粒度の課題なら別で[Qiita:Team](https://teams.qiita.com/)に投稿するが、
小粒な課題や粒度の見えない課題を発見して、日報に書き、投稿後にコメントをもらったときには解決していたりする.

`#times_${username]` を始めてみると、余分にApplicationを立ち上げる必要がなく、
リアルタイムにコメントが貰え、いままでの日報の不満は解決された.

それだけではなく、不思議としっくりくる感じがあった.
考えてみるとこれは__社内でのコミュニケーションに近い__のだ.

席にいるかが一目で分かり、
悩んでいると声をかけられ、
話していると他の人が乱入してくる.  
リモートワークを取り入れている会社にとって、__この空気__を生み出せるのは重要だと思う.

デメリットもある.
だたのチャットなので__流れる__.
後で__"あの時の課題はどうやって解決したっけ"__みたいなのがぱっとでてこない.


## Slack Nippo

ということで、一日の終わりにこの `#times_${username}` をまとめて日報とするToolを作った.

![daily log](/images/20151114/daily_log.png)

タスク管理はTrelloを使用しており、そのログを `#times_${username}` に流すようにした.  
今はこのMarkdownを[Qiita:Team](https://teams.qiita.com/)に投稿している.

まだ実験段階なのでローカルで叩いてMarkdownを吐き出すだけだが、  
フォーマットと機能がまとまってきたら、Serverとして起動して生成したMarkdownをSlackに投稿したり、
[Qiita:Team](https://teams.qiita.com/)に直接投稿できる機能をつける.

Source codeは[Slack Nippo - GitHub](https://github.com/Rudolph-Miller/slack-nippo/)にある.  
とりあえず日報をだしたかったので、かなり雑な部分があるのは認識している.  

[Amazon API Gateway](https://aws.amazon.com/jp/api-gateway/)と[AWS Lambda](https://aws.amazon.com/jp/lambda/)でやろうと考えていたのだが、
気がつくと__Common Lisp__を書いていた. 心地よかった.  
Serverとして機能をつけたらDocker Imageも[Docker Hub](https://hub.docker.com/)に上げてローカルで簡単に立ち上げられるようにする.

## See Also

- [Slackで簡単に「日報」ならぬ「分報」をチームで実現する3ステップ 〜 Problemが10分で解決するチャットを作ろう](http://c16e.com/1511101558)
- [Slack Nippo](https://github.com/Rudolph-Miller/slack-nippo/)
