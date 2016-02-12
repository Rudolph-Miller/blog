+++
Description = "HTMLなSlideをPDFにexportする."
Tags = ["Presentation", "Remark.js"]
date = "2016-02-12T23:27:43+09:00"
draft = true
title = "Export HTML Slide as PDF"
slug = "export-html-slide-as-pdf"
+++

HTMLなSlideをPDFにexportする.

<!--more-->

1. [HTML Slide]({{< relref "#html-slide" >}})
2. [Export HTML Slide]({{< relref "#export-html-slide" >}})
3. [See Also]({{< relref "#see-also" >}})


# HTML Slide

最近 [yusukebe/revealgo](https://github.com/yusukebe/revealgo) が話題となり
MarkdownでHTML Slideのgenerateが再燃(?)しているが、
HTML Slideで困るのがSlideの共有だ.

普段Remark.jsを使ってMarkdownからHTML Slideをgenerateしているのだが、
以前Kaizen PlatformでのTech Talk #4で [Slide]({{< relref "slide/about-lisp.md" >}})
を発表した際、共有のために `iframe` でこのSlideを埋め込んだ
[Blog post]({{< relref "post/tech-talk-about-lisp.md" >}}) を作り共有していた.

{{% image "20160213/share_lisp_1.gif" %}}

今更ながらふと、PhantomJSなどでScreenshotを撮り、それをPDFに変換し、
Speaker Deck や SlideShare にuploadして共有できないかと考えた.


# Export HTML Slide

そんなTool作ろうとしたところで、とりあえず調べてみると
[DeckTape](https://github.com/astefanutti/decktape) というProjectが見つかった.


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

Docker imageなので良い感じににcurrent directoryをmountして、さらにScreen sizeを指定して

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

あとはこの生成された `lisp.pdf` をSpeaker Deckにuploadすると、

<script async class="speakerdeck-embed" data-id="77ce6ba2d6134d94a77e432f0246cd06" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

のようにちゃんと処理できていることが分かる.

---

これでなんの気兼ねもなく、これからもMarkdownでSlideを作れる.

めでたし.

---

# See Also
- [yusukebe/revealgo](https://github.com/yusukebe/revealgo)
- [DeckTape](https://github.com/astefanutti/decktape)
- [Tech Talk About Lisp - Slide]({{< relref "slide/about-lisp.md" >}})
- [Tech Talk About Lisp - Blog post]({{< relref "post/tech-talk-about-lisp.md" >}})
