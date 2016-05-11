+++
Description = "正規表現エンジンの作成."
Tags = ["Common Lisp", "Regexp"]
date = "2016-05-04T22:14:57+09:00"
draft = true
title = "Create Regexp engine"
slug = "create-regexp-engine"
+++

正規表現エンジンの作成.

<!--more-->

以前正規表現エンジンを作成して、
放置している間に作り方を忘れかけていたので備忘録として書いた.


1. [Regexp]({{< relref "#regexp" >}})
2. [NFA]({{<relref "#nfa" >}})
3. [DFA]({{<relref "#dfa" >}})
4. [VM]({{< relref "#vm" >}})


# Regexp

regexp -> AST -> NFA -> minimum NFA -> DFA -> exec
regexp -> AST -> bytecode -> exec via VM


# NFA


# DFA

NFA->DFA


# VM

instrument list
