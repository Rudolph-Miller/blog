+++
Description = "Volt - Isomorphic web application framework in Ruby."
Tags = ["Ruby", "Library", "Opal", "volt"]
date = "2015-08-26T08:09:00+09:00"
draft = true
title = "Volt - Isomorphic in Ruby"
slug = "volt"
+++

Isomorphic in RubyなFramework [Volt](https://github.com/voltrb/volt/)を紹介.

<!--more-->

1. [Getting Started]({{< relref "#getting-started" >}})
1. [Reactive Data Bindings ]({{< relref "#reactive-data-bindings" >}})
1. [See Also]({{< relref "#see-also" >}})

__Keywords__

- Automatic Data Syncing
- Reactive Data Bindings
- Components


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

Clientとのほとんどの通信をWebSocketかそれと同等のSocket通信で行い.
初回のページ読み込み以外では、クライアントとのデータの同期にHTTPを利用しない.


Reactive Data Bindings
---

```html
@ app/main/views/index.html
<:Body>
  <button e-click="incr_counter" class="btn btn-default">Click</button>
  <div>{{ page._counter }}</div>
```

```ruby
@ app/main/controllers/main_controller.rb
module Main
  class MainController < Volt::ModelController
    def incr_counter
      page._counter ||= 0
      page._counter += 1
    end
  end
end
```

ボタンをclickすると`page._counter`をインクリメントするように`View`と`Controller`を書く.

```diff
@ app/main/views/index.html
 <:Body>
   <button e-click="incr_counter" class="btn btn-default">Click</button>
   <div>{{ page._counter }}</div>
+  {{ if cool? }}<div>Cool!</div>{{ end }}
```

```diff
@ app/main/controllers/main_controller.rb
module Main
 module Main
   class MainController < Volt::ModelController
     def incr_counter
       page._counter ||= 0
       page._counter += 1
     end
+
+    def cool?
+      page._counter && page._counter >= 10
+    end
   end
 end
```

`star`10回で`Cool!`と表示を宣言的に記述するだけ.


See Also
---

- [Volt GitHub](https://github.com/voltrb/volt/)
- [Volt Docs](http://voltframework.com/docs)
- [Todo-Example-Volt GitHub](https://github.com/Rudolph-Miller/todo_example_volt)
