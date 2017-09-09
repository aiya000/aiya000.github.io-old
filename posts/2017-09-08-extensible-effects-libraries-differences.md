---
title: extensible-effects/extensible/freer-effectsの良いところ悪いところ
tags: Haskell
---
　個人的には`extensible`を使っている。

　性能的には
`extensible` >> `freer-effects` >>>>>> `extensible-effects`
らしい。

- - -

- [freer-effects: Implementation of effect system for Haskell.](https://hackage.haskell.org/package/freer-effects-0.3.0.1)
- [extensible: Extensible, efficient, optics-friendly data types and effects](https://hackage.haskell.org/package/extensible-0.4.4)
    - [Data.Extensible.Effect](https://hackage.haskell.org/package/extensible-0.4.4/docs/Data-Extensible-Effect.html)
- [extensible-effects: An Alternative to Monad Transformers](https://hackage.haskell.org/package/extensible-effects)

　Haskellの拡張可能作用についての上記3つのライブラリで、
同じ内容のコードを示す。


# extensible-effects
　3つのうち最も基本的であって

- 速度が比較的に遅い

ので実用的でないと思われる。

```haskell
extensibleEffects :: ( Member (Reader String) r
                     , Member (Writer [String]) r
                     ) => Eff r ()
extensibleEffects = do
  x <- ask
  tell [x :: String] -- 明示的に型を付けないとxの推論がうまくいかずにコンパイルエラーになる

-- 文脈の単相化が必要な場合がある（extensible-effects）
main = print . EE.run . EE.runWriter (++) [] $ EE.runReader -- Monoidでなくとも、二項関数と単位元を注入してあげればrunWriterできる
    (extensibleEffects :: EE.Eff (EE.Reader String EE.:> EE.Writer [String] EE.:> Void) ()) -- Voidがちょっと冗長
    "poi"

-- {output}
-- (["poi"],())
-- ^ extensible-effectsのrunFooは
--   mtlのrunFooと引数の順序が違う（e.g. runState）。
--   結果も他の3つと順序が違う（runの順序は同じ）。
```


# extensible

- `TypeApplications`と`OverloadedLabels`でガリガリ書く
- 3つのうち一番速いらしい（実測なし）
- （個人的には）`#foo`と`@bar`を書く必要性により、可読性は少し悪くなる気がする
    - [手前味噌だがこのように](https://github.com/aiya000/hs-zuramaru/commit/4b7532582fb1890bd7b8ae9d3f10ba4494f0e569)、  
      関数のexport元で`>:`の右辺左辺を締めることを徹底すれば問題ない
- Symbol種を使う分、コンパイルエラーは難しくなる傾向にある

　ただしそもそもこれは拡張可能作用専用のライブラリではない。
 （なぜか、みょんっと、拡張可能作用のモジュールが生えている）

```haskell
-- Symbol種の型と作用が紐付いてるので
--     ( Associate "x" (WriterEff [String]) xs
--     , Associate "y" (WriterEff [String]) xs
--     , Associate "z" (WriterEff [String]) xs
--     ) => Eff xs a
-- みたいなことが可能
-- （他のでも[String]をnewtypeすれば可能なはずではある）
-- コンパイルエラー
extensible :: ( Associate "poi" (ReaderEff String) xs
              , Associate "huri" (WriterEff [String]) xs
              ) => Eff xs ()
extensible = do
  x <- askEff #poi -- #fooはProxy a型に対するOverloadedLabels拡張の記法
  tellEff #huri [x]

-- @barはTypeApplications拡張の記法
main = print . E.leaveEff . E.runWriterEff @ "huri" $ E.runReaderEff @ "poi"
  (extensible :: E.Eff '["poi" E.:> E.ReaderEff String, "huri" E.:> E.WriterEff [String]] ()) -- 考え方によると、Symbol種を使わなきゃいけなくて冗長？
  "poi"

-- {output}
-- ((),["poi"])
```


# freer-effects

```haskell
-- 使い勝手はだいたいextensible-effectsと同じかなあ
freerEffects :: ( Member (Reader String) r
                , Member (Writer [String]) r
                ) => Eff r ()
freerEffects = do
  x <- ask
  tell [x :: String]

main = print . FE.run . FE.runWriter $ FE.runReader
  (freerEffects :: FE.Eff '[FE.Reader String, FE.Writer [String]] ()) -- extensibleでもこれは必要っぽい
  "poi"

-- {output}
-- ((),["poi"])
```

　extensible-effectsよりも全然速いらしい。

## freer？
　freer-effectsの他にfreerというのもあるけど

    - 2つの内容はほとんど同じっぽくて
    - freerのauthorがfreer-effectsのauthorにもなっていて
    - 最新更新日がfreer-effectsの方が全然新しいので

多分freerは使わなくて良いのではないかと。

　extensibleを使わないならば、extensible-effectsを使わずに
こちらを使った方がいいと思う。

- - -

　以下、コード全文。

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

import Data.Extensible.Effect.Default
import Data.Void (Void)
import qualified Control.Eff as EE
import qualified Control.Eff.Reader.Lazy as EE
import qualified Control.Eff.Writer.Lazy as EE
import qualified Control.Monad.Freer as FE
import qualified Control.Monad.Freer.Reader as FE
import qualified Control.Monad.Freer.Writer as FE
import qualified Data.Extensible as E

extensibleEffects :: ( EE.Member (EE.Reader String) r
                     , EE.Member (EE.Writer [String]) r
                     ) => EE.Eff r ()
extensibleEffects = do
  x <- EE.ask
  EE.tell [x :: String]

extensible :: ( E.Associate "poi" (E.ReaderEff String) xs
              , E.Associate "huri" (E.WriterEff [String]) xs
              ) => E.Eff xs ()
extensible = do
  x <- E.askEff #poi
  E.tellEff #huri [x]

freerEffects :: ( FE.Member (FE.Reader String) r
                , FE.Member (FE.Writer [String]) r
                ) => FE.Eff r ()
freerEffects = do
  x <- FE.ask
  FE.tell [x :: String]

main :: IO ()
main = do
  print . EE.run . EE.runWriter (++) [] $ EE.runReader
    (extensibleEffects :: EE.Eff (EE.Reader String EE.:> EE.Writer [String] EE.:> Void) ())
    "poi"
  print . E.leaveEff . E.runWriterEff @ "huri" $ E.runReaderEff @ "poi"
    (extensible :: E.Eff '["poi" E.:> E.ReaderEff String, "huri" E.:> E.WriterEff [String]] ())
    "poi"
  print . FE.run . FE.runWriter $ FE.runReader
    (freerEffects :: FE.Eff '[FE.Reader String, FE.Writer [String]] ())
    "poi"
```
