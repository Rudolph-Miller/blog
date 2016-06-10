+++
Description = "正規表現エンジンの作り方 (と形式言語とオートマトン)."
Tags = ["Common Lisp", "RegExp", "Math"]
date = "2016-06-11T08:01:45+09:00"
draft = false
images = ["/20160608/regexp.png"]
slug = "create-regexp-engine"
title = "Regular Expression Engine (and Regular Language and Automaton)"
+++

正規表現エンジンの作り方 (と形式言語とオートマトン).

<!--more-->

1. [Regular Expression]({{< relref "#regular-expression" >}})
2. [History]({{< relref "#history" >}})
3. [Math]({{< relref "#math" >}})
    1. [Regular Language & Regular Expression]({{< relref "#regular-language-regular-expression" >}})
        1. [Ring]({{< relref "#ring" >}})
        2. [Semi-ring]({{< relref "#semi-ring" >}})
        3. [Idempotent semi-ring]({{< relref "#idempotent-semi-ring" >}})
        4. [Kleene algebra]({{< relref "#kleene-algebra" >}})
        5. [Language]({{< relref "#language" >}})
        6. [Regular Language]({{< relref "#regular-language" >}})
        7. [Pure Regular Expression]({{< relref "#pure-regular-expression" >}})
        8. [Regular Expression => Regular Language]({{< relref "#regular-expression-regular-language" >}})
        9. [Regular Language => Regular Expression]({{< relref "#regular-language-regular-expression-1" >}})
        10. [Regular Language <=> Regular Expression]({{< relref "#regular-language-regular-expression-2" >}})
    2. [Regular Language & Finite Automaton]({{< relref "#regular-language-finite-automaton" >}})
        1. [Abstract machine]({{< relref "#abstract-machine" >}})
        2. [Finite automaton]({{< relref "#finite-automaton" >}})
        3. [Deterministic Finite Automaton]({{< relref "#deterministic-finite-automaton" >}})
        4. [Deterministic vs. Non-deterministic]({{< relref "#deterministic-vs-non-deterministic" >}})
          1. [DFA => NFA]({{< relref "#dfa-nfa" >}})
          2. [NFA => DFA]({{< relref "#nfa-dfa" >}})
              1. [記号列遷移の1記号遷移化]({{< relref "#記号列遷移の1記号遷移化" >}})
              2. [$\epsilon$ 遷移の除去]({{< relref "#epsilon-遷移の除去" >}})
              3. [Subset construction により DFA の構成]({{< relref "#subset-construction-により-dfa-の構成" >}})
          3. [DFA <=> NFA]({{< relref "#dfa-nfa-1" >}})
        5. [FA's Language]({{< relref "#fa-s-language" >}})
        6. [Regular Language => FA's Language]({{< relref "#regular-language-fa-s-language" >}})
        7. [FA's Language => Regular Language]({{< relref "#fa-s-language-regular-language" >}})
        8. [Regular Language <=> FA's Language]({{< relref "#regular-language-fa-s-language-1" >}})
    3. [Result]({{< relref "#result" >}})
4. [Implementation]({{< relref "#Implementation" >}})
    1. [AST]({{< relref "#ast" >}})
    2. [Parser]({{< relref "#parser" >}})
    3. [FA]({{< relref "#fa" >}})
    4. [NFA]({{< relref "#nfa" >}})
    5. [Run]({{< relref "#run" >}})
    6. [Match]({{< relref "#match" >}})
5. [Wrap-up]({{< relref "#wrap-up" >}})
6. [See Also]({{< relref "#see-also" >}})


そういえば正規表現エンジン作ったことないやと思ったので作ってみた.  
正規表現、形式言語、オートマトンの関係 (の数学的定義と証明) をついでにまとめてみた.


# Regular Expression

Regular expression (正規表現) は文字列のパターンの表現.

regular (正規) に深い意味はないらしい.
というか "regular" に "正規" って訳語は違和感しかない.
数学では "正則" が定訳なはず.


# History

1943年、Waren McCullochとWalter Pittsが
[A Logical Calculus of the Ideas Immanent in Nervous Activity](http://cns-classes.bu.edu/cn550/Readings/mcculloch-pitts-43.pdf)
で神経細胞の振る舞いを計算モデル化した Formal neurons (形式ニューロン) を提案した.  
Formal neurons は論理回路で言うところのORゲート、ANDゲート、NOTゲートを持っていたので任意の論理回路を表現することができた.
(Formal neurons は記憶領域が無いため、[チューリング完全](https://ja.wikipedia.org/wiki/%E3%83%81%E3%83%A5%E3%83%BC%E3%83%AA%E3%83%B3%E3%82%B0%E5%AE%8C%E5%85%A8)ではない.)  
さらに彼らは同論文の中で Formal neurons の独自の記法を導入した.

{{% image "20160608/formal_neurons.png" %}}

1951年、Kleeneが
[Representation of Events in Nerve Nets and Finite Automata](https://www.rand.org/content/dam/rand/pubs/research_memoranda/2008/RM704.pdf)
で Formal neurons の表現として Regular expression を提案し、
さらに同論文の中で Finite automaton (有限オートマトン) という計算モデルの導入を行い、
Formal neurons が Finite automatonに変換できることを示した.

{{% image "20160608/regexp.png" %}}

1959年、M.O.RabinとD.Scottが
[Finite Automata and Their Decision Problems](http://www.cse.chalmers.se/~coquand/AUTOMATA/rs.pdf)
で Non-deterministic finite automaton (NFA, 非決定性有限オートマトン) を導入し、決定性と非決定性の等価性を照明した.

1968年、 Kenneth Thompsonが
[Regular Expression Search Algorithm](http://www.fing.edu.uy/inco/cursos/intropln/material/p419-thompson.pdf)
で正規表現を入力としてそれにマッチする文字列を検索する仕組みの提案と、その実装方法を示した.  
それまでの検索アルゴリズムは部分的にマッチしたルートが途中でマッチに失敗したときに Backtracking (直近の処理の分岐点に戻ること) をしていた.  
このアルゴリズムは直近の分岐点の保存のため多量の storage を必要とし、さらにとても遅かった.  
そこで記憶領域を使用しない計算モデルである NFA を使用し、それらの問題を解決した.  
この論文では

- Regular expression から NFA を構築する方法 (Thompson's construction algorithm, Thompsonの構成法)
- NFA を効率よくシミュレートする方法 (Thompson NFA)
- シミュレーションを実行するIBM 7094 codeを直接生成する方法

を示した.  
最後のはつまり Regular expression のJIT compiler. 世界初のRegular expressionの実装の論文にも関わらず、
JIT compilerまで実装して発表していた.


# Math

Regular expression と Finite automaton の関係について Regular language を経由して述べる.


## Regular Language & Regular Expression

まずは Regular Language の定義 (とその前提知識の定義) と、
Regular language と Regular Expression の関係.


### Ring

Ring (環) とは、

Set (集合) $R$上の加法 $+: R \times R \to R$ と乗法 $\cdot: R \times R \to R$ の組 $(R, +, \cdot)$ で、
$(R, +)$ が Abelian group (アーベル群) で $(R, \cdot)$ が Monoid (モノイド) なもので以下の分配法則を満たすもの.

$$
a, b, c \in R\ で\ a \cdot (b + c) = a \cdot b + a \cdot c \ が成立する.
$$

$$
a, b, c \in R\ で\ (a + b) \cdot c = a \cdot c + b \cdot c \ が成立する.
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

Kleene algebra (クリーネ代数, クリーニ代数) は Idempotent semi-ring
に、以下の性質を持つ Kleene star $^*: R \to R$ を導入したもの.  
(なお、演算の優先順は $^ *$ , $\cdot$ , $+$ である.)

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

$$
\Sigma = \lbrace \sigma \mid \sigma = 文字 \rbrace
$$

のように文字の Set を考える. 文字は有限なのでこれは Finite set (有限集合) となる.  
$\Sigma$ 上に文字列の集合 $\Sigma^*$ を考える. これは文字列の長さは無限なので Infinite set (無限集合) となる.  

$$
\Sigma^* = \lbrace \langle \sigma_1, \sigma_2, \cdots \rangle \mid \sigma_i \in \Sigma \cup \lbrace \epsilon \rbrace
$$

ただし $\epsilon$ は空文字列を表す.


Formal language (形式言語) の理論において、 $\Sigma$ 上の Language (言語) とは $\Sigma^*$ の部分集合のことを指す.

$$
L \subseteq \Sigma^*
$$


### Regular Language

$\Sigma$ 上の Language $L$ に Kleene algebra を展開する.

- $\emptyset \subseteq L$ ($\emptyset$ は空集合)
- $\lbrace \epsilon \rbrace \subseteq L$
- $\forall \sigma \in \Sigma$ について $\lbrace \sigma \rbrace \subseteq L$
- $A, B \subseteq L$ について
    - $A \cup B \subseteq L$
    - $A \cdot B \subseteq L$
    - $A^* \subseteq L$
        - $A^* = \lbrace \epsilon \rbrace \cup A \cup A \cdot A \cup \cdots$
        - Kleene closure (クリーネ閉包) と呼ぶ.

これらを満たす Language をRelugar language (正規言語, $L_{RL}$) と呼ぶ.


### Pure Regular Expression

pure な Regular expression は文字と3つの基本演算で定義される.  
(ここで pure といってるのは、Repular expression engine の実装依存の拡張と区別するため.)

3つの基本演算:

- Choice (選択): `a|b`
- Concatenation (連接): `ab`
- Repetition (繰り返し): `a*`

なお演算の優先順は Repetition , Concatenation , Choice である.

Regular expression ($E$) は次の Grammer (文法) に従う.

- $\epsilon \subseteq E$
- $\forall \sigma \in \Sigma\ で\ \sigma \in E$
- $E_1, E_2 \subseteq E\ で\ E_1|E_2 \subseteq E$
- $E_1, E_2 \subseteq E\ で\ E_1E_2 \subseteq E$
- $E1 \subseteq E\ で\ E1* \subseteq E$


### Regular Expression => Regular Language

Regular expression ($E$) が定義する $\Sigma$ 上の Language ($L(E)$)を考える.

- $E = \epsilon\ なら\ L(E) = \emptyset$
- $\forall \sigma \in \Sigma\ で\ E = \sigma\ なら\ L(E) = \lbrace \sigma \rbrace$
- $E_1, E_2 \subseteq E\ で\ E = E_1|E_2\ なら\ L(E) = L(E_1) \cup L(E_2)$
- $E_1, E_2 \subseteq E\ で\ E = E_1E_2\ なら\ L(E) = L(E_1) \cdot L(E_2)$
- $E_1 \subseteq E\ で\ E = E_1*\ なら\ L(E) = L(E1)^ *$

これが与える Language を $L_{RE}$ とすると、上の定義より $L _{RE} \subseteq L _{RL}$ がわかる.  
つまり、 Regular expression が与えられると必ず対応する Regular language が存在することがわかる.


### Regular Language => Regular Expression

与えられた Regular language ($L$) から、その Language を定義する
Regular expression ($E(L)$) の構成法を考える.

- $L = \emptyset\ なら\ E(L) = E(\emptyset) = \epsilon$
- $\sigma \in \Sigma\ で\ L = \lbrace \sigma \rbrace\ なら\ E(L) = E(\lbrace \sigma \rbrace) = \sigma$
- $L_1, L_2 \subseteq L\ で\ L = L_1 \cup L_2\ なら\ E(L) = E(L_1)|E(L_2)$
- $L_1, L_2 \subseteq L\ で\ L = L_1 \cdot L_2\ なら\ E(L) = E(L_1)E(L_2)$
- $L_1 \subseteq L\ で\ L = L_1^*\ なら\ E(L) = E(L_1) *$

とすることにより、 Regular language に対応する Regular expression を構成可能である.  
つまり、 $L _{RL} \subseteq L _{RE}$ .


### Regular language <=> Regular expression

$L _{RE} \subseteq L _{RL}$ かつ $L _{RL} \subseteq L _{RE}$ より $L _{RE} = L _{RL}$ .  
つまり、 Regular expression が定義する Language と Regular language は同じ.


## Regular Language & Finite Automaton

Finite automaton の定義 (とその前提知識の定義) と、
Regular language と Finite automaton の関係.


### Abstract machine

Abstract machine (抽象機械) は計算システムを形式的に扱うために考えられた数学的モデルで、
計算可能性などを分析するのに思考実験で利用される.

この Machine は Finite control (有限制御機構) と External storage (外部記憶装置) から構成される.  
制御機構が有限であるとは制御機構が備えている記憶容量が有限で、有限の状態しか取り得ないことを意味する.  
外部記憶には形式的扱いが容易なテープが通常用いられる.

Abstract machineには次のような種類がある.

種類             | 構成
-----------------|----
Finite automaton | 制御機構、入力テープ
Push down automaton | 制御機構、入力テープ、制限付き作業テープ
Turing machine | 制御機構、入力テープ、作業テープ

制御機構はあらかじめ定義された State (状態) のいずれかをとる.  
この機械が取り得る状態の集合は $Q = \lbrace q_0, q_1, q_2, \cdots \rbrace$ と表される.  
機械は一時に一状態しか取れない.  
機械の動作は機械の状態と入力情報 (入力テープから読み込んだ記号) により状態を変化したり、テープを操作したりすること.  
機械は一定の状態になるか次状態が定義されていないため動作が継続できなくなると停止し、停止時の状態やテープ構成により様々な判定が行われる.  
動作が一意に決まるとき deterministic (決定的) といい、そうでない場合を non-deterministic (非決定的) という.

以上より Abstract machine ($M$) は次の5つの組 $M = (Q, \Sigma, \delta, q_0, F)$ で定義される.

- $Q$ は有限な状態の集合.
- $\Sigma$ は記号の集合.
- $\delta$ は State transition function (状態遷移関数) で deterministic machine の動作 step を定義する.
    - Non-deterministic machine の場合は $\Delta$ で表され、 State transition relation (状態遷移関係) と呼ばれる.
- $q_0 \in Q$ は Initial state (初期状態) .
- $F \subseteq Q$ は Final state set (終了状態集合) で $F$ の要素は Final state (終了状態) と呼ばれ、機械が停止した時の状態が Final state であれば、機械は入力を accept (受理) したという. そうでない場合を reject (拒否) したという.


### Finite automaton

Finite automaton (FA, 有限オートマトン, Finite State Machine, FSM, 有限状態機械) は Abstract machine の一つで、制御機構と入力テープの二つから構成される. 状態遷移は現状態と入力記号の2つにより決定される. つまり、状態遷移は現状態と入力記号と次状態の3要素の組の集合として定義される.

deterministic な Finite automaton を Deterministic finite automaton (DFA, 決定性有限オートマトン)、 non-Deterministic なものを Non-deterministic finite automaton (NFA, 非決定性有限オートマトン) と呼ぶ.


### Deterministic Finite Automaton

DFA は $(Q, \Sigma, \delta, q_0, F)$ により以下のように形式的に定義される.

- $Q$ は有限な状態の集合.
- $\Sigma$ は記号の集合.
- $q, q' \in Q, \sigma \in \Sigma\ で\ \delta: (q, \sigma) \to q'$
- $q_0 \in Q$ は Initial state.
- $F \subseteq Q$ は Final state set.

DFA が定義する Language は DFA が accept する記号列の集合.

DFA の動作は Machine configulation (動作状態) とその Machine configulation の step を与える演算子により形式的に定義できる.

- DFA ($M$) の Machine configulation ($C$) は DFA の state とテープの state で定義できる.
    - $q \in Q, [p, x]: Tape configulation\ で\ C = (q, [p, x])$
        - $[p, x]$ は Tape configulation (テープ構成) と呼び、 $x$ がそのテープの記号列で $p$ がその記号列上の現在位置. $x(p)$ で $p$ の位置の記号を表す.
    - $M$ の Machine configulation の集合を $C(M)$ で表す.
        - $C(M) = \lbrace (q, [p, x]) \mid q \in Q, x \in \Sigma^*, 1 \leq p \leq |x| + 1 \rbrace$
- DFA の Machine configulation の 1 step 進行を表す関係演算子を $\vdash_M: C(M) \to C(M)$ とする.
    - $C_1, C_2 \in C(M)\ で\ p_1 + 1 = p_2\ かつ\ \delta(q_1, x(p_1)) = q_2$ が成り立つとき $C_1 \vdash_M C_2$ と表す.
- DFA は $C_h = (q, [p, x])$ で $\delta(q, x(p))$ が未定義なときに停止する.
    - $C_h = (q, [|x| + 1, x])$ を Final configulation (最終状態) と呼び、テープの最後に到達した状態を表す.

$C_i \subseteq C(M), 0 \leq i \leq n$ を一連の Machine configulation としたとき、

$$
C _0 \vdash _M C _1, C _1 \vdash _M C _2, \cdots, C _{n-1} \vdash _M C _n
$$

が成立するとき

$$
C_0 \vdash_M^* C
$$

のように表示する. この式は Computation (計算過程) を表す.

DFA ($M$) で入力 ($x$) について、

$$
f \in F\ で\ (q_0, [1, x]) \vdash _M^* (f, [|x| + 1, x])
$$

が成立するとき $M$ は $x$ を accept するという.


### Deterministic vs. Non-deterministic

決定性と非決定性.

種類|状態遷移|入力|次状態
----|--------|----|------
DFA|関数|現状態、1記号|1状態
NFA|関係|現状態、記号列($\epsilon$ を含む)|複数の状態が可能

DFA と NFA は状態遷移が異なるだけ.

- NFA は次状態が複数ある場合がある.
- DFA は常にテープが1つ進むが、NFA は記号列の長さ分一気にすすんだり、 $\epsilon$ が入力と成り得る場合は進まなかったりする.
- Non-deterministic な動作では可能なすべての状態遷移を試みる. 試みたすべての Machine configulation 中に1個でも accept な Machine configulation があれば全体で $x$ を accept とする. そうでなければ reject とする.

DFA が定義する Language ($L _{DFA}$) と NFA が定義する Language ($L _{NFA}$) の関係をみていく.


#### DFA => NFA

DFA が定義する Language を考えると、NFA の定義は DFA の定義を包含しているため

$$
L _{DFA} \subseteq L _{NFA}
$$

が成立する.


#### NFA => DFA

与えられた NFA に対して同一な Language を accept する DFA が以下の手順で構成できる.

1. [記号列遷移の1記号遷移化]({{< relref "#記号列遷移の1記号遷移化" >}})
2. [$\epsilon$ 遷移の除去]({{< relref "#epsilon-遷移の除去" >}})
3. [Subset construction (部分集合構成法) により DFA の構成]({{< relref "#subset-construction-により-dfa-の構成" >}})

当初の NFA を $M = (Q, \Sigma, \Delta, q_0, F)$ とし、各段階で得られる NFA をそれぞれ $M_1$, $M_2$, $M_3$ とする.


##### 記号列遷移の1記号遷移化

1. $M_1 = (Q_1, \Sigma, \Delta_1, q_0, F)$ として、 $Q_1$, $\Delta_1$ をそれぞれ $Q$, $\Delta$ と等しくする.
2. $\forall (q, \sigma, q') \in \Delta, |\sigma| \geq 1$ について
    - $\Delta_1$ から $(q, \sigma, q')$ を取り除く.
    - $|\sigma| = k$ として新規状態 $q_1, q_2, \cdots, q_k$ を $Q_1$ に追加する.
    - $\Delta_1$ に遷移 $(q, \sigma(1), q_1), (q1, \sigma(2), q_2), \cdots, (q _{k-1}, \sigma(k), q')$ を追加する.

これらを行うことによって、 $M$ と $M_1$ は同一となることは明らか.


##### $\epsilon$ 遷移の除去

1. $M_2 = (Q_2, \Sigma, \Delta_2, q_0,F_2)$ として定義し $\Delta_2 = \emptyset$ とする.
2. $\forall q \in Q_1, \forall a \in \Sigma\ で\ (q, [1, a]) \vdash _{M_1}^* (q', [2, a])$ を満たす $(q, a, q')$ により $\Delta_2 = \Delta_2 \cup \lbrace (q, a, q') \rbrace$ とする.
3. $Q_2$ を 2. で構築した $\Delta_2$ の下で $q_0$ から到達可能な状態の集合とする.
4. $F_2 = \lbrace q \mid q \in Q_2, f \in F_1, (q, [1, \epsilon]) \vdash _m^* (f, [1, \epsilon]) \rbrace$ のように $F_2$ を定義する.

これらを行うことによって、 $M_1$ と $M_2$ は同一となることは明らか.


##### Subset construction により DFA の構成

$M_3 = (Q_3, \Sigma, \delta_3, \lbrace q_0 \rbrace, F)$ とする.

1. $Q_3$ は集合を要素とする集合で、 $Q_2$ の Power set (冪集合) の Subset (部分集合) .
    - $Q_3 \subseteq \mathcal{P}(Q_2)$
2. Initial state は $\lbrace q_0 \rbrace$ .
3. $F_3 = \lbrace Q' \mid Q' \subseteq Q_3, Q' \cap F2 \neq \emptyset \rbrace$ とする.
4. $\delta_3$ を次のように構成する.
    - $Q_3$ のInital state $\lbrace q_0 \rbrace$ だけからなる遷移表を初期値として $\delta_3$ を構成する.
    - $(q_0, a_i, q') \in \Delta_2$ に対して $\delta_3$ の遷移 $(\lbrace q_0 \rbrace, a_i, Q')$ の遷移先 $Q'$ に $q'$ を追加する.
    - $Q'$ が $\delta_3$ に含まれていなければ、表に $Q'$ を追加する.
    - 追加された $Q'$ について、 $\forall q \in Q', \forall a_i \in \Sigma$ について $(q, a_i, q') \in \Delta_2$ を調べる、追加する.
    - 表に新規に追加される State が無くなれば $\delta_3$ は完成.

これらを行うことによって、 $M_2$ と $M_3$ は同一となることは明らか.


これら 1 - 3 の操作により、

$$
L _{NFA} \subseteq L _{DFA}
$$

が成立する.


#### DFA <=> NFA

$L _{DFA} \subseteq L _{NFA}$ かつ $L _{NFA} \subseteq L _{DFA}$ より $L _{DFA} = L _{NFA}$ .


### FA's Language

Finite automaton が定義する Language の性質を調べる.

- 2つの Finite automaton $M_1$, $M_2$ について、 $M _{\cup}$ を考える.
    - 新たに Inital state と Final state を追加して、
      追加した Initial state から $\epsilon$ で $M_1$, $M_2$ の Initial state に遷移し、
      $M_1$, $M_2$ のすべての Final state から追加した Final state に $\epsilon$ で遷移するように構成し、
      これを $M _{\cup}$ と呼ぶ.
    - $M _{\cup}$ が accept する Language ($L(M _{\cup})$) は $L(M _{\cup}) = L(M_1) \cup L(M_2)$ である.
        - 構成法よりこれが成立することは明らか.
    - つまり、 $L_1, L_2 \in L _{FA}\ で\ L_1 \cup L_2 \in L _ {FA}$ が成立し、和演算について閉じている.
- 2つの Finite automaton $M_1$, $M_2$ について、 $M _{\circ}$ を考える.
    - 新たに Initial state と Final state を追加して、
      追加した Inital state から $\epsilon$ で $M_1$ の Initial state に遷移し、
      $M_1$ のすべての Final state から $M_2$ の Initial state に $\epsilon$ で遷移し、
      $M_2$ のすべての Final state から追加した Final state に $\epsilon$ で遷移するように構成し、
      これを $M _{\circ}$ と呼ぶ.
    - $M _{\circ}$ が accept する Language ($L(M _{\circ})$) は $L(M _{\circ}) = L(M_1) \circ L(M_2)$ である.
        - 構成法よりこれが成立することは明らか.
    - つまり、 $L_1, L_2 \in L _{FA}\ で\ L_1 \circ L_2 \in L _ {FA}$ が成立し、連結演算について閉じている.
- 2つの Finite automaton $M$ について、 $M _{^*}$ を考える.
    - 新たに Initial state と Final state を追加して、
      追加した Inital state から $\epsilon$ で $M$ の Initial state に遷移し、
      $M$ のすべての Final state から追加した Final state に $\epsilon$ で遷移し、
      追加した Inital state と Final state が互いに $\epsilon$ で遷移するように構成し、
      これを $M _{^*}$ と呼ぶ.
    - $M _{^*}$ が accept する Language ($L(M _{^ *})$) は $L(M _{^ *}) = L(M _1) ^ *$ である.
        - 構成法よりこれが成立することは明らか.
    - つまり、 $L \in L _{FA}\ で\ L^* \in L _ {FA}$ が成立し、 Kleene star 演算について閉じている.


### Regular Language => FA's Language

任意の Regular language ($L$) からその Language を accept する Finite automaton ($M$) を構成する.

- $L = \emptyset$ なら $M_{\emptyset} = (\lbrace q_0, q_1 \rbrace, \Sigma, \emptyset, q_0, \lbrace q_1 \rbrace)$ が対応する.
    - $M_{\emptyset}$ は Final set への遷移をもたないので accept する記号列はない. つまり、空集合を accept する.
- $\sigma \in \Sigma\ で\ L = \lbrace \sigma \rbrace$ なら $M_1 = (\lbrace q_0, q_1 \rbrace, \Sigma, \lbrace (q_0, \sigma, q_1) \rbrace, q_0, \lbrace q_1 \rbrace)$ が対応する.
- [FA's Language]({{< relref "#fa-s-language" >}}) で述べた $L_{FA}$ の性質より、 Regular language $L_1$, $L_2$ が Finite automaton で定義可能なら、 $L_1 \cup L_2$, $L_1 \circ L_2$, $L_1^*$ も Finite automaton で定義可能. Regular language はこれらの操作のみで構成されるので、すべての Regular language について対応する Finite automaton が存在する.

よって、

$$
L _{RL} \subseteq L _{FA}
$$

が成立する.


### FA's Language => Regular Language

Finite automaton ($M$) の accept する Language を Regular language ($L$) で表現する.

- $M$ に必要であれば Initial state と Final state を一つ追加し、それぞれもとの Initial state と Final state と $\epsilon$ 遷移で接続し、 $M$ の Inital state と Final state がそれぞれ唯一つとなるようにする.
- $M$ 上の $\delta$ のすべての要素 $(q, \sigma, q')$ を Regular launguage $L = \lbrace \sigma \rbrace$ での遷移とみなし、 $(q, L, q')$ と表記する.
- $M$ 上の Initial state と Final state 以外の状態 $q$ と $q$ を経由する遷移 $p \to q \to r$ について、以下の規則を適用して $q$ を取り除く.
    - $\lbrace (p, L_1, q), (q, L_2, r) \rbrace$ なら $\lbrace (p, L_1 \cdot L_2, r) \rbrace$ と変換.
    - $\lbrace (p, L_1, q), (q, L_2, r), (q, L_3, q) \rbrace$ なら $\lbrace (p, L_1 \cdot L_3 ^* \cdot L_2, r) \rbrace$ と変換.
- $\lbrace (p, L_1, q), (p, L_2, q) \rbrace$ を $\lbrace (p, L_1 \cup L_2, q)$ と変換.
- これらの変換を Initial state と Final state がそれぞれ一つだけ残るまで繰り返す. これにより構成された $(q_0, L, f)$ の $L$ がこの Finite automaton の accept する Language を表現する Regular language である.

よって、

$$
L _{FA} \subseteq L _{RL}
$$

が成立する.


### Regular Language <=> FA's Language

$L _{RL} \subseteq L _{FA}$ かつ $L _{FA} \subseteq L _{RL}$ より $L _{RL} = L _{FA}$ .  
よって、 Regular language と Finite automaton は対応する.


## Result

以上により、 $L _{RE} = L _{RL} = L _{FA}$ が証明された.

つまり、任意の Regular expression は Finite automaton で表現され、それにより計算可能と証明された.

Kleene algebra と Regular language の理論により、 Regular expression が Finite automaton の理論と結びつき計算可能となった.

この周辺分野には Pumping theorem (ポンピング補題)や、
Finite automaton 以外の Abstract machine などがあるが、 
それは次回にしてそろそろ当初の目的 (Regular expression engine の実装) を終わらせようと思う.

まぁ正直もう実装なんてしなくてもいいんじゃないかとすら思ってる. ;p


# Implementation

任意の Regular expression が Finite automaton で計算可能なことがわかったので、心置きなく実装できる.

Regular expression engine は Regular expression と記号列を入力として、
Regular expression に対応する Finite automaton を構築し、
その Finite automaton を記号列入力を入力テープとして動作させて、
その結果 (accept するかどうか) で Regular expression が記号列にマッチするかどうかを判定する.


## AST

AST の node の Base class と Choice, Concatenation, Kleene star の Node class を定義する.

```common-lisp
(defclass node () ())

(defclass binop (node)
  ((left :initarg :left
         :type node
         :reader node-left)
   (right :initarg :right
          :type node
          :reader node-right)))

(defclass uniop (node)
  ((operand :initarg :operand
            :type node
            :reader node-operand)))

(defclass choice (binop) ())

(defclass concatenation (binop) ())

(defclass kleene-star (uniop) ())
```


## Parser

入力文字列を parse して AST を構築する.

Parser は [Packrat parsing](https://ja.wikipedia.org/wiki/%E3%83%91%E3%83%83%E3%82%AF%E3%83%A9%E3%83%83%E3%83%88%E6%A7%8B%E6%96%87%E8%A7%A3%E6%9E%90) (パックラット構文解析) の Common lisp 実装である [Esrap](http://nikodemus.github.io/esrap/) を利用する.

```common-lisp
(use-package :esrap)

(defrule chracter (not (or "*" "|"))
  (:lambda (char) char))

(defrule choice (and regexp "|" regexp)
  (:destructure (left bar right)
    (declare (ignore bar))
    (make-instance 'choice :left left :right right)))

(defrule concatenation (and regexp regexp)
  (:destructure (left right)
    (make-instance 'concatenation :left left :right right)))

(defrule kleene-star (and regexp "*")
  (:destructure (operand star)
    (declare (ignore star))
    (make-instance 'kleene-star :operand operand)))

(defrule regexp (or kleene-star choice concatenation character))
```


## FA

Finite automaton の Class を定義する.

```common-lisp
(defclass state () ())

(defclass fa ()
  ((initial-state :type state
                  :initarg :inital-state
                  :reader fa-initial-state)
   (final-state-set :type list
                    :initarg :final-state-set
                    :reader fa-final-state-set)
   (transition-function-set :type list
                            :initarg :transition-function-set
                            :reader fa-transition-function-set)))

(defclass transition-function ()
  ((from :type state
         :initarg :from
         :reader transition-function-from)
   (character :type (or character nil)
              :initarg :character
              :reader transition-function-character)
   (to :type state
       :initarg :to
       :reader transition-function-to)))
```

## NFA

AST を元にまずは NFA を構築する.  
Thompson's construction algorithm を使う.  
疲れたから解説はしない. code 読めば分かる.

```common-lisp
(defclass nfa (fa) ())

(defgeneric ast2nfa (node))

(defmethod ast2nfa ((character character))
  (let* ((initial-state (make-instance 'state))
         (final-state (make-instance 'state))
         (final-state-set (list final-state))
         (transition-function (make-instance 'transition-function
                                             :from initial-state
                                             :character character
                                             :to final-state))
         (transition-function-set (list transition-function)))
    (make-instance 'nfa
                   :inital-state initial-state
                   :final-state-set final-state-set
                   :transition-function-set transition-function-set)))

(defmethod ast2nfa ((choice choice))
  (let* ((left (ast2nfa (node-left choice)))
         (right (ast2nfa (node-right choice)))
         (initial-state (make-instance 'state))
         (final-state (make-instance 'state))
         (final-state-set (list final-state))
         (transition-function-set
           (append (fa-transition-function-set left)
                   (fa-transition-function-set right)
                   (mapcar #'(lambda (state)
                               (make-instance 'transition-function
                                              :from initial-state
                                              :character nil
                                              :to state))
                           (mapcar #'fa-initial-state (list left right)))
                   (mapcar #'(lambda (state)
                               (make-instance 'transition-function
                                              :from state
                                              :character nil
                                              :to final-state))
                           (mapcan #'fa-final-state-set (list left right))))))
    (make-instance 'fa
                   :inital-state initial-state
                   :final-state-set final-state-set
                   :transition-function-set transition-function-set)))

(defmethod ast2nfa ((concatenation concatenation))
  (let* ((left (ast2nfa (node-left concatenation)))
         (right (ast2nfa (node-right concatenation)))
         (initial-state (fa-initial-state left))
         (final-state-set (fa-final-state-set right))
         (transition-function-set
           (append (fa-transition-function-set left)
                   (fa-transition-function-set right)
                   (mapcar #'(lambda (state)
                               (make-instance 'transition-function
                                              :from state
                                              :character nil
                                              :to (fa-initial-state right)))
                           (fa-final-state-set left)))))
    (make-instance 'fa
                   :inital-state initial-state
                   :final-state-set final-state-set
                   :transition-function-set transition-function-set)))

(defmethod ast2nfa ((kleene-star kleene-star))
  (let* ((operand (ast2nfa (node-operand kleene-star)))
         (initial-state (make-instance 'state))
         (final-state (make-instance 'state))
         (final-state-set (list final-state))
         (transition-function-set
           (append (list (make-instance 'transition-function
                                        :from initial-state
                                        :character nil
                                        :to final-state)
                         (make-instance 'transition-function
                                        :from initial-state
                                        :character nil
                                        :to (fa-initial-state operand)))
                   (mapcan #'(lambda (state)
                               (list
                                (make-instance 'transition-function
                                               :from state
                                               :character nil
                                               :to final-state)
                                (make-instance 'transition-function
                                               :from state
                                               :character nil
                                               :to (fa-initial-state operand))))
                           (fa-final-state-set operand))
                   (fa-transition-function-set operand))))
    (make-instance 'fa
                   :inital-state initial-state
                   :final-state-set final-state-set
                   :transition-function-set transition-function-set)))
```

## Run

Finite automaton を動作させる.

```
(defun run (nfa string)
  (let ((length (length string))
        (j 0))
    (labels ((accept-p (state)
               (member state (fa-final-state-set nfa)))
             (current-char (i)
               (when (< i length)
                 (elt string i)))
             (reachable-states (state character)
               (mapcar #'transition-function-to
                       (remove-if-not
                        #'(lambda (tf)
                            (and (eq state (transition-function-from tf))
                                 (eql character (transition-function-character tf))))
                        (fa-transition-function-set nfa))))
             (exec (state i)
               (setq j i)
               (when (accept-p state)
                 (return-from run t))
               (when (current-char i)
                 (dolist (state (reachable-states state (current-char i)))
                   (exec state (1+ i))))
               (dolist (state (reachable-states state nil))
                 (exec state i))))
      (exec (fa-initial-state nfa) 0))))
```


## Match

```common-lisp
(defun match (regexp string)
  (run (ast2nfa (parse 'regexp regexp)) string))
```

実際に実行すると、

```common-lisp
(match "a" "a")
=> T

(match "a" "b")
=> NIL

(match "a|bc" "ac")
=> T

(match "a|bc" "bc")
=> T

(match "a|bc" "bd")
=> NIL

(match "a*b" "aaaaab")
=> T

(match "a*b" "aaaaac")
=> T
```

でちゃんとうごいてるっぽい.


# Wrap-up

- Regular expression が Finite automaton で計算可能であることを証明した.
- 実際に NFA でシミュレートを行った.
    - NFA だと計算効率が悪いから大抵の Engine は NFA => DFA に変換している.
    - 変換方法は [NFA => DFA]({{< relref "#nfa-dfa" >}}) で述べたが、実装するならもうちょっと効率的な方法で実装する. ($\epsilon$ 遷移の除去のとことか.)
    - Grouping は実装してない. 読者の宿題とする. ;p
    - Pure regular expression という表現をしたが、 pure かどうかを見分けるのが Pumping theorem により可能となる.
- 今回は Finite automaton を構成する方法で実装するが、他にも Backtracking を利用した方法などがある.


# See Also

- [A Logical Calculus of the Ideas Immanent in Nervous Activity](http://cns-classes.bu.edu/cn550/Readings/mcculloch-pitts-43.pdf)
- [Representation of Events in Nerve Nets and Finite Automata](https://www.rand.org/content/dam/rand/pubs/research_memoranda/2008/RM704.pdf)
- [Finite Automata and Their Decision Problems](http://www.cse.chalmers.se/~coquand/AUTOMATA/rs.pdf)
- [Regular Expression Search Algorithm](http://www.fing.edu.uy/inco/cursos/intropln/material/p419-thompson.pdf)
- [Introduction To Commutative Algebra (Addison-Wesley Series in Mathematics)](http://www.amazon.co.jp/gp/product/0201407515/ref=as_li_ss_tl?ie=UTF8&camp=247&creative=7399&creativeASIN=0201407515&linkCode=as2&tag=rudolph-miller-22)
- [正規表現技術入門 ――最新エンジン実装と理論的背景 (WEB+DB PRESS plus)](http://www.amazon.co.jp/gp/product/4774172707/ref=as_li_ss_tl?ie=UTF8&camp=247&creative=7399&creativeASIN=4774172707&linkCode=as2&tag=rudolph-miller-22)
- [形式言語とオートマトン (Information Science & Engineering)](http://www.amazon.co.jp/gp/product/4781909906/ref=as_li_ss_tl?ie=UTF8&camp=247&creative=7399&creativeASIN=4781909906&linkCode=as2&tag=rudolph-miller-22)
