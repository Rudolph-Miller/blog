+++
Description = "About me"
Tags = []
date = "2015-08-11T07:32:04+09:00"
draft = false
title = "Abount me"
slug = "me"
+++

1. [Bio]({{< relref "#bio" >}})
2. [Social]({{< relref "#social" >}})
3. [Works]({{< relref "#works" >}})
4. [Media]({{< relref "#media" >}})

Software Engineer in Tokyo, Japan.

大学時代は代数的整数論にはまる.  
現在はKaizen Platform, Inc.でTech leadを務める.  
プライベートでは最近はCompiler作りやらなんやら.

<span class="author-avatar">
  {{< image "logo.png" >}}
</div>
<span class="author-avatar">
  {{< image "me.png" >}}
</div>

# Bio

- 2011/04/01 京都大学法学部に入学.
- 2012/04/01 京都大学総合人間学部 数理情報学科に転学部.
- 2014/03/31 京都大学法学部を中退.
- 2014/05/01 サムライト株式会社に参画.
- 2014/11/01 サムライト株式会社でCTOに就任.
- 2015/08/31 サムライト株式会社を退職.
- 2015/09/01 Kaizen Platform, Inc.に参画. (Application Engineer)
- 2016/03/01 Kaizen Platform, Inc.でTech leadに就任.

# Projects

## サムライト株式会社

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

## Kaizen Platform, Inc.

- Application Engineer.
  - 2016/03/01からTech lead.

# Social

- [Twitter](https://twitter.com/Rudolph_Miller)
- [GitHub](https://github.com/Rudolph-Miller)
- [LinkedIn](https://www.linkedin.com/in/tomoya-kawanishi-1ab963b7)


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

# Media

- [好きなCommon Lispで新しいWeb開発を～京大中退、22歳のサムライトCTOが取り組んだシステム再構築](http://type.jp/et/log/article/somewrite_cto)
