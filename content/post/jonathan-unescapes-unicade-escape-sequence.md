+++
Description = "Jonathan unescapes Unicode Escape Sequence"
Tags = ["Common Lisp", "Jonathan"]
date = "2015-11-16T09:40:15+09:00"
draft = true
title = "Jonathan unescapes Unicode Escape Sequence"
slug = "jonathan-unescapes-unicode-escape-sequence"
+++

[Jonathan](https://github.com/Rudolph-Miller/jonathan)にUnicode Escape Sequenceのunescapeの機能を入れた.

<!--more-->

先日[Daily Log in Slack](http://blog.rudolph-miller.com/2015/11/14/daily-log-in-slack/)で報告した[Slack Nippo](https://github.com/Rudolph-Miller/slack-nippo)を作っている時に、
SlackのAPIのResponseにUnicode Escape Sequenceがあり、[Jonathan](https://github.com/Rudolph-Miller/jonathan)がこれをusescapeしていなかったことを知った.

[YASON](http://hanshuebner.github.io/yason/)も[CL-JSON](https://common-lisp.net/project/cl-json/#DEFAULT-OPERATION)ももちろん対応しているので、
[Jonathan](https://github.com/Rudolph-Miller/jonathan)にUnicode Escape Sequenceのunescapeの機能を入れた.

```lisp
(jonathan:parse "\"\\u30b8\\u30e7\\u30ca\\u30b5\\u30f3\"")
;; => "ジョナサン"
```

ちゃんとSurrogate pairも対応している.

```lisp
(jonathan:parse "\"\\uD840\\uDC0B\"")
;; => "𠀋"
```

ちなみに[CL-JSON](https://common-lisp.net/project/cl-json/#DEFAULT-OPERATION)はSurrogate pairを投げると文字化けする.

```lisp
(with-input-from-string (stream "\"\\uD840\\uDC0B\"")
  (cl-json:decode-json stream))
;; => "��"
```
