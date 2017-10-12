---
title: NonEmptyのIsListインスタンスの損なわせる型健全性
tags: Haskell
---
# 結論
　`OverloadedLists`で`NonEmpty`を具体化しない方が良い。


# 概要
In haskell-jp slack

> igrep [18:25]  
> `OverloadedLists`, 意外と怖いですね。うっかりNonEmptyに対して空リストを使ってしまうとランタイムエラーになっちゃうみたいで。。。
> ```
> >>> :set -XOverloadedLists
> >>> import qualified Data.List.NonEmpty as NE
> >>> [] :: NonEmpty Int
> *** Exception: NonEmpty.fromList: empty list
> >>> [] :: [Int]
> []
> ```
> 理論的にはコンパイル時に `fromList` を実行してコンパイルエラーにできそうなもんですし、惜しい。

- [GHC.Exts - IsList](https://www.stackage.org/haddock/lts-9.2/base-4.9.1.0/GHC-Exts.html#t:IsList)

　`OverloadedLists`拡張は`OverloadedStrings`拡張と似た構造をしていて、
型`Set`, `Map`, そして`NonEmpty`

　例えば以下のコードはコンパイルを通り、実行時エラーになる。

```haskell
{-# LANGUAGE OverloadedLists #-}

import Data.List.NonEmpty (NonEmpty(..))

f :: NonEmpty Int -> Int
f (x:|_) = x + 1

main :: IO ()
main = print $ f []
-- {output}
-- xxx.hs: NonEmpty.fromList: empty list
```

　igrepさんが言っている通り、`NonEmpty`の`fromList`が悪い（部分関数になっている）。

- [Data/List/NonEmpty.hs](https://www.stackage.org/haddock/lts-9.2/base-4.9.1.0/src/Data-List-NonEmpty.html#fromList)

- - -

　個人的には、`IsList`インスタンスにしないで欲しい。
誘惑に負けてしまう。
