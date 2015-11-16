+++
Description = "Jonathan unescapes Unicode Escape Sequence"
Tags = ["Common Lisp", "Jonathan"]
date = "2015-11-16T15:26:12+09:00"
draft = true
slug = "jonathan-unescapes-unicode-escape-sequence"
title = "Jonathan unescapes Unicode Escape Sequence"
+++

[Jonathan](https://github.com/Rudolph-Miller/jonathan)にUnicode Escape Sequenceをunescapeする機能を入れた.

<!--more-->

1. [Unicode Escape Sequence]({{< relref "#unicode-escape-sequence" >}})
2. [See Also]({{< relref "#see-also" >}})

# Unicode Escape Sequence

先日[Daily Log in Slack](http://blog.rudolph-miller.com/2015/11/14/daily-log-in-slack/)で報告した[Slack Nippo](https://github.com/Rudolph-Miller/slack-nippo)を作っている時に、
SlackのAPIのResponseにUnicode Escape Sequenceがあり、[Jonathan](https://github.com/Rudolph-Miller/jonathan)がこれをusescapeしていなかったことを知った.

[YASON](http://hanshuebner.github.io/yason/)も[CL-JSON](https://common-lisp.net/project/cl-json/)ももちろん対応しているので、
[Jonathan](https://github.com/Rudolph-Miller/jonathan)にUnicode Escape Sequenceをunescapeする機能を入れた.

```lisp
(jonathan:parse "\"\\u30b8\\u30e7\\u30ca\\u30b5\\u30f3\"")
;; => "ジョナサン"
```

もちろんSurrogate pairも対応している.

```lisp
(jonathan:parse "\"\\uD840\\uDC0B\"")
;; => "𠀋"
```

ちなみに[CL-JSON](https://common-lisp.net/project/cl-json/)はSurrogate pairを投げると文字化けする.

```lisp
(with-input-from-string (stream "\"\\uD840\\uDC0B\"")
  (cl-json:decode-json stream))
;; => "��"
```

不具合があれば[Issues](https://github.com/Rudolph-Miller/jonathan/issues)にreportもらえれば対応します.

# See Also

- [Daily Log in Slack](http://blog.rudolph-miller.com/2015/11/14/daily-log-in-slack/)
- [Slack Nippo](https://github.com/Rudolph-Miller/slack-nippo)
- [Jonathan](https://github.com/Rudolph-Miller/jonathan)
- [YASON](http://hanshuebner.github.io/yason/)
- [CL-JSON](https://common-lisp.net/project/cl-json/)
