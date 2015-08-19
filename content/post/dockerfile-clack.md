+++
Description = "Introduction to Docker image for Clack Application."
Tags = ["Common Lisp", "Library", "Clack", "Docker", "mine"]
date = "2015-08-13T12:14:52+09:00"
title = "Docker image for Clack Application"
draft = true
+++

Clack Application用のDocker base imageを作成したので紹介.

<!--more-->

1. [How to use.]({{< relref "#how-to-use" >}})
2. [See Also]({{< relref "#see-also" >}})


How to use.
---

簡単な`app.lisp`を用意する.

```common-lisp
(defvar *app*
  (lambda (env)
    (declare (ignore env))
    '(200 (:content-type "text/plain") ("Hello, World"))))

(lack:builder
 :session
 *app*)
```

`FROM`として`rudolphm/clack`を指定してDockerfileを用意する.

```sh
FROM rudolphm/clack:latest
MAINTAINER Rudolph Miller


ADD app.lisp /usr/local/src/clack-test/

CMD woo --port 5000 /usr/local/src/clack-test/app.lisp
EXPOSE 5000
```

Dockerfileでやっているのは上の`app.lisp`を配置して、
`ENTRYPOINT`として`woo --port 500 app.lisp`を指定しているだけだ.
後はDockerで`build`して`run`するとClack Applicationが動く.

```sh
docker build -t rudolphm/clack-sample ./
docker run -it -p 5000:5000 rudolphm/clack-sample
```

Common Lispもようやくここまで来たかって所感.


See Also
---

- [Dockerfile-Clack GitHub](https://github.com/Rudolph-Miller/dockerfile-clack)
- [Clack GitHub](https://github.com/fukamachi/clack)
- [Woo GitHub](https://github.com/fukamachi/woo)
- [Roswell GitHub](https://github.com/snmsts/roswell)
