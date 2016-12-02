+++
Description = "Roswell & Slimv の環境構築の備忘録"
Tags = ["Common Lisp", "Roswell", "Slimv"]
date = "2016-12-02T22:47:58+09:00"
draft = false
images = ["/20161202/slimv.png"]
slug = "roswell-and-slimv"
title = "[備忘録] Roswell & Slimv の環境構築"
+++

Roswell & Slimv の環境構築の備忘録.  
(備忘録なので初心者への配慮などはしていない.)

<!--more-->

{{% image "/20161202/slimv.png" %}}


1. [Roswell]({{< relref "#roswell" >}})
2. [Slimv]({{< relref "#slimv" >}})
3. [Usage]({{< relref "#usage" >}})


# Roswell

## Install

- Roswell を Homebrew で install する.

    ```sh
    $ brew install roswell
    ```

## Install the lastest version of SBCL

- 最新版の SBCL を Roswell で install する.

    ```sh
    $ ros install sbcl
    ```


# Slimv

(NeoBundleを使っている想定.)

## Install

- Slimv を NeoBundle で install する.

    ```vim
    NeoBundle 'https://github.com/kovisoft/slimv'
    ```

    を `~/.vimrc` に足し、`:NeoBundleInstall` を実行.


## Setup with Roswell

- Slimv が Roswell の SBCL を実行するように設定.

    ```vim
    let g:slimv_lisp = 'ros run'
    let g:silmv_impl = 'sbcl'
    ```

    を `~/.vimrc` に足す.


## Swank server via VimShell

- VimShell (と VimShell が依存している vimproc) を NeoBundle で install する.

    ```vim
    NeoBundle 'Shougo/vimproc.vim', {
          \ 'build' : {
          \     'windows' : 'tools\\update-dll-mingw',
          \     'cygwin' : 'make -f make_cygwin.mak',
          \     'mac' : 'make -f make_mac.mak',
          \     'linux' : 'make',
          \     'unix' : 'gmake',
          \    },
          \ }
    NeoBundle 'Shougo/vimshell'
    ```

    を `~/.vimrc` に足し、 `:NeoBundleInstall` を実行.

- VimShell で Swank server を簡単に立ち上げられるよう alias を作成.

    ```vimscript
    nnoremap <silent> ,cl :VimShellInteractive ros -s swank -e '(swank:create-server :port 4005 :dont-close t)' wait<CR>
    ```

    を `~/.vimrc` に足す.


# Usage

- Vim を立ち上げる.

    ```sh
    $ vim sample.lisp
    ```

    {{% image "/20161202/image_01.png" %}}

- 適当なS式を入力する.


    ```common-lisp
    (defun hello ()
      (print "Hello, World!"))
    ```

    {{% image "/20161202/image_02.png" %}}

- `,cl` で Swank server を VimShell で立ち上げる.

    {{% image "/20161202/image_03.png" %}}

- VimShell の Window は閉じて、元のファイルの Window の末尾で `,e` でS式の評価をすると、先ほど立ち上げた Swank server に繋がった REPL が別の Window で立ち上がりS式の評価結果が表示される.

    {{% image "/20161202/image_04.png" %}}

- REPL の Window にてS式を評価する.

    {{% image "/20161202/image_05.png" %}}
