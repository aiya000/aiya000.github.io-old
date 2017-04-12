---
title: haskell-stackでcan't load .so/.DLL for 〜/libncurses.soが出た場合の対処
tags: Haskell
---
# 対処
　ワークアラウンドを施します。

```console
$ cd /usr/lib
$ sudo cp libncurses.so{,.bak}
$ sudo ln -s libncursesw.so.6.0 libncurses.so
```


# 参考
- [Linker error with &#39;stack ghci&#39; · Issue #440 · commercialhaskell/stack · GitHub](https://github.com/commercialhaskell/stack/issues/440)
