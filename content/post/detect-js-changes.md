+++
Description = "detect-js-changesってToolを作った話."
Tags = ["Go", "CLI", "Kaizen Platform"]
date = "2016-01-27T21:45:41+09:00"
draft = true
title = "detect-js-changes"
slug = "detect-js-changes"
+++

detect-js-changesってToolを作った話.

<!--more-->

1. [Background]({{< relref "#background" >}})
2. [detect-js-changes]({{< relref "#detect-js-changes" >}})
3. [Go]({{< relref "#go" >}})
4. [See Also]({{< relref "#see-also" >}})


# Background

## JavaScript file

Kaizen PlatformではAB TestのJavaScript fileをBaseのfileにClient毎のDataを書き出して生成している.
生成後、JavaScript fileをClient毎のS3 ObjectにUploadしている.


## E2E

このAB TestのJavaScriptに対してPhantomJSやBrowserStack上でのE2E Testを行っている.

DeployのタイミングでこのE2E Testを実施しているのだが、
そもそも生成されるJavaScript fileに変更がなかった場合Test結果は変わらないのでskipするようになっている.


## Until now

このJavaScript fileに変更があるかないかの確認フローは、

1. 今までは対象のJavaScript files (16 files) のURLに対して `wget` .
2. Depoly.
3. 再度 `wget` .
4. 末尾にJavaScript file生成日時のTimestampと、ClientのDataに書き出した日時のTimestampがあるので、それら意外に差分がないかを `diff` で確認.

の様な感じだが、面倒くさいポイントがいくつもある.

- 何回も `wget` する.
    - Timestampの差分すら出なかった場合はS3の反映待ちだったりするので、再度 `wget` する.
- JavaScript fileはminifyしてあるので、`diff` をとるにはunminifyしないといけない.
- Timestampの差分はでるので、 `diff` の結果をTimestampの差分かどうか確認しないといけない.

ひとつひとつのStepはScriptが用意されていたりするが、それでも面倒くさい.


# detect-js-changes


# Go


# See Also

- なぜつくったか
- いままでのflow
- これからのflow
- 実装についてすこし
  - `beautify-go`
  - `diffmatchpatch`
  - `download` と `detect` は `sync.WaitGroup` で並列実行.
      - `go` で囲うだけで `download` がn倍.
