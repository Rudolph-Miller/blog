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
