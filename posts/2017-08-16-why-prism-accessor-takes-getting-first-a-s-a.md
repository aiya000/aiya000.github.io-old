---
title: lensの(^?)はなぜGetting (First a) s aを引数に取るのか
tags: Haskell
---
おおよそ

- [Lensの-erは-ingの一般化である（Getter,Setter）](./2017-08-13-lens-er-is-generalizing-of-ing.html)

の続きです。


# 何の話？
　`Lens`には`(^.)`があるように、`Prism`には`(^?)`というものがあって、
`Prism`の性質である`Maybe`が含まれてる以外は、おおよそ役割が同じです。
その役割は取得方向のアクセサです。

　なので`Getting`を受け取るのはそれはそうですが……
僕が最初にこの型と出会った時に思ったのは「なんで`First`？」ということです。

……


# 結論
　`Getting (First a) s a`は`Maybe a`を返せるように、`Prism' s a`に対して十分な特殊化が行われたものだからです。
（`Getting (First a) s a`は`Prism' s a`）


# 改めて、(^?)とは？
　`Prism`のアクセサです。
ちょうど`Lens`の`(^.)`と同じですが、`Prism`なので`Maybe`で結果を返します。

```haskell
(^?) :: s -> Getting (First a) s a -> Maybe a
```

　このようなPrismを作った時に使います。

Test.hs
```haskell
{-# LANGUAGE TemplateHaskell #-}

module Test
  ( Foo(..)
  , _Bar
  , _Baz
  ) where

import Control.Lens (makePrisms)

data Foo = Bar Int
         | Baz Char

makePrisms ''Foo
-- 以下の関数がコンパイル時に定義される
-- _Bar :: (Choice p, Applicative f) => p Int  (f Int)  -> p Foo (f Foo)
-- _Baz :: (Choice p, Applicative f) => p Char (f Char) -> p Foo (f Foo)
```

Main.hs
```haskell
import Test
import Control.Lens ((^?))

x :: Foo
x = Bar 10

y :: Foo
y = Baz 'a'

main :: IO ()
main = do
  print $ x ^? _Bar
  print $ x ^? _Baz
  print $ y ^? _Bar
  print $ y ^? _Baz
```

output
```
Just 10
Nothing
Nothing
Just 'a'
```

　`Prism`はこんな型です。

```haskell
type Prism s t a b = forall p f. (Choice p, Applicative f) => p a (f b) -> p s (f t)
-- _Bar :: (Choice p, Applicative f) => p Int  (f Int)  -> p Foo (f Foo)
-- _Baz :: (Choice p, Applicative f) => p Char (f Char) -> p Foo (f Foo)
```

- [Control.Lens.Type (Prism)](https://www.stackage.org/haddock/lts-8.11/lens-4.15.1/Control-Lens-Type.html#t:Prism)

　しかし`Prism`のアクセサである`(^?)`は、
`Prism s t a b`ではなく`Getting (First a) s a`を要求します。

```haskell
type Getting r s a = (a -> Const r a) -> s -> Const r s
```

- [Control.Lens.Getter (Getting)](https://www.stackage.org/haddock/lts-8.11/lens-4.15.1/Control-Lens-Getter.html#t:Getting)


# 結論
　やはり`Getter`, `Getting`、`Setter`, `Setting`の時と同じで、`Getting (First a) s a`は`Prism s t a b`として一般化できます。

```haskell
type Prism s t a b = forall p f. (Choice p, Applicative f) => p a (f b) -> p s (f t)
type Getting r s a = (a -> Const r a) -> s -> Const r s
```

なぜなら……

- - -

　`(->)`は`Choice`なので`p`に当てはまります。

```haskell
instance Choice (->)
```

- [Control.Lens.Prism (Choice)](https://www.stackage.org/haddock/lts-8.11/lens-4.15.1/Control-Lens-Prism.html#t:Choice)

　`First a`は`Monoid`で、かつ`Const (First r)`は`Applicative`なので、
`Const (First a)`が`f`に当てはまります。

```haskell
instance Monoid (First a)
instance Monoid a => Applicative (Const a)
```

- [Data.Monoid (First)](https://www.stackage.org/haddock/lts-8.11/base-4.9.1.0/Data-Monoid.html#t:First)
- [Control.Lens.Getter (Const)](https://www.stackage.org/haddock/lts-8.11/lens-4.15.1/Control-Lens-Getter.html#t:Const)

（`First a`は`Maybe a`と同型です）

　これを簡約すると

```haskell
Getting (First a) s a = (a -> Const (First a) a) -> s -> Const (First a) s
（Const (First a)を一般化） ==> forall f. Applicative f => (a -> f a) -> s -> f s
（(->)を一般化）            ==> forall p f. (Choice p, Applicative f) => p a (f a) -> p s (f s)
                              = Prism s s a a
                              （s,aを一般化） ==> Prism s t a b
```

となるので、`Prism s t a b`は`Getting (First a) s a`の一般化です。

- - -

　それにより`Getting (First a) s a`は`Prism s s a a`になるので、
`(^?)`はより特殊化された型`Getting (First a) s a`を受け取ります。
（特殊化することにより`Maybe a`を返せるようにしてるはず）

　`Prism s s a a`は`Prism' s a`なので、上述の結論に帰着します。

　1,2ヶ月前にlensを使い始めたときからの疑問だったのですが、わかってしまえば最強ですね。
よっしゃ :dog2:
