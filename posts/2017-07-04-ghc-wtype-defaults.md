---
title: GHCの-Wtype-defaultsを解決するにはちゃんと型付けするしかないかなあ
tags: Haskell
---
Test.hs
```haskell
main :: IO ()
main = print 10
```

このコードを`-Wtype-defaults`付きでコンパイルすると、以下の警告が出る。
（`-Wtype-defaults`はGHC-8.0.2ではデフォルトで無効）

```console
$ stack runghc -- -Wtype-defaults Test.hs

Test.hs:2:8: warning: [-Wtype-defaults]
    • Defaulting the following constraints to type ‘Integer’
        (Show a0) arising from a use of ‘print’ at Test.hs:2:8-15
        (Num a0) arising from the literal ‘10’ at Test.hs:2:14-15
    • In the expression: print 10
      In an equation for ‘main’: main = print 10
10
```

10が型推論で`(Num a, Show a) => a`に推論されているからだ。
GHCは10を最終的に単相型で型付けする必要がある……はずなので、デフォルトの`Integer`として型付けされていて、
このままだとパフォーマンスに影響が出る。（`Integer`より`Int`のが速い）

型を付けて解決する。

Test.hs
```haskell
main :: IO ()
main = print (10 :: Int)
```

他にいい解決方法ないの？


# 参考ページ
- [6.2. Warnings and sanity-checking &#8212; Glasgow Haskell Compiler &lt;release&gt; User&#39;s Guide](https://downloads.haskell.org/~ghc/master/users-guide/using-warnings.html)
