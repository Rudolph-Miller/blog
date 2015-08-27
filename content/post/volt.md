+++
Description = "Volt - Isomorphic web application framework in Ruby."
Tags = ["Ruby", "Library", "Opal", "Volt"]
date = "2015-08-26T08:09:00+09:00"
draft = true
slug = "volt"
title = "Volt - Isomorphic in Ruby"
+++

Isomorphic in RubyなFramework [Volt](https://github.com/voltrb/volt/)を紹介.

<!--more-->

__Features__

- Same code runs on the client and the server
- Automatic Data Syncing
- Reactive Data Bindings
- Components

VoltはClient, Server共にRubyで記述する__Isomorphic__で__Reactive__なWeb Application Frameworkで上のような特徴を持つ. 


1. [Getting Started]({{< relref "#getting-started" >}})
2. [Same code runs on the client and the server]({{< relref "#same-code-runs-on-the-client-and-the-server" >}})
3. [Automatic Data Syncing]({{< relref "#automatic-data-syncing" >}})
4. [Reactive Data Bindings]({{< relref "#reactive-data-bindings" >}})
5. [Components]({{< relref "#components" >}})
6. [See Also]({{< relref "#see-also" >}})


Getting Started
---

```sh
gem install volt
```

```sh
volt new sample_app
cd sample_app
bundle exec volt server
```

これでServerが起動する.

ファイルが変更されたときには、Voltは自動的にそのファイルをreloadし、Clientに変更をpushする.


Same code runs on the client and the server
---

ClientとServerをRubyでIsomorphicに書ける.

First RequestはServer Sideで実行されるが、それ以降はClient Sideで実行され、HTTP Requestが発生しない.

データはModelClassで表現され、それの同期はautomaticallyにWebSocketかそれと同等のSocket通信でなされる.


Automatic Data Syncing
---

ある1つのクライアント上でデータが更新されたときには、
データベース、および他のリスニング中のクライアント上でも更新が行われる.

```html
<!-- @ app/main/views/index.html -->
<:Body>
  {{ store._memos.each_with_index do |memo, index| }}
    <div>
      <label>{{ index + 1 }}</label>
      <span>{{ memo._text }}</span>
    </div>
  {{ end }}
  <form e-submit="add_memo">
    <label>memo: </label>
    <input type="text" value="{{ page._new_text }}" />
  </form>
```

```ruby
# @ app/main/controllers/main_controller.rb
module Main
  class MainController < Volt::ModelController
    def add_memo
      store._memos << { text: page._new_text }
      page._new_text = ''
    end
  end
end
```

- Viewでは`each`バインディングでイテレーションができる.
- Viewでは`e-{イベント名}`の属性でイベントをバインドして、Controllerのメソッドを呼び出すことができる.
- Viewでは`{{`と`}}`で囲った中のRubyのCodeを実行し、その返り血をrenderできる.
  - `self`はControllerのインスタンスなので`{{ add_memo }}`で`main_controller.rb`の`add_memo`が実行される.
- `_`(__Underscore Accessors__)によって事前に定義せずにPropertyにgetとsetができる.
- `page`は__Page Collection__と呼ばれるもので、一時的にデータを保存するためのもの.
- `value="{{ page._new_text }}"`で双方向バインドが可能.
  - Controllerでもpage._nex_textにget, setが可能.
- `store`は__Store Collection__と呼ばれるもので、データベースにデータを保存するためのもの.
- Voltは複数形の属性を自動的に空の`Volt::ArrayModel`に初期化する.
- `Volt::ArrayModel`にハッシュを追加した場合、自動的にVoltのモデルに変換される.

これだけで`memo: `のText Inputに入力してEnterすると、Memoの追加ができる.

これを複数Clientsで操作をするとリアルタイムで同期しているのが確認できる.


Reactive Data Bindings
---

DOM (および値が変更されたことを検知したい他のすべてのコード)に対して、
自動的に、かつ正確に変更を伝えるために、データフロー／リアクティブプログラミングを利用する.

DOMに何らかの変更があった場合に、Voltは変更が必要なノードだけを更新する.

```diff
 <!-- @ app/main/views/index.html -->
 <:Body>
   {{ store._memos.each_with_index do |memo, index| }}
     <div>
       <label>{{ index + 1 }}</label>
       <span>{{ memo._text }}</span>
     </div>
   {{ end }}
   <form e-submit="add_memo">
     <label>memo</label>
     <input type="text" value="{{ page._new_text }}" />
   </form>
+  {{ if too_much_memos }}<div>Are you crazy??</div>{{ end }}
```

```diff
 # @ app/main/controllers/main_controller.rb
 module Main
   class MainController < Volt::ModelController
     def add_memo
       store._memos << { text: page._new_text }
       page._new_text = ''
     end
+
+    def too_much_memos
+      store._memos.size.then do |size|
+        size > 10
+      end
+    end
   end
 end
```

- `store`の`ArrayModel`に対するメソッド実行は`promise`を返す.
  - 結果を処理するときは`.then`を使う.
  - [Promises in Opal](http://opalrb.org/blog/2014/05/07/promises-in-opal/)

ロジックを__宣言的に__記述すると、Userの操作に__reactive__にDOMが更新される.


Components
---

- ApplicationはComponentから成り立っている.
- `app/`以下のすべてのdirectoryはComponentである.
- ComponentはGemにすることも可能.
- Componentの依存が可能.
- ClientとServerでコードを共有できることによって、Full StackなComponentの提供を実現する.

Componentに分割することにより、コードを再利用可能で疎結合でテストを容易なものにする.


See Also
---

- [Volt GitHub](https://github.com/voltrb/volt/)
- [Volt Docs](http://voltframework.com/docs)
- [Opal GitHub](https://github.com/opal/opal)
- [Volt を使って10分でリアルタイムチャットアプリケーションを作るチュートリアル](http://fiveteesixone.lackland.io/2015/08/03/10-minutes-volt-chat-application-tutorial/)
- [Todo-Example-Volt GitHub](https://github.com/Rudolph-Miller/todo_example_volt)
