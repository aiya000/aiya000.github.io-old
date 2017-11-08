---
title: Haskell（GHC）のimport/module構文に表れるのtypeキーワードについて（ExplicitNamespaces）
tags: Haskell
---
　例によるGHC Haskellの中の概念の紹介記事。

- - -

　GHCのHaskellでは（おそらく主に）`DataKinds`拡張を用いる場合にて、以下のように
`import`/`module`構文内で`type`キーワードが表れる場合がある。

Main.hs
```haskell
{-# LANGUAGE ExplicitNamespaces #-}

import Test (type (==>))

main :: IO ()
main = return ()
```

Test.hs
```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Test
  ( type (==>)
  ) where

type family (x :: Bool) ==> (y :: Bool) :: Bool where
  False ==> _     = True
  True  ==> False = False
  True  ==> True  = True
```

　これは厳密には`ExplicitNamespaces`拡張によって提供されている構文で、Main.hsとTest.hsを以下のように
改変した場合にわかりやすい。

Main.hs
```haskell
{-# LANGUAGE ExplicitNamespaces #-}

import Test (type (==>), (==>))

main :: IO ()
main = print $ False ==> True
```

Test.hs
```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Test
  ( type (==>)
  , (==>)
  ) where

type family (x :: Bool) ==> (y :: Bool) :: Bool where
  False ==> _     = True
  True  ==> False = False
  True  ==> True  = True

(==>) :: Bool -> Bool -> Bool
False ==> _     = True
True  ==> False = False
True  ==> True  = True
```

　つまるところ、Main.hsで`type family`の型演算子`==>`をimportときに`type`キーワードが必要になる。
具体的には、以下はコンパイルエラーになる。

Main.hs
```haskell
{-# LANGUAGE ExplicitNamespaces #-}

import Test ((==>))

main :: IO ()
main = return ()
```

Test.hs
```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Test
  ( (==>)
  ) where

type family (x :: Bool) ==> (y :: Bool) :: Bool where
  False ==> _     = True
  True  ==> False = False
  True  ==> True  = True
```

コンパイルエラー
```
Test.hs:8:5: error:
    Not in scope: ‘==>’
    Perhaps you meant ‘==’ (imported from Prelude)
```

```
Main.hs:3:14: error: Module ‘Test’ does not export ‘(==>)’
```

# 参考

- [10.1. Language options — Glasgow Haskell Compiler 8.3.20171025 User's Guide (ExplicitNamespaces)](https://downloads.haskell.org/~ghc/master/users-guide/glasgow_exts.html#extension-ExplicitNamespaces)
