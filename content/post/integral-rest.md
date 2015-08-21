+++
Description = "Introduction to Integral-Rest."
Tags = ["Common Lisp","Library","Integral","Integral-Rest","mine"]
date = "2015-08-21T06:37:46+09:00"
draft = true
title = "Integral-Rest"
+++

稚拙のIntegral-Restを紹介.

<!--more-->


1. [Integral-Rest]({{< relref "#integral-rest" >}})
2. [See Also]({{< relref "#see-also" >}})


Integral-Rest
---

Integral-RestはIntegralのDAO tableからREST APIを簡単に作るLibrary.

```common-lisp
(defpackage sample
  (:use :cl
        :integral
        :integral-rest))
(in-package :sample)

(connect-toplevel :sqlite3 :database-name ":memory:")

(defclass user ()
  ((id :initarg :id
       :type integer
       :primary-key t
       :accessor user-id)
   (name :initarg :name
         :type string
         :accessor user-name))
  (:metaclass integral:<dao-table-class>))

(ensure-table-exists (find-class 'user))
```

`:metaclass`として`integral:<dao-table-class>`を指定し、`user`を`defclass`する.  
後は`(set-rest-app)`をすると`*rest-app*`がREST API appに束縛されので、  
`*rest-app*`は`ningle:<app>`の`instance`なので、これをそのまま`clack:clackup`できる.

```common-lisp
(set-rest-app)

(clack:clackup *rest-app*)
;; => Listening on localhost:5000.
```

これだけでREST API ServerがPort 5000で立ち上がる.

```common-lisp
(create-dao 'user :name "Rudolph")
;; => #<USER id: 1>

(dex:get "http://localhost:5000/api/users")
;; => "[{\"id\":1,\"name\":\"Rudolph\"}]"

(dex:get "http://localhost:5000/api/users/1")
;; => "{\"id\":1,\"name\":\"Rudolph\"}"

(dex:post "http://localhost:5000/api/users" :contest '(("name" . "Miller")))
;; => "{\"id\":2,\"name\":\"Miller\"}"

(find-dao 'user 2)
;; => #<USER id: 2 name: "Miller">

(dex:put "http://localhost:5000/api/users/2" :contest '(("name" . "Tom")))
;; => "{\"id\":2,\"name\":\"Tom\"}"

(find-dao 'user 2)
;; => #<USER id: 2 name: "Tom">

(dex:delete "http://localhost:5000/api/users/2")
;; => "{\"id\":2,\"name\":\"Tom\"}"

(find-dao 'user 2)
;; => NIL
```

ちょっとしたAPI Serverだと`app.lisp`に十数行で書ける.


See Also
---

- [Integral-Rest GitHub](https://github.com/Rudolph-Miller/integral-rest)
- [Integral-Rest Document](http://rudolph-miller.github.io/integral-rest/overview.html)
- [Integral GitHub](https://github.com/fukamachi/integral)
- [Clack GitHub](https://github.com/fukamachi/clack)
