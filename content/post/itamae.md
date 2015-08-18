+++
Description = "Introduction to Itamae."
Tags = []
date = "2015-08-18T22:19:36+09:00"
title = "Introduction to Itamae"
+++

Itamaeを紹介.

<!--more-->


1. [What Itamae is.]({{< relref "#what-itamae-is" >}})
2. [How to use Itamae.]({{< relref "#how-to-use-itamae" >}})
3. [See Also]({{< relref "#see-also" >}})


What Itamae is.
---

- [Itamae](https://github.com/itamae-kitchen/itamae)はサーバーの構成管理ツールの一つ.
- Ruby DSLが使えるが、Chefほど色々覚えなくて良い.
- レシピをGemに閉じ込めることが可能.

本当に簡単に使え、Bundlerで依存管理が可能で、使い勝手が良かったので紹介する.


How to use Itamae.
---

```sh
gem install itamae
```

でitamaeをinstallし、

```ruby
package 'sl' do
  action :install
end
```

と`sl.rb`に書き込む.

```sh
itamae local sl.rb
```

でlocalに`sl`をinstallできる.

```sh
gem install 'docker-api'
itamae docker --image centos sl.rb
```

で`centos`をBaseに`sl`コマンド入りのDocker imageを作成できる.  
と言いたいとこだが、`No package sl available.`だ.  
仕方ないので、`centos`ではSourceからmakeするよう`sl.rb`を変更する.

```ruby
case node[:platform]
when 'darwin'
  package 'sl'
when 'redhat'
  %w( git gcc make ncurses-devel ).each do |package|
    package package do
      action :install
    end
  end

  git '/usr/local/src/sl' do
    repository 'https://github.com/mtoyoda/sl'
  end

  execute 'install sl' do
    cwd '/usr/local/src/sl'
    command <<-"EOS"
    make
    cp ./sl /usr/local/bin/sl
    EOS
  end
end
```

`node[:platform]`で分岐して`redhat`なら[Source](https://github.com/mtoyoda/sl)をからbuildする.

```sh
$ itamae docker --image centos sl.rb
 INFO : Starting Itamae...
 INFO : Recipe: /Users/tomoya/ruby/sample.rb
 INFO :   package[git] installed will change from 'false' to 'true'
 INFO :   package[gcc] installed will change from 'false' to 'true'
 INFO :   package[make] installed will change from 'false' to 'true'
 INFO :   package[ncurses-devel] installed will change from 'false' to 'true'
 INFO :   git[/usr/local/src/sl] exist will change from 'false' to 'true'
 INFO :   execute[install sl] executed will change from 'false' to 'true'
 INFO : Image created: 7534d8550ce218cc9d111e92a28e1c56549730bf52d5e6c83363f8a9b2042825
$ docker run -it 7534d8550ce218cc9d111e92a28e1c56549730bf52d5e6c83363f8a9b2042825 sl
```

でdocker containerでSLが走る.


GemとしてpublishされているRecipeを使用するのも簡単だ.

```sh
gem install itamae-plugin-recipe-nginx
```

と`nginx`のRecipeをinstallし、
(登録されていないので実際にはinstallできない.)

```ruby
# To include recipe at lib/itamae/plugin/recipe/nginx.rb
include_recipe 'nginx'

# To include recipe at lib/itamae/plugin/recipe/nginx/debug.rb
include_recipe 'nginx::debug'
```

と書くだけでRecipeのincludeができる.


See Also
---

- [Itamae GitHub](https://github.com/itamae-kitchen/itamae)
- [Itamae - Infra as Code 現状確認会](https://speakerdeck.com/ryotarai/itamae-infra-as-code-xian-zhuang-que-ren-hui)
- [Specinfra](https://github.com/mizzy/specinfra)
