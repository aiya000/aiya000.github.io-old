---
title: Haskell（GHC）のSymbol/Natカインドの型を値に落とす方法
tags: Haskell
---
　Haskell（GHC）では以下のように、文字列を型として埋め込むことができます。

```haskell
{-# LANGUAGE DataKinds #-}

type Str = "sugar"

main :: IO ()
main = return ()
```

　こうすれば値`"sugar" :: String`を取得できます。

```haskell
{-# LANGUAGE DataKinds #-}

import Data.Proxy (Proxy(..))
import GHC.TypeLits (Symbol, symbolVal)

type Str = "sugar"

main :: IO ()
main = putStrLn $ symbolVal (Proxy :: Proxy Str)
-- {output}
-- sugar
```


# Nat
　Nat（自然数カインド）も同じことができるよ。

```haskell
{-# LANGUAGE DataKinds #-}

import Data.Proxy (Proxy(..))
import GHC.TypeLits (Nat, natVal)

main :: IO ()
main = print $ natVal (Proxy :: Proxy 10)
-- {output}
-- 10
```


# 参考

- [GHC.TypeLits (KnownSymbol)](https://www.stackage.org/haddock/lts-9.6/base-4.9.1.0/GHC-TypeLits.html#t:KnownSymbol)
