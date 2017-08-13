---
title: Lensの-erは-ingの一般化である（Getter,Setter）
tags: Haskell
---
　最近lensの各型を調べていて、その理解のうちの1つの関門となったのが、
`Lens`型のうち`Getting`と`Getter`、`Setting`と`Setter`の関係だった。

定義をHackageで眺めていたらふと、その2つの**-er**が**-ing**の一般化になっていることに気づいた。

なぜ一般化されているのかはまだわかってない :confused:

このあたりはどこかの論文を読めば書いてあることなのかもしれないけど、僕は論文を読んでいない……。


# GetterはGettingの一般化
　まずは定義をば。

```haskell
type Getting r s a = (a -> Const r a) -> s -> Const r s
type Getter s a = forall f. (Contravariant f, Functor f) => (a -> f a) -> s -> f s
```

- [Control.Lens.Getter (Getter)](https://www.stackage.org/haddock/lts-8.11/lens-4.15.1/Control-Lens-Getter.html#t:Getter)
- [Control.Lens.Getter (Getting)](https://www.stackage.org/haddock/lts-8.11/lens-4.15.1/Control-Lens-Getter.html#t:Getting)

　`Getting`が`Getter`の`f`を（`r`を外に逃して）`Const r`に固定した型になっている。

```haskell
(簡略) Getting :: (a -> Const r a) -> s -> Const r s
(簡略) Getter  :: (a -> f       a) -> s -> f       s
```

　`Const r`は`Contravariant`Functor `Functor`なので、`f`に当てはまる。

```haskell
instance Contravariant (Const a)
instance Functor (Const a)
```

- [Control.Lens.Getter (Contravariant)](https://www.stackage.org/haddock/lts-8.11/lens-4.15.1/Control-Lens-Getter.html#t:Contravariant)
- [Control.Comonad (Functor)](https://www.stackage.org/haddock/lts-8.11/comonad-5/Control-Comonad.html#t:Functor)

ということは`Getter`は`Getting`の一般化である。


# SetterはSettingの一般化
　定義はこのようになっている。

```haskell
type Setting p s t a b = p a (Identity b) -> s -> Identity t
type Setter s t a b = forall f. Settable f => (a -> f b) -> s -> f t
```

`Setting`は`Getting`と1つだけ違って、`(->)`が`p`に一般化されている。
`p`を`(->)`に特殊化すると、`Getting`の`Const r`を`Identity`に置き換えた型になる。

```haskell
type Setting p s t a b = p    a (Identity b) -> s -> Identity t
(特殊化)             ==> (->) a (Identity b) -> s -> Identity t
(簡約)               ==> (a ->   Identity b) -> s -> Identity t
```

　Settableはこのようになっているので

```haskell
class (Applicative f, Distributive f, Traversable f) => Settable f where
  untainted :: f a -> a
  untaintedDot :: Profunctor p => p a (f b) -> p a b
  taintedDot :: Profunctor p => p a b -> p a (f b)
```

`Settable`は`Applicative` `Distributive` `Traversable` (functor) だと解釈できる。

```haskell
type Setter s t a b = forall f. (Applicative f, Distributive f, Traversable f) => (a -> f b) -> s -> f t
```

　`(->)`は`p`で、

```haskell
data (->) :: * -> * -> *
```

`Identity`は`Applicative` `Distributive` `Traversable`なので

```haskell
instance Applicative Identity
instance Distributive Identity
instance Traversable Identity
```

- [Control.Applicative (Applicative)](https://www.stackage.org/haddock/lts-8.11/base-4.9.1.0/Control-Applicative.html#t:Applicative)
- [Data.Distributive (Distributive)](https://www.stackage.org/haddock/lts-8.11/distributive-0.5.2/Data-Distributive.html#t:Distributive)
- [Control.Lens.Traversal (Traversable)](https://www.stackage.org/haddock/lts-8.11/lens-4.15.1/Control-Lens-Traversal.html#t:Traversable)

`Setter`は`Setting`の一般化である。


# 追伸
　ここのドキュメントコメントが、なぜ**-ing**を**-er**に一般化するのかのヒントになるかもしれない。

- [Control.Lens.Internal.Setter (Settable)](https://www.stackage.org/haddock/lts-8.11/lens-4.15.1/Control-Lens-Internal-Setter.html#t:Settable)

> Anything Settable must be isomorphic to the Identity Functor.

訳) あらゆる`Settable`は`Identity` Functorと同型でなければいけない。

この「同型」は圏論的意味だと思う。
