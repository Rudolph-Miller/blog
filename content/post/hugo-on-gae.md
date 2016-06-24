+++
Description = "Hugo を GAE で独自ドメイン & SSL で運用"
Tags = ["WIP"]
date = "2016-06-18T14:09:02+09:00"
draft = true
images = []
title = "Hugo on GAE"
+++

Hugo & 独自ドメイン & SSL を GAE で運用する方法を紹介する.

<!--more-->

この Blog は Kloudsec を使用していたが、飽きてきたの (と遅いの) で Google App Engine (GAE) に移行した.

[Kloundsec for SSL with Custom Domain on GitHub Pages]({{< relref "post/kloudsec-for-using-ssl-with-custom-domain-on-gh-pages.md" >}})

これまでの構成図

現在の構成図

- Google Cloud DNS 設定
    - ゾーン作成.
    - NSレコードの登録.
- Webマスターツールで所有権の証明.
    - TEXレコードをDNSで設定.
    - "確認"
- GAE 作成.
    - goapp のinstall
    - app.yml
        - static files only.
    - goapp deploy
    - 課金体系.
        - どれぐらいかかりそうか.
    - SSL対応.
        - Let's encrypt.
- CircleCIからGAEにdeploy.
    - https://circleci.com/docs/google-auth/
    - circle.ymlの紹介.

ほんとは fastly 使いたかったけど、独自ドメイン && SSL が有料だったので、やめた.


http://blog.youyo.info/post/2015/10/23/publish-hugo-in-gae/
http://qiita.com/kyokomi/items/84af37e9774faf9072ed
