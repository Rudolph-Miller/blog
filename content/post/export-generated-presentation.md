+++
Description = "HTMLなpresentationをPDFにexportする"
Tags = ["Presentation", "Remark.js"]
date = "2016-02-12T23:27:43+09:00"
draft = true
title = "Export HTML Presentation as PDF"
slug = "export-html-presentation-as-pdf"
+++

HTMLなpresentationをPDFにexportする

<!--more-->

1. [HTML Presentations]({{< relref "#html-presentations" >}})
2. [Export HTML Presentations]({{< relref "#export-html-presentations" >}})
3. [See Also]({{< relref "#see-also" >}})


# HTML Presentations

最近 [yusukebe/revealgo](https://github.com/yusukebe/revealgo) が話題となり
MarkdownでHTML Presentationのgenerateが再燃(?)しているが、
HTML Presentationで困るのがPresentationの共有だ.

以前Kaizen PlatformでのTech Talk #4でRemark.js製の
https://blog.rudolph-miller.com/slide/2015/10/29/about-lisp/
を発表した後、共有のために `iframe` でこのSlideを埋め込んだBlog postを作り共有していた.

{{% image "20160213/share_lisp_1.gif" %}}

ふとPhantomJSなどでScreenshotを撮り、さらにそれをPDFに変換し、
Speaker Deck や SlideShare にuploadして共有できないかと考えた.


# Export HTML Presentations

そんなTool作ろうとしたところで、とりあえず調べてみると
[decktape](https://github.com/astefanutti/decktape) というToolが見つかった.

## About decktape

decktape は

> DeckTape is a high-quality PDF exporter for HTML5 presentation frameworks.

らしい.

SupportしているFrameworkは

- [CSSS](http://leaverou.github.io/csss/)
- [deck.js](http://imakewebthings.com/deck.js/)
- [DZSlides](http://paulrouget.com/dzslides/)
- [flowtime.js](http://flowtime-js.marcolago.com/)
- [HTML Slidy](http://www.w3.org/Talks/Tools/)
- [impress.js](http://impress.github.io/impress.js)
- [remark.js](http://remarkjs.com/)
- [reveal.js](http://lab.hakim.se/reveal-js)
- [Shower](http://shwr.me/)

で、使用していた Remark.js もsupportされていた.


# See Also
- [yusukebe/revealgo](https://github.com/yusukebe/revealgo)
