+++
Description = "detect-js-changesという業務Toolを作った話."
Tags = ["Go", "CLI", "Kaizen Platform"]
date = "2016-01-27T21:45:41+09:00"
draft = true
title = "detect-js-changes"
slug = "detect-js-changes"
+++

[detect-js-changes](https://github.com/Rudolph-Miller/detect-js-changes)という業務Toolを作った話.

<!--more-->

1. [Background]({{< relref "#background" >}})
2. [detect-js-changes]({{< relref "#detect-js-changes" >}})
3. [Go]({{< relref "#go" >}})
4. [See Also]({{< relref "#see-also" >}})


# Background

## JavaScript file

Kaizen PlatformではAB TestのJavaScript fileをBaseのfileにClient毎のDataを書き出して生成している.
生成後、JavaScript fileをClient毎のS3 ObjectにUploadしている.


## E2E

このAB TestのJavaScriptに対してPhantomJSやBrowserStack上でのE2E Testを行っている.

DeployのタイミングでこのE2E Testを実施しているのだが、
そもそも生成されるJavaScript fileに変更がなかった場合Test結果は変わらないのでskipする様になっている.


## Until now

このJavaScript fileに変更があるかないかの確認フローは、

1. 今までは対象のJavaScript files (16 files) のURLに対して `wget` .
2. Depoly.
3. 再度 `wget` .
4. 末尾にJavaScript file生成日時のTimestampと、ClientのDataに書き出した日時のTimestampがあるので、それら意外に差分がないかを `diff` で確認.

の様な感じだが、面倒くさいポイントがいくつもある.

- 何回も `wget` する.
    - Deploy環境によってURLが変わる. (QA用やProduction用など.)
    - Timestampの差分すら出なかった場合はS3の反映待ちだったりするので、再度 `wget` する.
- JavaScript fileはminifyしてあるので、`diff` をとるにはunminifyしないといけない.
- Timestampの差分はでるので、 `diff` の結果をTimestampの差分かどうか確認しないといけない.

ひとつひとつのStepはScriptが用意されていたりするが、それでも面倒くさい.

Depoly毎 (基本は週2回) にこれを誰かが実行している.


# detect-js-changes

この面倒くささを解消するために作ったのが `detect-js-changes` だ.

```sh
$ go get github.com/Rudolph-Miller/detect-js-changes
```

でinstallできる.

`detect-js-changes` を使うと上の確認フローが、

1. `detect-js-changes download`
2. Deploy.
3. `detect-js-changes download`
4. `detect-js-changes detect`

の様になる.

Deploy環境ごとのURLは `config.yml` に

```yml
qa:
  urls:
  - https://qa.kaizenplatform.com/file1.js
  - https://qa.kaizenplatform.com/file2.js
production:
  urls:
  - https://production.kaizenplatform.com/file1.js
  - https://production.kaizenplatform.com/file2.js
```

の様にYAMLで記述し、

```
detect-js-changes -e qa -c config.yml
```

の様に指定できる.

`config.yml` でどういうKeywordをignoreするか
(今回は末尾のTimestampとClientのDataのTimestampを特定するKeyword)
を指定できる.

```yml
default:
  ignore_keywords:
  - Timestamp
  - generated_at
qa:
  urls:
  - https://qa.kaizenplatform.com/file1.js
  - https://qa.kaizenplatform.com/file2.js
production:
  urls:
  - https://production.kaizenplatform.com/file1.js
  - https://production.kaizenplatform.com/file2.js
```


# Go

軽く実装に触れておく.

言語は `Go` を使用しており、採用理由はなんとなくである.


## CLI

CLIには [`codegangsta/cli`](https://github.com/codegangsta/cli) を使用した.

感想は特にない.


## YAML

YAML formatのConfig fileのparseには [gopkg.in/yaml.v2](https://github.com/go-yaml/yaml) を使用した.

```go
package main

import (
  "fmt"
  "gopkg.in/yaml.v2"
  "os"
)

var data = `
key1: value1
key2:
  key3:
  - value2
  - value3
`

type T struct {
  Key1 string
  Key2 struct {
    Key3 []string
  }
}

func main() {
  t := T{}
  err := yaml.Unmarshal([]byte(data), &t)
  if err != nil {
    fmt.Println(err)
    os.Exit(1)
  }

  fmt.Println(t)
  // {value1 {[value2 value3]}}
}
```

の様にOutputの `struct` を用意して `yaml.Unmarshal` するのだが、今回のConfig fileは

```yaml
default:
  ignore_keywords:
  - sample keyword
development:
  urls:
  - https://development.kaizenplatform.com/file0.js
  - https://development.kaizenplatform.com/file1.js
production:
  urls:
  - https://production.kaizenplatform.com/file0.js
  - https://production.kaizenplatform.com/file1.js
```

の様に環境名がTop levelのKeyとなりその下に特定のKVが入る形式で、
環境名はUserが自由に指定でき、Top levelのKeyが指定できない.

この場合は

```go
package main

import (
  "fmt"
  "gopkg.in/yaml.v2"
  "os"
)

var data = `
default:
  key1: value1
  key2:
    key3:
    - value2
    - value3
development:
  key1: value1
  key2:
    key3:
    - value2
    - value3
`

type T struct {
  Key1 string
  Key2 struct {
    Key3 []string
  }
}

func main() {
  m := make(map[string]T)
  err := yaml.Unmarshal([]byte(data), &m)
  if err != nil {
    fmt.Println(err)
    os.Exit(1)
  }

  fmt.Println(m)
  // map[default:{value1 {[value2 value3]}} development:{value1 {[value2 value3]}}]
}
```

の様に `map` で指定する.


## Unminify

minified fileのunminifyには [`ditashi/jsbeautifier-go/jsbeautifier`](https://github.com/ditashi/jsbeautifier-go) と言う [jsbeautifier](http://jsbeautifier.org) のGo port (CLI tool) の内部APIを使用した.

```js
function main(){var e={key1:"value1",key2:{key3:["value2","value3"]}};console.log(e)}
```

の様なminifiedなJavaScriptを `example.min.js` として用意して、

```go
package main

import (
  "fmt"
  "github.com/ditashi/jsbeautifier-go/jsbeautifier"
)

func beautify(src string) *string {
  options := jsbeautifier.DefaultOptions()
  return jsbeautifier.BeautifyFile(src, options)
}

func main() {
  filename := "example.min.js"
  fmt.Println(*beautify(filename))
}
```

を `go run` すると、

```js
function main() {
    var e = {
        key1: "value1",
        key2: {
            key3: ["value2", "value3"]
        }
    };
    console.log(e)
}
```

とunminifyできる.


## Diff

- `diffmatchpatch`

## go

- `download` と `detect` は `sync.WaitGroup` で並列実行.
    - `go` で囲うだけで `download` がn倍.


# See Also

- [detect-js-changes](https://github.com/Rudolph-Miller/detect-js-changes)
