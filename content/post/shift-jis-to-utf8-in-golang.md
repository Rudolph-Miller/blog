+++
Description = "GoでShift_JISをUTF-8に変換."
Tags = ["Go"]
date = "2016-07-09T17:10:16+09:00"
draft = false
images = []
slug = "shift-jis-to-utf-8-in-go"
title = "Shift_JIS to UTF-8 in Go"
+++

Go で Shift_JIS を UTF-8 に変換.

<!--more-->

Go で HTML の scraper を書いていると、
日本語の HTML の scraper に恒例の Shift_JIS の conversion が必要になったのでメモ.

1. [Script]({{< relref "#script" >}})
2. [See Also]({{< relref "#see-also" >}})

# Script

```
string -> Reader -> (decoded)  Reader -> []byte -> string
```

と変換していく.

```go
package main

import (
	"fmt"
	"golang.org/x/text/encoding/japanese"
	"golang.org/x/text/transform"
	"io/ioutil"
	"strings"
)

func shift_jis_to_utf8(str string) (string, error) {
	strReader := strings.NewReader(str)
	decodedReader := transform.NewReader(strReader, japanese.ShiftJIS.NewDecoder())
	decoded, err := ioutil.ReadAll(decodedReader)
	if err != nil {
		return "", err
	}
	return string(decoded), err
}
```


# See Also

- [package japanese](https://godoc.org/golang.org/x/text/encoding/japanese)
- [package transform](https://godoc.org/golang.org/x/text/transform)
- [package ioutil](https://godoc.org/io/ioutil)
- [package strings](https://godoc.org/strings)
