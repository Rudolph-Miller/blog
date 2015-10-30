+++
Description = "About Lisp"
Tags = ["Slide", "Tech Talk", "Common Lisp"]
date = "2015-10-29T00:34:45+09:00"
draft = false
slug = "about-lisp"
title = "About Lisp"
+++

layout: true
name: center
class: middle, center

---

layout: true
name: lisp
class: center, middle, lisp

---

# Tech Talk #4

---

# @Rudolph-Miller

---

background-image: url( /images/favicon.png )

---

background-image: url( http://somewrite.com/wp-content/uploads/2015/04/somelogo1.png )

---

# Common Lisper

---

# Lisp??

---

layout: false

.center[
## Search on google (ja)
]

--

background-image: url( /images/20151029/search.png )

---

template: lisp

## 「ＬＩＳＰ」は超至近距離アイドル

---

template: lisp

## 「キミとセツゾク」が合言葉

---

background-image: url( /images/20151029/lisp-idle.jpg )

---

background-image: url( /images/20151029/polnareff.png )

---

background-image: url( /images/20151029/lisp-alien.png )

---

.left-column[
# Lisp
]

--

.right-column[
- 1958
]

--

.right-column[
- John McCarthy
]

--

.right-column[
- Dynamic and strong typing
]

--

.right-column[
- Multiparadigm
]

--

.right-column[
- S-expression and Polish Notation
]

--

.right-column[
- Coherence
]

--

.right-column[
- Code is made up of first-class object
]

--

.right-column[
- The whole language is always available.
]

---

.left-column[
# Lisp
]
.right-column[
.red[
- 1958
]
]
.right-column[
- John McCarthy
]
.right-column[
- Dynamic and strong typing
]
.right-column[
- Multiparadigm
]
.right-column[
- S-expression and Polish Notation
]
.right-column[
- Coherence
]
.right-column[
- Code is made up of first-class object
]
.right-column[
- The whole language is always available.
]

---

template: lisp

# 1958

---

class: bottom, center

background-image: url( /images/20151029/programming-languages.png )

--

### only FORTRAN is older

---

.left-column[
# Lisp
]
.right-column[
- 1958
]
.right-column[
.red[
- John McCarthy
]
]
.right-column[
- Dynamic and strong typing
]
.right-column[
- Multiparadigm
]
.right-column[
- S-expression and Polish Notation
]
.right-column[
- Coherence
]
.right-column[
- Code is made up of first-class object
]
.right-column[
- The whole language is always available.
]

---

template: lisp

# John McCarthy

---

template: center

# the father of AI

---

template: center

# invented Garbage Collection

---

.left-column[
# Lisp
]
.right-column[
- 1958
]
.right-column[
- John McCarthy
]
.right-column[
.red[
- Dynamic and strong typing
]
]
.right-column[
- Multiparadigm
]
.right-column[
- S-expression and Polish Notation
]
.right-column[
- Coherence
]
.right-column[
- Code is made up of first-class object
]
.right-column[
- The whole language is always available.
]

---

layout: false
template: lisp

# Dynamic and strong typing

---

background-image: url( /images/20151029/typing1.png )

---

background-image: url( /images/20151029/typing2.png )

---

.left-column[
# Lisp
]
.right-column[
- 1958
]
.right-column[
- John McCarthy
]
.right-column[
- Dynamic and strong typing
]
.right-column[
.red[
- Multiparadigm
]
]
.right-column[
- S-expression and Polish Notation
]
.right-column[
- Coherence
]
.right-column[
- Code is made up of first-class object
]
.right-column[
- The whole language is always available.
]

---

template: lisp

# Multiparadigm

---

template: center

--

# Imperative

--

# Object-oriented

--

# Functional

---

.left-column[
# Lisp
]
.right-column[
- 1958
]
.right-column[
- John McCarthy
]
.right-column[
- Dynamic and strong typing
]
.right-column[
- Multiparadigm
]
.right-column[
.red[
- S-expression and Polish Notation
]
]
.right-column[
- Coherence
]
.right-column[
- Code is made up of first-class object
]
.right-column[
- The whole language is always available.
]

---

template: lisp

# S-expression and Polish Notation

---

template: center

## .red[L]ots of .red[I]rritating .red[S]uperfluous .red[P]arentheses

---

background-image: url( /images/20151029/lisp-keyboard.jpg )

---

template: lisp

## S-expression is AST.

---

layout: true
template: center

---

```ruby
1 + 3 * 2
```

---

background-image: url( /images/20151029/ast.png )

---

```lisp
(+ 1 (* 3 2))
```

---

## Wait!

---

## AST is for program,
## not for human.

---

## We are human,
## and think in natural language.

---

## Really??

---

## When you think of algorithm,
## do you really think in natural language ?

---

template: lisp

# No.

---

template: lisp

# In the more abstract
## like tree or graph.

---

template: lisp

## S-expression is
## the more appropriate method.

---

.left[
```bnf
<S-exp> ::= <List> | <Atom> 
<List>  ::= (<S-exp>*) 
<Atom>  ::= <Symbol> | <Number>
```

```lisp
(defun add1 (num1 num2)
  (+ num1 num2))

(add1 (add1 1 2) 3)
;; => 6

(reduce #'add1 (list 1 2 3))
;; => 6

(defun add2 (&rest args)
  (reduce #'add args))

(add2 1 2 3)
;; => 6
```
]

---

layout: false

.left-column[
# Lisp
]
.right-column[
- 1958
]
.right-column[
- John McCarthy
]
.right-column[
- Dynamic and strong typing
]
.right-column[
- Multiparadigm
]
.right-column[
- S-expression and Polish Notation
]
.right-column[
.red[
- Coherence
]
]
.right-column[
- Code is made up of first-class object
]
.right-column[
- The whole language is always available.
]

---

template: lisp

# Coherence

---

template: lisp

## No difference between Statement and Expression.

---

template: center

.left[
```lisp
(defun sample (bool)
  (if (if (null bool) false true)
    (print true)
    (print false)))
```
]

---

.left-column[
# Lisp
]
.right-column[
- 1958
]
.right-column[
- John McCarthy
]
.right-column[
- Dynamic and strong typing
]
.right-column[
- Multiparadigm
]
.right-column[
- S-expression and Polish Notation
]
.right-column[
- Coherence
]
.right-column[
.red[
- Code is made up of first-class object
]
]
.right-column[
- The whole language is always available.
]

---

template: lisp

# Code is made up of first-class object

---

template: center

.left[
```lisp
;; Code
(defun add1 (num1 num2)
  (+ num1 num2))

;; Data
(list 'defun 'add1 (list 'num1 num2)
  (list '+ 'num1 'num2))

'(defun add1 (num1 num2)
  (+ num1 num2))

;; REPL
(eval
 '(defun add1 (num1 num2)
    (+ num1 num2)))
```
]

---

.left-column[
# Lisp
]
.right-column[
- 1958
]
.right-column[
- John McCarthy
]
.right-column[
- Dynamic and strong typing
]
.right-column[
- Multiparadigm
]
.right-column[
- S-expression and Polish Notation
]
.right-column[
- Coherence
]
.right-column[
- Code is made up of first-class object
]
.right-column[
.red[
- The whole language is always available.
]
]

---

template: lisp

# The whole language is always available.

---

template: lisp

## You can compile or run code while reading, read or run code while compiling, and read or compile code at runtime.
quoted from "[What Made Lisp Different](http://www.paulgraham.com/diff.html)" by Paul Graham

---

layout: true
template: center

---

.left[
```lisp
;; run code while reading
(defun char-code-a-p (int)
  (= int #.(char-code #\a)))

(defun char-code-a-p (int)
  (= int 97))
```
]

---

.left[
```lisp
;; run code while compiling
(defun include-p-1 (string char)
  (when (find char string) t))

(defmacro include-p-2 (string char)
  (let ((hash (make-hash-table)))
    (loop for c across string
      (setf (gethash c hash) t))
    `(gethash ,char ,hash)))

(defun time-of-include-p-1 ()
  (time (loop repeat 10000000 do (include-p-1 "sample" #\a))))

(defun time-of-include-p-2 ()
  (time (loop repeat 10000000 do (include-p-2 "sample" #\a))))

(time-of-include-p-1)
;; 0.495 seconds of real time
;; 1,336,787,055 processor cycles

(time-of-include-p-2)
;; 0.003 seconds of real time
;; 8,880,960 processor cycles
```
]

---

.left[
```lisp
;; compile code at runtime
(defun define-add-some (some)
  (eval
   `(defun add-some (int)
      (+ int ,some))))

(define-add-some 10)
;; add-some

(add-some 2)
;; => 12
```
]

---

layout: true
template: lisp

---

# Finally,

---

# Why Lisp?? Why S-expression??

---

# Because,

---

# Simple and Coherence.

---

# No Translation.

---

# No Limitation.

---

# Simple and Coherence.
# No Translation.
# No Limitation.

---

### and...

---

# God wrote in Lisp code
# Every creature great and small.
quoted from [Eternal Flame](http://www.gnu.org/fun/jokes/eternal-flame.html)

---

# Think in Lisp,
# Think as Transcendence.

---

# Human is freed from
# all the limitations.

---

### so...

---

# Lisp is, S-expression is
# a method of salvation.

---

background-image: url( /images/20151029/the_end.jpg )
