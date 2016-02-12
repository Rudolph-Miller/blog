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
[DeckTape](https://github.com/astefanutti/decktape) というToolが見つかった.

## About DeckTape

DeckTapeは

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

とりあえずこれを使ってSpeaker Deckにuploadしてみる.


## Install

DeckTapeのREADMEの [Install](https://github.com/astefanutti/decktape#install) sectionを見ると、PhantomJSのforked versionを使用しているとのこと.
これを見てやめようかと思ったが、READMEを少し読んでいくと [Docker](https://github.com/astefanutti/decktape#docker) なるsectionがあり、どうもDocker imageを配布しているようなので、Docker imageでInstallすることにする.

```sh
$ docker pull astefanutti/decktape
```

簡単だ.


## Run

とりあえず

```sh
$ docker run astefanutti/decktape -h
```

してみると、

```sh
$ docker run astefanutti/decktape -h

Usage: phantomjs decktape.js [options] [command] <url> <filename>

command      one of: automatic, csss, deck, dzslides, flowtime, generic, impress, remark, reveal, shower, slidy
url          URL of the slides deck
filename     Filename of the output PDF file

Options:
   -s, --size                Size of the slides deck viewport: <width>x<height>  [1280x720]
   -p, --pause               Duration in milliseconds before each slide is exported  [1000]
   --screenshots             Capture each slide as an image  [false]
   --screenshots-directory   Screenshots output directory  [screenshots]
   --screenshots-size        Screenshots resolution, can be repeated
   --screenshots-format      Screenshots image format, one of [jpg, png]  [png]

Defaults to the automatic command.
Iterates over the available plugins, picks the compatible one for presentation at the 
specified <url> and uses it to export and write the PDF into the specified <filename>.
```

と表示され、ちゃんと動いてることが分かった.

Docker imageなのでうまい具合に `pwd` をmountして、

```sh
$ docker run --rm -v `pwd`:/pwd astefanutti/decktape -s 1240x930 https://blog.rudolph-miller.com/slide/2015/10/29/about-lisp/ /pwd/lisp.pdf
```

を実行すると

```sh
Loading page https://blog.rudolph-miller.com/slide/2015/10/29/about-lisp/ ...

Loading page finished with status: success
Remark JS DeckTape plugin activated
Printing slide #88      (1/88) ...
```

と読み込まれ、Remark.js製ということも判別でき、処理が始まったようだ.

最後に

```sh
Printed 88 slides
```

と表示されて、処理は終了. `lisp.pdf` にPDFが生成されていた.


## Upload


# See Also
- [yusukebe/revealgo](https://github.com/yusukebe/revealgo)
