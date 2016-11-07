+++
Description = "About me"
Tags = []
date = "2015-08-11T07:32:04+09:00"
draft = false
title = "About me"
slug = "me"
+++

[<img class="globe-icon" src="/images/globe.svg"> English]({{< relref "page/en/me.md" >}})

1. [Bio]({{< relref "#bio" >}})
2. [Projects]({{< relref "#projects" >}})
    1. [サムライト株式会社]({{< relref "#サムライト株式会社" >}})
    2. [Kaizen Platform, Inc.]({{< relref "#kaizen-platform-inc" >}})
    3. [無所属]({{< relref "#無所属" >}})
3. [Works]({{< relref "#works" >}})
4. [Languages]({{< relref "#languages" >}})
5. [Social]({{< relref "#social" >}})
6. [Media]({{< relref "#media" >}})

HN: [Rudolph Miller](https://www.google.co.jp/search?q=Rudolph+Miller)  
本名: [河西 智哉](https://www.google.co.jp/search?q=河西+智哉)  
Email: [me@rudolph-miller.com](mailto:me@rudolph-miller.com)

Software Engineer in Tokyo, Japan.

現在は無所属.
[SEEED](https://thepedia.co/article/1769/) 始動.

<span class="author-avatar">
  {{< image "/logo.png" >}}
</div>
<span class="author-avatar">
  {{< image "/me.png" >}}
</div>

# Bio

- 2011/04/01 京都大学法学部に入学.
- 2012/04/01 京都大学総合人間学部 数理情報学科に転学部.
- 2014/03/31 京都大学を中退.
- 2014/05/01 サムライト株式会社に参画.
- 2014/11/01 サムライト株式会社でCTOに就任.
- 2015/08/31 サムライト株式会社を退職.
- 2015/09/01 Kaizen Platform, Inc. に参画. (Application Engineer)
- 2016/03/01 Kaizen Platform, Inc. でTech leadに就任.
- 2016/10/31 Kaizen Platform, Inc. を退職.
- 2016/11/01 無所属.

# Projects

## サムライト株式会社

- Native AD Network.
- Native AD Networkの0からの構築.
    - 最高で 40k req/min.
- インフラの設計、構築.
    - ADの急なrequest増加に耐えうるインフラを構築.
    - "Configuration as Code" を採用.
    - 使用技術:
        - AWS
            - EC2
            - RDS
            - Route 53
            - Elastic Load Balancing
            - Elastic Beanstalk
            - DynamoDB
            - Auto Scaling
        - Chef
        - Ansible
        - Docker
        - Itamae
- 管理 Applicationの設計、実装.
    - DB設計.
    - 初期はRuby on Railsで構築. 後に、Caveman2 (Common LispのWeb application framework) でreplace.
    - 後半はFront-endのFrameworkとしてReact.jsを採用.
- 配信 Applicationの設計、実装.
    - 初期はNode.js (http モジュールを使用.) で構築. 後に、Caveman2 (Common LispのWeb application framework) でreplace.
- 採用活動を行う.
- Slack.
- リモートワーク.

## Kaizen Platform, Inc.

- Web siteのOptimizing platform.
- Application Engineer.
    - 2016/03/01からTech lead.
      - 担当システムの技術デザイン、採用技術について責任を負う.
        - 正しい設計が行われているか.
        - その設計は過剰ではないか / 抽象化の程度は良いバランスを保っているか.
          - 設計が理想的かどうかだけでなく、納期や実現したい価値の程度に対して妥当な設計規模に収まっているかについても判断する.
        - コードの品質が維持できているか.
            - コードレビュー.
            - 適切なテストが書かれているか.
      - 早い時期に問題になりそうな技術コンポーネントを特定・対処する.
      - [Tech Lead（TL/テックリード）の役割 - サンフランシスコではたらくソフトウェアエンジニア](http://d.hatena.ne.jp/higepon/20150806/1438844046) からProject leaderの役割を引いたもの.
- Slack.
- 週の半分ほどをリモートワーク.
- Web application "Kaizen Platform"のserver-sideの設計・開発.
    - Ruby
    - Ruby on Rails
- Web application "Kaizen Platform"のfront-endの設計・開発.
    - CoffeeScript
    - Angular.js
- A/B test coreのJavaScript programの設計・開発.
    - CoffeeScript
- A/B test coreのログ取得・解析 programの設計・開発.
    - CoffeeScript
    - Koa
- A/B testデザイン案作成 GUI editorの設計・開発.
    - CoffeeScript
- Ruby on Railsのupgrade.
    - 3.2 -> 4.2
    - UpgradeにおけるApplicationの変更を担当.
- UI/UX見直しProjectのPM (Product Manager).
    - On-boardig flowを設計することにより、Userがカンタンに改善活動を始められるようにする.
    - 合わせて全体のUX設計を見直す.


## 無所属

- [ANRI 佐俣アンリ氏 x 元Kaizen Platform 河西智哉氏 x フリークアウト/イグニス 佐藤裕介氏がタッグを組む、インキュベーションプロジェクト「SEEED」始動](https://thepedia.co/article/1769/)


# Works

- [Clipper](https://github.com/Rudolph-Miller/clipper)
    - Ruby on Railsの[Paperclip](https://github.com/thoughtbot/paperclip)のCommon Lispでの簡易実装.
    - [Blog - Clipper]({{< relref "post/clipper.md" >}})
- [React Sortable Table](https://github.com/Rudolph-Miller/react-sortable-table)
- [React Simple Tab](https://github.com/Rudolph-Miller/react-simple-tab)
- [Cl-Gists](https://github.com/Rudolph-Miller/cl-gists)
    - GitHubのGistsの[API](https://developer.github.com/v3/gists/)のCommon Lisp wrapper.
- [Cl-Annot-Prove](https://github.com/Rudolph-Miller/cl-annot-prove)
- [Jonathan](https://github.com/Rudolph-Miller/jonathan)
    - Common Lisp最速のJSON serializer/deserializer.
- [Elb-Log](https://github.com/Rudolph-Miller/elb-log)
- [Dyna](https://github.com/Rudolph-Miller/dyna)
    - DynamoDBのCommon Lisp wrapper.
    - SimpleなAPIのwrappingだけではなく、ORM interfaceも実装.
- [Dockerfile-Clack](https://github.com/Rudolph-Miller/dockerfile-clack)
    - Common LispのWeb application environmentであるClack上に作られたWeb applicationをDocker上で動かすためのBase docker image.
    - [Blog - Docker image for Clack Application]({{< relref "post/dockerfile-clack.md" >}})
- [Integral-Rest](https://github.com/Rudolph-Miller/integral-rest)
    - [Blog - Integral-Rest]({{< relref "post/integral-rest.md" >}})
- [Detect JS Changes](https://github.com/Rudolph-Miller/detect-js-changes)
    - minifiedな複数のJS fileのdeploy前後の差分を確認するTool.
    - Go製.
    - [Blog - detect-js-changes]({{< relref "post/detect-js-changes.md" >}})


# Languages

- 日本語:
    - 関西弁: ネイティブ
    - 標準語: ビジネス上級レベル
- 英語:
    - 日常会話レベル
        - 2009/09/10 - 2010/02/05: カナダのバンクーバー付近に留学.


# Social

- [Twitter](https://twitter.com/Rudolph_Miller)
- [GitHub](https://github.com/Rudolph-Miller)
- [LinkedIn](https://www.linkedin.com/in/tomoya-kawanishi-1ab963b7)
- [Facebook](https://www.facebook.com/chopsticks.tk.ppfm)


# Media

- [好きなCommon Lispで新しいWeb開発を～京大中退、22歳のサムライトCTOが取り組んだシステム再構築](http://type.jp/et/log/article/somewrite_cto)
- [エンジニアで年収４ケタってどうやったらなれるの？稼いでる人に聞いてきた](https://codeiq.jp/magazine/2016/06/42239/)
- [ANRI 佐俣アンリ氏 x 元Kaizen Platform 河西智哉氏 x フリークアウト/イグニス 佐藤裕介氏がタッグを組む、インキュベーションプロジェクト「SEEED」始動](https://thepedia.co/article/1769/)
