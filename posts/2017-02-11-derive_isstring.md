---
title: Text(ByteString)をnewtypeした型でもOverloadedStringsできるよ。
tags: Haskell
---
`GeneralizedNewtypeDeriving`拡張を使う。

```haskell
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.String (IsString)
import Data.Text (Text)

newtype A = A Text deriving (IsString, Show)

a :: A
a = "ahoge"  -- 文字列リテラル of A

main :: IO ()
main = print a
```
