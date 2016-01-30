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
