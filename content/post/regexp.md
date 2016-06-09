+++
Description = "正規表現エンジンの作り方."
Tags = ["Common Lisp", "Regexp"]
date = "2016-05-04T22:14:57+09:00"
draft = true
title = "Create Regexp engine"
slug = "create-regexp-engine"
images = ["/20160608/regexp.png"]
+++

正規表現エンジンの作り方.

<!--more-->

1. [Regexp]({{< relref "#regexp" >}})
2. [VM]({{< relref "#vm" >}})
3. [NFA]({{<relref "#nfa" >}})
4. [DFA]({{<relref "#dfa" >}})
5. [See Also]({{< relref "#see-also" >}})

Programmerなら親しみのある正規表現だが、
そういえば正規表現エンジンは作ったことないやと思ったので調べながら作ってみた.


# Regexp

Regular Expression (正規表現) は文字列のパターンの表現.

regular (正規) に深い意味はないらしい.
というか "regular" に "正規" って訳語は違和感しかない.
数学では "正則" で統一されている (はず) .


## History

1943年、Waren McCullochとWalter Pittsが [A Logical Calculus of the Ideas Immanent in Nervous Activity](http://cns-classes.bu.edu/cn550/Readings/mcculloch-pitts-43.pdf) で神経細胞の振る舞いを計算モデル化した Formal Neurons (形式ニューロン) を提案した.  
Formal Neurons は論理回路で言うところのORゲート、ANDゲート、NOTゲートを持っていたので任意の論理回路を表現することができた.
(Formal Neurons は記憶領域が無いため、[チューリング完全](https://ja.wikipedia.org/wiki/%E3%83%81%E3%83%A5%E3%83%BC%E3%83%AA%E3%83%B3%E3%82%B0%E5%AE%8C%E5%85%A8)ではない.)  
さらに彼らは同論文の中で Formal Neurons の独自の記法を導入した.

{{% image "20160608/formal_neurons.png" %}}

1951年、Kleeneが [Representation of Events in Nerve Nets and Finite Automata](https://www.rand.org/content/dam/rand/pubs/research_memoranda/2008/RM704.pdf) で Formal Neurons の表現として Regular Expression を提案し、さらに同論文の中で Finite Automaton (有限オートマトン) という計算モデルの導入を行い、Formal Neurons が Finite Automatonに変換できることを示した.

{{% image "20160608/regexp.png" %}}

1959年、M.O.RabinとD.Scottが [Finite Automata and Their Decision Problems](http://www.cse.chalmers.se/~coquand/AUTOMATA/rs.pdf) で Non-deterministic Finite Automaton (NFA, 非決定性有限オートマトン) を導入し、決定性と非決定性の等価性を照明した.

1968年、
Kenneth Thompsonが [Regular Expression Search Algorithm](http://www.fing.edu.uy/inco/cursos/intropln/material/p419-thompson.pdf) で正規表現を入力としてそれにマッチする文字列を検索する仕組みの提案と、その実装方法を示した.  
それまでの検索アルゴリズムは部分的にマッチしたルートが途中でマッチに失敗したときに Backtracking (直近の処理の分岐点に戻ること) をしていた.  
このアルゴリズムは直近の分岐点の保存のため多量のstorageを必要とし、さらにとても遅かった.  
そこで記憶領域を使用しない計算モデルである NFA を使用し、それらの問題を解決した.  
この論文では

- Regular Expression から NFA を構築する方法 (Thompson's construction algorithm, Thompsonの構成法)
- NFA を効率よくシミュレートする方法 (Thompson NFA)
- シミュレーションを実行するIBM 7094 codeを直接生成する方法

を示した.  
最後のはつまり Regular Expression のJIT compiler. 世界初のRegular Expressionの実装の論文にも関わらず、JIT compilerまで実装して発表していた.


## Pure Regular Expression

__純粋な__正規表現の定義.


### Ring

Ring (環) とは、

Set $R$上の加法 $+: R \times R \to R$ と乗法 $\cdot: R \times R \to R$ の組 $(R, +, \cdot)$ で、
$(R, +)$ が Abelian group (アーベル群) で $(R, \cdot)$ が Monoid (モノイド) なもので以下の分配法則を満たすもの.

$$
a, b, c \in Rに対して、\ a \cdot (b + c) = a \cdot b + a \cdot c \ が成立する.
$$

$$
a, b, c \in Rに対して、\ (a + b) \cdot c = a \cdot c + b \cdot c \ が成立する.
$$

アーベル群？モノイド？ ggrks.  
というか環の定義ぐらいは前提として良かったかもしれない.


### Semi-ring

Semi-ring (半環) は Ring で $(R, +)$ の要求をモノイドとしたもの.


### Idempotent semi-ring

Idempotent semi-ring (冪等半環) は Semi-ring の加法に以下のように冪等演算であることを要求したもの.

$$
\forall a \in R,\ a + a = a
$$


### Kleene algebra

Kleene algebra (クリーネ代数) は Idempotent semi-ring に 以下の性質を持つ Kleene star $^*: R \to R$ を導入したもの.

$$
a, b \in R\ で、a \leq b \iff a + b = b\ として以下が成立する. \\\
1 + a \cdot a^* \leq a^* \\\
1 + a^* \cdot a \leq a^* \\\
a \cdot b \leq b \Rightarrow a^* \cdot b \leq b \\\
b \cdot a \leq b \Rightarrow b \cdot a^* \leq b
$$

Kleene star は

$$
a^* = 1 + a + a \cdot a + a \cdot a \cdot a \cdots
$$

のようにも表せる.


### Language

### Regular Expression

---

regexp -> AST -> NFA -> minimum NFA -> DFA -> exec
regexp -> AST -> bytecode -> exec via VM


# NFA


# DFA

NFA->DFA


# VM

instrument list


# See Also
