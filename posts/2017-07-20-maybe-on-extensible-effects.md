---
title: extensible-effectsのEffでMaybeを使う（Failを使う）
tags: Haskell
---
　extensible-effectsには`Fail`という型（作用）があるので、そちらを使うのが一番楽かと思います :dog2:

- [Control.Eff.Exception](https://www.stackage.org/haddock/lts-8.11/extensible-effects-1.11.0.4/Control-Eff-Exception.html)

```haskell
newtype Exc e v = Exc e
type Fail = Exc ()
```

```haskell
{-# LANGUAGE FlexibleContexts #-}

import Control.Eff (Member, Eff, run)
import Control.Eff.Exception(Fail, runFail, liftMaybe)

safeHeadEff :: Member Fail r => [a] -> Eff r a
safeHeadEff [] = liftMaybe Nothing
safeHeadEff (x:_) = return x


main :: IO ()
main = do
  let x = run . runFail $ safeHeadEff [1..10]
  print x
```

ちなみに`liftMaybeM`という関数をextensible-effectsにPRしました（マージされた）

- [Add liftMaybeM to Control.Eff.Exception by aiya000 - Pull Request #68 - suhailshergill/extensible-effects - GitHub](https://github.com/suhailshergill/extensible-effects/pull/68)
