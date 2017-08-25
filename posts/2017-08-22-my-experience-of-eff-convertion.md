---
title: extensible-effectsの作用を拡大してみた（※）
tags: Haskell
---

# ※ ← ？
　`Union r -> Union (w :> r)`や`Free f -> Free g`相当の変換ができなかったので、
もしそれが可能であればこの方法は妥当ではないかなあと思います。の意。


# 作用 ← ？
　この記事では`Eff`型の第一型引数を指します。


```haskell
-- Fooは作用
Eff Foo a
```


# 拡大 ← ？
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

- - -
- - -

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
（でも、それを実現する、より一般的な方法が用意されていない）

```haskell
-- こんな関数が欲しいけどない
upgrade :: Eff r a -> Eff (w :> r) a
upgrade :: PureComputation a -> ImpureComputation a
```


# 解決（自分で作る）
　~~なので、一般的なものではないですが、より特殊的なものを自分で作って解決してみました。~~

-- 2017-08-25 追記  
　[\@as-capbabl](https://github.com/as-capabl)さんがもっといいものを作ってくれたので、差し替えました！

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

-- 目的の関数
upgrade :: (Functor t, Typeable t) => Eff r a -> Eff (t :> r) a
upgrade = fromView . go . toView
  where
    go (Impure uni) = Impure $ weaken (upgrade <$> uni)
    go (Pure x) = Pure x
--upgrade :: PureComputation a -> ImpureComputation a
--upgrade = runExc >>> run >>> liftEither


-- 不純なものに拡大された純粋な計算
impureCompute' :: ImpureComputation ()
impureCompute' = upgrade pureCompute
```
