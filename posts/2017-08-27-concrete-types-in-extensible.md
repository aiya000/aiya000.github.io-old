---
title: extensibleのAssociateを使ったEff型を具体型にする
tags: Haskell
---
※ 本記事はextensible-effectsパッケージではなくextensibleパッケージの
`Data.Extensible.Effect`モジュールについての記事です


# 解答
```haskell
context :: ( Associate "greet" (WriterEff [String]) xs
           , Associate "message" (WriterEff [String]) xs
           ) => Eff xs ()
```

　上記の型を具体化すると

```haskell
context :: Eff '["greet" >: WriterEff [String], "message" >: WriterEff [String]] ()
```

という具体型になる。


# Data.Extensible.Effectでの抽象的なEff型
　extensible-effectsではこのような抽象化された`Eff`型で、`Writer`モナド相当の操作ができましたが

```haskell
context :: ( Member (Writer [String]) r
           ) => Eff r ()
context = do
  tell ["hi"]
  tell ["thanks !"]
```

　extensibleパッケージでは、`WriterEff`, `ReaderEff`などの
`Data.Extensible.Effect`での作用を名前付き（`Symbol`付き※1）で管理できるので、
重複した作用を別のものとして扱うことができる。
```haskell
context :: ( Associate "greet" (WriterEff [String]) xs
           , Associate "message" (WriterEff [String]) xs
           ) => Eff xs ()
context = do
  tellEff #greet ["hi"]
  tellEff #message ["extensible, OverloadedLabels, and TypeApplications is great"]
  tellEff #greet ["thanks !"]
-- これらを
-- leaveEff . runWriterEff @ "message" . runWriterEff @ "greet"
-- すると
-- (((),["hi","thanks !"]),["extensible, OverloadedLabels, and TypeApplications is great"])
-- という値が得られる
```

- 参考になる公式記事
    - [extensible: Extensible, efficient, optics-friendly data types and effects](https://hackage.haskell.org/package/extensible-0.4.3)
    - [extensible - School of Haskell | School of Haskell](https://www.schoolofhaskell.com/user/fumieval/extensible)

## ※1
　`String`（`[Char]`）を種に昇格すると`Symbol`になるっぽい？ まだ調べてない。

- [GHC.Types](https://www.stackage.org/haddock/lts-9.1/ghc-prim-0.5.0.0/GHC-Types.html#t:Symbol)


# Data.Extensible.Effectでの具体的なEff型
　上の型

```haskell
context :: ( Associate "greet" (WriterEff [String]) xs
           , Associate "message" (WriterEff [String]) xs
           ) => Eff xs ()
```

を解凍する関数

```haskell
leaveEff . runWriterEff @ "message" . runWriterEff @ "greet"
```

の型をGHCのtyped hole機能で調べてみると

```haskell
(Monoid w, Monoid w1)
=> Eff '["greet" >: WriterEff w, "message" >: WriterEff w1] a
   -> ((a, w), w1)
```

と出る。

　ちょうど我々がそこに当てはめている`Monoid`は`[String]`なので、

```haskell
leaveEff . runWriterEff @ "message" . runWriterEff @ "greet"
:: Eff '["greet" >: WriterEff [String], "message" >: WriterEff [String]] ()
   -> (((), [String]), [String])
```

である。

　なので

```haskell
context :: Eff '["greet" >: WriterEff [String], "message" >: WriterEff [String]] ()
```

である。


# 余談
　`#foo`というのは`OverloadedLabels`拡張の機能で、`@ Bar`というのは`TypeApplications`拡張の機能。
