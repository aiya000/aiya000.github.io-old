---
title: yiテキストエディタのインストール方法
tags: Haskell
---
　一応、メモっておく。

`haskell-stack`はインストールされているものとする。

```sh
$ git clone https://github.com/yi-editor/yi yi
$ cd yi
$ LANG=C STACK_YAML=lts-6.yaml stack setup
$ LANG=C STACK_YAML=lts-6.yaml stack build
$ LANG=C STACK_YAML=lts-6.yaml stack install
```

$LANG, $STACK_YAMLを外すと、Gtk2Hs関連のエラーが出る。
