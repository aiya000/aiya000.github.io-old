---
title: 数値をnewtypeした型の値として数値リテラルを使う
tags: Haskell
---
　`Num`型クラスに対して`GeneralizedNewtypeDeriving`拡張を使うことができるので、
例えば`Int`のnewtypeを作りたいけど、いちいち値コンストラクタを経るのが面倒だ
という心配をする必要はない。

　貴方が想像している面倒さはこのようなものだ。

```haskell
newtype Seconds = Seconds
  { unSeconds :: Int
  } deriving (Show, Eq)

incrementSeconds :: Seconds -> Seconds
incrementSeconds (Seconds x) = Seconds $ x + 1

main :: IO ()
main = do
  let seconds = Seconds 10
  print $ incrementSeconds seconds
  print . Seconds . abs . negate $ unSeconds seconds
-- {output}
-- Seconds {unSeconds = 11}
-- Seconds {unSeconds = 10}
```

　`GeneralizedNewtypeDeriving`拡張を使うことで、`Seconds`に`(+1)`や`(-1)`, `(*2)`したり、
`negate`して`abs`したりすることができる。

```haskell
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

newtype Seconds = Seconds
  { unSeconds :: Int
  } deriving (Num, Show, Eq)

incrementSeconds :: Seconds -> Seconds
incrementSeconds = (+1)

main :: IO ()
main = do
  let seconds = 10
  print $ incrementSeconds seconds
  print . abs $ negate seconds
-- {output}
-- Seconds {unSeconds = 11}
-- Seconds {unSeconds = 10}
```
