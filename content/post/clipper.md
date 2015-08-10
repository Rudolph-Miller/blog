+++
Description = "Introduction to Clipper."
Tags = ["Common Lisp", "Library", "Clipper", "mine"]
date = "2015-08-10T13:53:10+09:00"
title = "Introduction to Clipper"
+++

稚作のClipperを紹介.

<!--more-->

例えばMicro Blogサービスを作るとしよう.

```Common-Lisp
(defpackage sample.models
  (:use :cl
        :integral))
(in-package :sample.models)

(defclass user ()
  ((id :type integer
       :primary-key t
       :auto-increment t
       :not-null t
       :reader user-id)
   (name :col-type (:varchar 255)
         :initarg :name
         :accessor user-name))
  (:metaclass <dao-table-class>))

(defclass post ()
  ((id :type (:integer 11)
       :primary-key t
       :auto-increment t
       :not-null t
       :reader post-id)
   (content :type string
            :col-type (:varchar 255)
            :initarg :content
            :accessor post-content)
   (user-id :type integer
            :initarg :user-id
            :accessor post-user-id))
  (:metaclass <dao-table-class>))

(defun user-posts (user)
  (check-type user user)
  (select-dao 'post (where (:= :user_id (user-id user)))))
```

こんな感じに[Integral](https://github.com/fukamachi/integral)を使用しModelとして`user`と`post`を定義する.
とりあえずこれで`user`に紐づく`post`の投稿と`post`の一覧機能ができる.

次に`user`が名前の表示だけじゃ物足りなく感じ、Iconを設定できるようにしてみる.
Iconを設定するためにはImage Filesを保存、管理しなくてはならない.

開発を進めて行く内に、
「開発時はBrowserで確認するため`static/images/icons`に保存し、
test時は開発環境を壊したくないため`t/images/icons`に保存したい.
その上、productionではS3のBucketに保存したい.」
となるのは当然だと思う.
(少なくとも僕はそれが必要になった.)

これらの切り替えを簡単にするのが[Clipper](https://github.com/Rudolph-Miller/clipper)だ.

とりあえずIconのModelとして`icon`を用意して、`user`と紐づける.

```Common-Lisp
(defclass icon ()
  ((id :type integer
       :primary-key t
       :auto-increment t
       :not-null t
       :initarg :id)
   (user-id :type integer)
   (image-file-name :col-type (:varchar 255)
                    :initarg :image-file-name)
   (image-content-type :col-type (:varchar 255)
                       :initarg :image-content-type)
   (image-file-size :col-type (:integer 11)
                    :initarg :image-file-size)
   (url :type string
        :initarg :url))
  (:metaclass <dao-table-class>))


(defun user-icon (user)
  (check-type user user)
  (car
   (select-dao 'icon
               (where (:= :user_id (user-id user)))
               (limit 1))))
```

環境変数でのconfigの切り替えに[Envy](https://github.com/fukamachi/envy)を使用し、
`clipper:setup-clipper`の引数をenvごとに管理する.
又、切り替えのための`sample.models::setup-clipper`も定義しておく.

```Common-Lisp
(defpackage sample.config
  (:use :cl)
  (:import-from :envy
                :config-env-var
                :defconfig))
(in-package :sample.config)

(setf (config-env-var) "APP_ENV")

(defconfig |development|
    `(:clipper (:store-type :local
                :image-directory #P"/home/user/app/images/icons"
                :relative #P"/home/user/app/"
                :prefix "http://localhost:3000/"
                :format ":ID/:FILE-NAME.:EXTENSION")))

(defconfig |production|
    `(:clipper (:store-type :s3
                :aws-access-key (uiop:getenv "AWS_ACCESS_KEY")
                :aws-secret-key (uiop:getenv "AWS_SECRET_KEY")
                :s3-endpoint "s3-ap-northeast-1.amazonaws.com"
                :s3-bucket-name "sample-app"
                :format ":ID/:FILE-NAME.:EXTENSION")))

(defun config ()
  (envy:config #.(package-name *package*)))


(in-package :sample.models)

(defun setup-clipper ()
  (apply #'clipper:setup-clipper
         (append (list :clipper-class (find-class 'icon))
                 (getf (sample.config::config) :clipper))))

```

すると環境変数`APP_ENV`によってImage Filesの保存先を切り替えられる.

```Common-Lisp
(in-package :sample.models)

(ql:quickload :osicat)

(defvar *url* "http://www.lisperati.com/lisplogo_alien_256.png")

;; APP_ENV=development
(setf (osicat:environment-variable "APP_ENV") "development")
(setup-clipper)

(let* ((user (create-dao 'user :name "Rudolph"))
       (icon (create-dao 'icon :user-id (user-id user))))
  (save-dao (clipper:attach-image icon :url *url*))
  (clipper:image-url icon))

;; => "http://localhost:3000/images/icons/1/lisplogo_alien_256.png"


;; APP_ENV=production
(setf (osicat:environment-variable "APP_ENV") "production")
(setup-clipper)

(let* ((user (create-dao 'user :name "John"))
       (icon (create-dao 'icon :user-id (user-id user))))
  (save-dao (clipper:attach-image icon :url *url*))
  (clipper:image-url icon))

;; => "https://s3-ap-northeast-1.amazonaws.com/sample-app/2/lisplogo_alien_256.png"
```

便利.
