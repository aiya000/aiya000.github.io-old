---
title: PreludeのfailはMonadFailのfailではない
tags: Haskell
---
# 困ったこと
　僕はよく失敗表現の型を`MonadFail`インスタンスにして、`fail`を使って失敗を抽象化するなどをするんだけど、
それに対するテストで`fail`を使うと、何故かそのインスタンスの`fail`が呼ばれず、`IO`例外が送出されることがある。

Test.hs （テスト用のコード） vv
```haskell
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Test
  ( ExceptionCause
  , Result (..)
  ) where

import Control.Monad.Fail (MonadFail(..))

type ExceptionCause = String

newtype Result a = Result
  { unResult :: Either ExceptionCause a
  } deriving (Show, Eq, Functor, Applicative, Monad)

instance MonadFail Result where
  fail = Result . Left
```

Main.hs （テスト） vv
```haskell
import Test (Result(..))


-- tasty-discover用の命名
test_it_is_pure :: Bool
test_it_is_pure = pureFail "x(" == negativeContext "x("
  where
    -- Expected behavior
    pureFail :: String -> Result ()
    pureFail = Result . Left

    -- An alias of `Result`'s fail
    negativeContext :: String -> Result ()
    negativeContext = fail -- （！！）


main :: IO ()
main = print test_it_is_pure
```

　このテストは通らない。
（以下の出力になる）

```console
$ stack runghc Main.hs Test.hs
Main.hs: x(
```


# Control.Monad.Failのfailを明示的にimportする
　これは`negativeContext`で`Prelude`の`fail`を呼んでしまっていることに起因する。

```haskell
Prelude.fail            :: Monad     m => String -> m a
Control.Monad.Fail.fail :: MonadFail m => String -> m a
```

　テストを修正する。

Main.hs
```haskell
import Control.Monad.Fail (fail)
import Prelude hiding (fail)
import Test (Result(..))


-- tasty-discover用の命名
test_it_is_pure :: Bool
test_it_is_pure = pureFail "x(" == negativeContext "x("
  where
    -- Expected behavior
    pureFail :: String -> Result ()
    pureFail = Result . Left

    -- An alias of `Result`'s fail
    negativeContext :: String -> Result ()
    negativeContext = fail -- （！！）


main :: IO ()
main = print test_it_is_pure
```

出力
```console
$ stack runghc Main.hs Test.hs
True
```

ひどい話だ。
