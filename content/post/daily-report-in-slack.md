+++
Description = "Daily Report in Slack"
Tags = ["Slack", "Common Lisp"]
date = "2015-11-14T11:30:41+09:00"
draft = true
title = "Daily Report in Slack"
+++

Slackでの分報を日報にするToolを作った.

<!--more-->

[Slackで簡単に「日報」ならぬ「分報」をチームで実現する3ステップ 〜 Problemが10分で解決するチャットを作ろう](http://c16e.com/1511101558)

先日こんな記事があり、Kaizen Platform社内Slackにも技術顧問先導で `#times_${username}` channelが開設された.

![channel](/images/20151114/channel.png)

毎日、一日何をし、何を読んで、何を考え、何を書いたかを雑多に、
[Kobito](http://kobito.qiita.com/)で書いて、日報として[Qiita:Team](https://teams.qiita.com/)に投稿していた.
これを入社してから毎日続けていたのだが、二つ不満があった.

一つは、普段VimでCodeを書いているので、余分にApplicationとしてEditorを他に立ち上げたくないこと.

もう一つは、上の記事にも書かれていたが、チームとしてのスピード感がでないってこと.
ある程度の粒度の課題なら別で[Qiita:Team](https://teams.qiita.com/)に投稿するが、
小粒な課題や粒度の見えない課題を発見して、日報に書き、投稿後にコメントをもらったときには解決していたりする.

`#times_${username]` を始めてみると、余分にApplicationを立ち上げる必要がなく、
リアルタイムにコメントが貰え、いままでの日報の不満は解決された.
