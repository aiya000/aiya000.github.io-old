---
title: typeでは型引数を省略しないと高階型クラスインスタンスにできない
tags: Haskell
---

```haskell
class Foo (a :: * -> *)
```

　のように、高階型に実装されることを要求する型クラスに対して

```haskell
data Bar a = Bar Int a
type Baz a b = Either (Bar a) b
```

のようにすると

```haskell
class Foo (Baz a)
```

できなくなってしまって

```haskell
type Baz a = Either (Bar a)
```

のようにするとできるという感じです。

- - -

```haskell
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeSynonymInstances #-}

import Control.Eff (Eff, (:>))
import Control.Eff.Exception (Fail, throwExc)
import Control.Monad.Fail (MonadFail(..))
import Data.Void (Void)
import Prelude hiding (fail)

-- `a`をつけると
type Mine a = Eff (Fail :> Void) a

-- compile error !
instance MonadFail Mine where
  fail _ = throwExc ()

main :: IO ()
main = return ()
```

```
Test.hs|13 col 10| error:
     • The type synonym ‘Mine’ should have 1 argument, but has been given none
     • In the instance declaration for ‘MonadFail Mine’
```

`Mine`の型引数`a`を消してみるとコンパイルが通る。

```haskell
type Mine = Eff (Fail :> Void)
```

つまりモナドスタックのような構造のうち部分は、このような
