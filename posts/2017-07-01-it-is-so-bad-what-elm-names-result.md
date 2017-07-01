---
title: お前らのResult型はPatternSynonymsでEitherから作れる
tags: haskell
---
　某言語がHaskellの`Either`型（`Left`, `Right`）をオマージュする際に
`Result`型（`Err`, `Ok`）と改名してしまったと聞いたことがあります :cry:

　残念ですがその事実は既に変えられないので、Haskellの`Either`で`Result`を作ります。
`PatternSynonyms`拡張で！！

output
```
Left 10
Right 20
```

Main.hs
```haskell
{-# LANGUAGE PatternSynonyms #-}

import Lib ( Result
           , pattern Err
           , pattern Ok
           )

main :: IO ()
main = do
  print $ (Err 10 :: Result Int Int)
  print $ (Ok 20 :: Result Int Int)
```

Lib.hs
```haskell
{-# LANGUAGE PatternSynonyms #-}

module Lib
  ( Result
  , pattern Err
  , pattern Ok
  ) where

type Result a b = Either a b

pattern Err :: a -> Result a b
pattern Err a = Left a

pattern Ok :: b -> Result a b
pattern Ok b = Right b
```

- - -

　`Err`及び`Ok`は`Left`, `Right`と同じようにパターンマッチングもできます :+1:

　patternシノニムをexportするには、上記Lib.hsのようにpattern prefixを付けてあげます。
importも同じくpattern prefixをつける必要があります。

ちなみにLibを全域importすれば

```haskell
import Lib
```

PatternSynonyms拡張はMain.hsにて必要ありませんが、全域importはむやみに使うのはよくないと思いますので、お願いします :thinking:


# 結
　typeされる型の性質を維持しつつ（別の型として扱わずに）patternを使いたいときに便利
（GeneralizedNewTypeDerivingもnewtypeされる型の性質を維持することができますが、newtypeなので結果が別の型として扱われるます。
それに対して上記の例で提示したデザインは、同一の型として扱われますね :dog2:）


# ちなみに
patternシノニムは型付けできるので、もっと局所的な状況に対応したい時にどうぞ

```haskell
{-# LANGUAGE PatternSynonyms #-}

module Test
  ( Result
  , pattern Err
  , pattern Ok
  ) where

import Data.Text (Text)
import Somewhere (ParseError, AST)

type ParseResult = Either ParseErrorResult AST
type ParseErrorResult = ParseError Text

pattern ParseFailed :: ParseErrorResult -> ParseResult
pattern ParseFailed a = Left a

pattern ParseSucceed :: AST -> ParseResult
pattern ParseSucceed b = Right b
```
