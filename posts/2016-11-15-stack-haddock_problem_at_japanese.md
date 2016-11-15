---
title: 日本語環境のLANGでstack haddockができないやつの解決
tags: Haskell
---
　haskell-stackを使って`stack haddock`を実行すると、`Foo.hs: invalid byte sequence`みたいなエラーが出ることがある。

# 解決方法
LANGをen_US.UTF-8にする。

```console
$ LANG=en_US.UTF-8 stack haddock
```

# 参考ページ
["invalid argument" error with `stack haddock` and Nixpkgs #2452](https://github.com/commercialhaskell/stack/issues/2452)
