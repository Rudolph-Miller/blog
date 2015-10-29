+++
Description = "About Lisp"
Tags = ["Slide","Tech Talk","Common Lisp"]
date = "2015-10-25T06:20:19+09:00"
draft = true
title = "About lisp"
slug = "about-lisp"
+++

name: lisp
layout: true
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

## 「ＬＩＳＰ」は超至近距離アイドル

---

## 「キミとセツゾク」が合言葉

---

layout: false

background-image: url( /images/20151029/lisp-idle.jpg )

---

template: lisp

# ???

---

background-image: url( /images/20151029/lisp-alien.png )

---

.left-column[
# Lisp
]

--

.right-column[
- 1958年
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
- Code is made up of first-class object
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

template: lisp

# John McCarthy

---

class: middle, center
layout: true

---

# the father of AI

---

# invented Garbage Collection

---

layout: false
template: lisp

# Dynamic and strong typing

---

background-image: url( /images/20151029/typing.png )

---

template: lisp

# Multiparadigm

---

# Imperative
# Object-oriented
# Functional

---

template: lisp

# S-expression and Polish Notation

---

background-image: url( /images/20151029/lisp-keyboard.jpg )

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

template: lisp

# Code is made up of first-class object

---

template: lisp

### You can compile or run code while reading, read or run code while compiling, and read or compile code at runtime.
