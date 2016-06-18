+++
Description = "WIP"
Tags = ["WIP"]
date = "2016-06-18T14:09:02+09:00"
draft = true
images = []
title = "hugo with gcs and fastly"
+++

そろそろ Kloudsec に飽きてきたのでなにか別のに移行しようかと.

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
    - goapp deploy
- CircleCIからGAEにdeploy.
    - https://circleci.com/docs/google-auth/
    - circle.ymlの紹介.

ほんとは fastly 使いたかったけど、独自ドメイン && SSL が有料だったので、やめた.
