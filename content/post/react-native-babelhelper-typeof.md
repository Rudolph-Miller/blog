+++
Description = "`babelHelper.typeof is not a function` の原因と回避."
Tags = ["React", "React Native"]
date = "2016-09-23T09:45:19+09:00"
draft = true
images = []
title = "React Native - babelHelper.typeof is not a function"
+++

`babelHelper.typeof is not a function` の原因と回避.

<!--more-->

- babel-preset-es2015でtypeofをbabelHelper.typeofにtransform
    - その中のどのtransformerかを w/ line でlink.
- React Nativeは独自のpolifillをもってる.
    - w/ GitHub link
- 回避策
