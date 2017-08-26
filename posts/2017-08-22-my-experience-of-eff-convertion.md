---
title: extensible-effectsの作用を拡大方向に変換する
tags: Haskell
---
# 作用とは
　この記事では`Eff`型の第一型引数を指します。

```haskell
-- Fooは作用
Eff Foo a
```


# 拡大とは
　この記事において、作用`A`が作用`B`より大きいとは

```haskell
type A = X :> Y :> Z
type B = Y :> Z
```

このような`A ⊂ B`を指し、 「拡大」は、

```haskell
Eff B a -> Eff A a
```

のような（`(X :>)`を補填するような）操作を指します。
（一般的になんと言うのかは知らない）


# 問題
　この問題についてのおおよその背景はみょんさんの記事を見た方がとてもわかりやすいと思いますが

- [Notions of Computations and Effects - Just $ A sandbox](http://myuon-myon.hatenablog.com/entry/2017/07/15/200203)

今回の焦点は、extensbile-effectsパッケージにおいてこのような2つの型があった時に

```haskell
type PureComputation   = Eff (Exc () :> Void)
type ImpureComputation = Eff (Exc () :> Lift IO :> Void)
```

作用が小さいものを大きいものに拡大する一般的な関数が提供されていないということです。

　直感的には、純粋な計算（`PureComputation`）というのは不純な計算（`ImpureComputation`）を含んでも問題がない気がします。
（でも、それを実現する、より一般的な方法がexntensible-effectsでは用意されていない）


# 解決（自分で作る）
　なのでこんな関数を定義します。
（Thanks [\@as-capbabl](https://github.com/as-capabl)！）

```haskell
upgrade :: (Functor t, Typeable t) => Eff r a -> Eff (t :> r) a
upgrade = fromView . go . toView
  where
    go (Impure uni) = Impure $ weaken (upgrade <$> uni)
    go (Pure x) = Pure x
```

　こんな感じで使います。

```haskell
{-# LANGUAGE TypeOperators #-}

import Control.Eff (Eff, (:>), run)
import Control.Eff.Exception (Exc, runExc, liftEither)
import Control.Eff.Lift (Lift)
import Control.Monad.Free.Reflection (FreeView(..), fromView, toView)
import Data.OpenUnion (weaken)
import Data.Typeable (Typeable)
import Data.Void (Void)

type PureComputation = Eff (Exc () :> Void)
type ImpureComputation = Eff (Lift IO :> Exc () :> Void)

-- 何らかの純粋な計算
pureCompute :: PureComputation ()
pureCompute = return ()

-- 何らかの不純な計算
impureCompute :: ImpureComputation ()
impureCompute = return ()

-- 不純なものに拡大された純粋な計算
impureCompute' :: ImpureComputation ()
impureCompute' = upgrade pureCompute
```


# 余談
　[extensibleのEffectモジュール](https://hackage.haskell.org/package/extensible-0.4.4/docs/Data-Extensible-Effect.html#v:castEff)
には`castEff :: IncludeAssoc ys xs => Eff xs a -> Eff ys a `という関数が予め用意されています。
