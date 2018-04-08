---
title: yiテキストエディタのインストール方法
tags: Haskell
---
　`haskell-stack`はインストールされているものとする :dog2:

```shell-session
$ git clone https://github.com/yi-editor/yi yi
$ cd yi/yi
$ LANG=C stack setup
$ LANG=C stack build
$ LANG=C stack install
```

`$LANG`を外すと、cairoパッケージあたり？ でGtk2Hs関連のエラーが出る。

```
--  While building custom Setup.hs for package cairo-0.13.3.1 using:
      /tmp/stack16474/cairo-0.13.3.1/.stack-work/dist/x86_64-linux-tinfo6-nopie/Cabal-1.24.2.0/setup/setup-to-file"
    Process exited with code: ExitFailure 1
    Logs have been written to: /home/aiya000/Repository/yi...

    [1 of 2] Compiling Main             ( ...
    [2 of 2] Compiling StackSetupShim   ( ...
    Linking /tmp/stack16474/cairo-0.13.3.1/.stack-work/dist/x86_64-linux-tinfo6-nopie/Cabal-1.24.2.0/setup
    Configuring cairo-0.13.3.1...
    Building cairo-0.13.3.1...
    Preprocessing library cairo-0.13.3.1...
    setup: Error in C header file.

    ./cairo-gtk2hs.h:1: (column 0) [FATAL]
      >>> Lexical error!
      The character '#' does not fit here.


--  While building custom Setup.hs for package glib-0.13.4.1 using:
      /tmp/stack16474/glib-0.13.4.1/.stack-work/dist/x86_64-linux-tinfo6-nopie/Cabal-1.24.2.0/setup/setup-to-file"
    Process exited with code: ExitFailure 1
    Logs have been written to: /home/aiya000/Repository/yi...

    [1 of 2] Compiling Main             ( ...
    [2 of 2] Compiling StackSetupShim   ( ...
    Linking /tmp/stack16474/glib-0.13.4.1/.stack-work/dist/x86_64-linux-tinfo6-nopie/Cabal-1.24.2.0/setup/...
    Configuring glib-0.13.4.1...
    Building glib-0.13.4.1...
    Preprocessing library glib-0.13.4.1...
    setup: Error in C header file.

    /usr/include/glib-2.0/glib-object.h:1: (column 0) [FATAL]
      >>> Lexical error!
      The character '#' does not fit here.
```

（今回は[yi-editor/yi](https://github.com/yi-editor/yi)を`yi-config/yi-origin`ディレクトリにクローンしてある）

　手元の都合に応じて`STACK_YAML=lts-6.yaml`などを指定してあげると、対応したstackageのltsバージョンでビルドできる。
指定しなければ`yi/yi/stack.yaml`の内容でビルドされる。

```shell-session
$ ls yi/yi/lts-*
yi/yi/lts-6.yaml  yi/yi/lts-7.yaml
```
