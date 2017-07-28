---
title: typeで型引数をつけるか付けないかで変わる意味がある（instance編）
tags: Haskell
---

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

- - -

　完全に余談だけど、こうなるとMineにkind signature付けたくなるよね :dog2:  
できるのかな？

```haskell
type Mine :: * -> * = Eff (Fail :> Void)
```
