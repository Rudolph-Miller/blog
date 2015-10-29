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

layout: false

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

## Lots of Irritating Superfluous Parentheses

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

template: lisp

## You can compile or run code while reading, read or run code while compiling, and read or compile code at runtime.
quated from "[What Made Lisp Different](http://www.paulgraham.com/diff.html)" by Paul Graham

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

template: lisp

## The whole language always available.

---

template: lisp

# What is S-expression for us??

---

template: lisp

## Need not think of how to express thought,
## just express thought.

---

template: lisp

# S-expression is a method of salvation.
