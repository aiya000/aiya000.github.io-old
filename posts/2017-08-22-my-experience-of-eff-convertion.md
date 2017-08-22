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
　なので、一般的なものではないですが、より特殊的なものを自分で作って解決してみました。

```haskell
{-# LANGUAGE TypeOperators #-}

import Control.Eff (Eff, (:>), run) import Control.Eff.Exception (Exc, runExc, liftEither)
import Control.Eff.Lift (Lift)
import Data.Void (Void)

type PureComputation = Eff (Exc () :> Void)
type ImpureComputation = Eff (Exc () :> Lift IO :> Void)

-- 何らかの純粋な計算
pureCompute :: PureComputation ()
pureCompute = return ()

-- 何らかの不純な計算
impureCompute :: ImpureComputation ()
impureCompute = return ()

-- より特殊的だけど、目的の関数
specialUpgrade :: PureComputation a -> ImpureComputation a
specialUpgrade = runExc >>> run >>> liftEither

-- 不純なものに拡大された純粋な計算
impureCompute' :: ImpureComputation ()
impureCompute' = specialUpgrade pureCompute
```

　もう一例。

```haskell
{-# LANGUAGE TypeOperators #-}

import Control.Eff (Eff, (:>), run)
import Control.Eff.Exception (Exc)
import Control.Eff.Writer.Lazy (Writer, runWriter)
import Data.Void (Void)

type MyEff = Eff (Exc String :> Writer Int :> Void)
type YourEff = Eff (Writer Int :> Void)

mine :: MyEff ()
mine = return ()

yours :: YourEff ()
yours = return ()

itIsMine :: YourEff a -> MyEff a
itIsMine = return . snd . run . runWriter (+) 0

mine' :: MyEff ()
mine' = itIsMine yours
```

- - -
- - -

　以下はぼやきです。


# これは、より推奨できる解決方法なのか？
　これが、より推奨できる方法なのかがわかりません。

　なぜならより一般的な関数`Eff r a -> Eff (w :> r) a`は作れていないのと

```haskell
-- 作れなかった！
upgrade :: Eff r a -> Eff (w :> r) a
```

**※←？**に書いたことなのですが、直接`Free`とその中の`Union`に対する変換が書けていないからです。

```haskell
-- EffはFreeとUnionで出来ている
type Eff r = Free (Union r)
type PureComputation = Free (Union (Exc () :> Void))
type ImpureComputation = Free (Union (Exc () :> Lift IO :> Void))

specialUpgrade :: Free (Union (Exc () :> Void)) a -> Free (Union (Exc () :> Lift IO :> Void)) a
specialUpgrade =
{- 一度Effを完全に -} run            -- :: Eff Void (Either () a) -> Either () a
{-   解除してから  -} >>> runExc     -- :: Eff (Exc () :> Void) a -> Eff Void (Either () a)
{- 一気にaに -}       >>> liftEither -- :: Either () a -> Eff (Exc () :> Lift IO :> Void) a
{- ImpureComputationを被せている -}
```

　本当は

```haskell
Free (Union r) a -> (forall b. Union r b -> Union (w :> r) b) -> Free (Union (w :> r)) a
```

のような関数に

```haskell
Union (Exc () :> Void) b -> Union (Exc () :> Lift IO :> Void) b
```

のような関数を適用してあげた方がいいのではないかと考えていて、
でも`Union r`が`Traversable`でなかった関係で、
僕では作れませんでした xD

（できるというのなら誰か教えて！）
