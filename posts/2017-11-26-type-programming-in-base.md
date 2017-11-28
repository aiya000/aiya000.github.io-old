---
title: baseパッケージにある型レベルプログラミング探検の旅
tags: Haskell, AdventCalendar2017, AdventCalendar
---
　数学といえば定理証明。
コンピュータといえばHaskell。

ということでHaskellで定理証明（型レベルプログラミング）です！

　この記事は[数学とコンピュータ Advent Calendar 2017](https://qiita.com/advent-calendar/2017/math-and-computer)の、
12月3日の記事です。

# Index

- [始まり](#%E5%A7%8B%E3%81%BE%E3%82%8A)
- [Data.Type.Bool](#datatypebool)
- [Data.Type.Equality](#datatypeequality)
    - [(==)](#equality)
- [GHC.TypeLits](#ghctypelits)
    - [Nat, (+), (-), (\*), (^)](#nat-and-operators)
    - [Symbol](#symbol)
    - [TypeError](#typeerror)
    - [(\<=)](#nat-greater-or-equal)
        - [余談](#%E4%BD%99%E8%AB%87)
- [番外編: (~)](#equality-constraint)
- [終わり](#%E7%B5%82%E3%82%8F%E3%82%8A)
- [参考ページ](#%E5%8F%82%E8%80%83%E3%83%9A%E3%83%BC%E3%82%B8)


# 始まり
　多くのHaskellerは標準モジュールとしてbaseを利用していることかと思いますが、
baseパッケージにはいくつかの、型レベルプログラミングのためのモジュールが存在します。

- [base - Stackage](https://www.stackage.org/lts-9.6/package/base-4.9.1.0)

　面白そうなので、探検していきます。  
皆、定理証明が大好きだもんな！


# Data.Type.Bool <a name='datatypebool'></a>
　ハロー型レベル！

- [Data.Type.Bool - Stackage](https://www.stackage.org/haddock/lts-9.6/base-4.9.1.0/Data-Type-Bool.html)

　皆さん割と型レベルifは書きたくなることが多いと思いますが、
実はbaseに定義されています。
使ってみましょう。

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

import Data.Type.Bool (If, type (&&), type (||), Not)

type X = If (Not 'False && 'False || 'True)
            Int
            Char

x :: X
x = 10

main :: IO ()
main = return ()
```

- [Data.Type.Bool - Stackage](https://www.stackage.org/haddock/lts-9.6/base-4.9.1.0/Data-Type-Bool.html)

　これらは**closed type family**です。

以下のように「条件が正しいかに関わらずコンパイルが通るけど、
条件が正しいかによって変数`x`の型が変わる」
っていうものも作れます。

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

import Data.Type.Bool (If, type (&&), type (||), Not)
import Data.Functor.Const (Const)

type X = If (Not 'False && 'False || 'True)
            (Const Integer Char)
            Int

x :: X
x = 10

main :: IO ()
main = return ()
```

　これは余談ですが、
`instance Num a => Const a b`により`10 :: Const Integer Char`などのような型付けが正しいというのを、
僕が知った時もびっくりしました。  
`Const`すげー。


# Data.Type.Equality <a name='datatypeequality'></a>
## (==) <a name='equality'></a>
　この`type (==)`はカインド多相（`PolyKinds`）なので、
`*`カインドではない型も、以下に実装があれば比較ができます。

- [Data.Type.Equality (==) - Stackage](https://www.stackage.org/haddock/lts-9.6/base-4.9.1.0/Data-Type-Equality.html#t:-61--61-)
    - 例えば以下の種に属する型は、標準的に比較できる
    - `type (==) Bool a b`
    - `type (==) Ordering a b`
    - `type (==) * a b`
    - `type (==) Nat a b`

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

import Data.Type.Equality (type (==))

type X = Int == Char
type Y = Int == Int
type Z = 1 == 2

type A = [Int, Char] == [Int, Bool]
type B = (Int, Char) == (Int, Bool)

main :: IO ()
main = return ()
```

ghci
```haskell
>>> :kind! X
X :: Bool
= 'False

>>> :kind! Y
Y :: Bool
= 'True

>>> :kind! Z
Z :: Bool
= Z

>>> :kind! A
A :: Bool
= 'False

>>> :kind! B
B :: Bool
= 'False
```

　`(==)`は**open type family**なので、自前の型の比較も定義できます。

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

import Data.Type.Equality (type (==))

data Foo = Bar | Baz

type family EqFoo (a :: Foo) (b :: Foo) :: Bool where
  'Bar `EqFoo` 'Bar = 'True
  'Baz `EqFoo` 'Baz = 'True
  a    `EqFoo` a    = 'False

type instance (a :: Foo) == (b :: Foo) = EqFoo a b

type X = 'Bar == 'Bar

main :: IO ()
main = return ()
```

- [Data.Type.Equality - Stackage](https://www.stackage.org/haddock/lts-9.6/base-4.9.1.0/Data-Type-Equality.html)

　あとは色々や色々など、まだまだあります。


# GHC.TypeLits <a name='ghctypelits'></a>
　これは最強です。  
単純な依存型ならばsingletons使わないでこれだけでもいける。

- - -

baseではないので解説は省略しますが、singletonsはここにあります。

- [Data.Singletons - Stackage](https://www.stackage.org/haddock/lts-9.12/singletons-2.2/Data-Singletons.html)

- - -

　GHC.TypeLitsは型レベル自然数（`Nat`カインドとその型）と型レベル文字列（`Symbol`カインドとその型）へのユーティリティを提供します。

- [GHC.TypeLits - Stackage](https://www.stackage.org/haddock/lts-9.6/base-4.9.1.0/GHC-TypeLits.html)

## Nat, (+), (-), (\*), (^) <a name='nat-and-operators'></a>
　`Proxy :: Proxy (1 + 2)`という異常な式が書けます。
`(/)`はないです。
ユークリッドさんはいません！

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

import Data.Proxy (Proxy(..))
import GHC.TypeLits (natVal)
import GHC.TypeLits (type (+), type (-), type (*)) -- ユークリッド感がない

-- natVal :: forall n proxy. KnownNat n => proxy n -> Integer

x :: Integer
x = natVal (Proxy :: Proxy (1 + 2))

main :: IO ()
main = print x
-- {output}
-- 3
```

　自然数モノイドの法則を簡易的に確認とかできます。

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

import Data.Proxy (Proxy(..))
import Data.Type.Bool (type (&&))
import Data.Type.Equality (type (==))
import GHC.TypeLits (type (+))

type MonoidLaws =  0 + 1 == 1 && 1 == 1 + 0
               && (1 + 2) + 3 == 1 + (2 + 3)

x :: MonoidLaws ~ 'True => ()
x = ()

main :: IO ()
main = print x
-- {output}
-- ()
```

`(~) :: k -> k -> Constraint`については、以下を参照。

- [番外編: (~)](#%E7%95%AA%E5%A4%96%E7%B7%A8-)


## Symbol
　`Nat`と同じく、めちゃめちゃ応用性のあるやつ。

```haskell
{-# LANGUAGE DataKinds #-}

import Data.Proxy (Proxy(..))
import GHC.TypeLits (Symbol, symbolVal)

x :: String
x = symbolVal (Proxy :: Proxy "sugar")

main :: IO ()
main = putStrLn x
-- {output}
-- sugar
```

　servantとかが利用してます。

- [haskell-servant の利用例とちょっとだけ仕組みの調査 - KrdLab's blog](http://krdlab.hatenablog.com/entry/2014/12/31/170158)
- [servant - Stackage](https://www.stackage.org/lts-9.14/package/servant-0.11)


## TypeError
　`Monad`ブレイカーの二つ名で知られている（いない）唯一無二の存在、`error`関数の型レベル版です。

　`error`関数は型を無視して例外投げる破壊者ですが、`TypeError`は誤った証明をコンパイルエラーに上げるだけなので、
安全です。

```haskell
>>> :kind! TypeError
TypeError :: ErrorMessage -> b
= (TypeError ...)
```

（`...`は多分 深淵を表していて、僕のような並のHaskellerではたどり着けない魔法がかかっている気がします）

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}

import GHC.TypeLits (TypeError, ErrorMessage(..))

type family Head (xs :: [k]) :: k where
  Head '[] = TypeError ('Text "an empty list is given")
  Head (x ': _) = x

x :: Head '[Int, Char, Bool]
x = 10

main :: IO ()
main = print x
-- {output}
-- 10
```

```haskell
-- 以上省略 --

x :: Head '[] -- TypeError型の呼び出し
x = 10 -- ここが15行目

main :: IO ()
main = print x -- ここが18行目
-- Test.hs:15:5: error:
--     • an empty list is given
--     • In the expression: 10
--       In an equation for ‘x’: x = 10
-- 
-- Test.hs:18:8: error:
--     • an empty list is given
--     • In the expression: print x
--       In an equation for ‘main’: main = print x
```

## (\<=) <a name='nat-greater-or-equal'></a>
　なぜかこれだけ`Constraint`です。
（`(<=) :: (a :: Nat) -> (a :: Nat) -> Constraint`）

多分`Constraint`で等価性調べるなら`(~)`でいいし、
`<`は本質的に`(n - 1) <= m`だからそれでどうぞ、ってことだと思う。

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

import GHC.TypeLits (type (<=))

x :: 2 <= 2 => ()
x = ()

main :: IO ()
main = print x
-- {output}
-- ()
```

```haskell
-- 以上省略 --

x :: 3 <= 2 => ()
x = () -- 

main :: IO ()
main = print x
-- Test.hs:11:14: error:
--     • Couldn't match type ‘'False’ with ‘'True’
--         arising from a use of ‘x’
--     • In the first argument of ‘print’, namely ‘x’
--       In the expression: print x
--       In an equation for ‘main’: main = print x
```

めっちゃ便利そう。

`(<=)`を`Constraint`から型レベルに下げた、`(<=?)`というものあるみたいです。  
あとは

### 余談
　これって`-Woverlapping-patterns`を警告されるだけで、コンパイルは通っちゃうんですね。

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

import GHC.TypeLits (type (<=))

x :: 3 <= 2 => ()
x = ()

main :: IO ()
main = return ()
-- Test.hs:8:1: warning: [-Woverlapping-patterns]
--     Pattern match is redundant
--     In an equation for ‘x’: x = ...
```

- - -

　あとは

- `CmpNat    (m :: Nat)    (n :: Nat)    :: Ordering`
- `CmpSymbol (m :: Symbol) (n :: Symbol) :: Ordering`

とかあります。

- [GHC.TypeLits](https://www.stackage.org/haddock/lts-9.6/base-4.9.1.0/GHC-TypeLits.html)


# 番外編: (~) <a name='equality-constraint'></a>
　`(~)`がどこから来てるのかわからないのでここに書いちゃいますが、
`(~)`はこういうのです。

```haskell
>>> :kind (~)
(~) :: k -> k -> Constraint

>>> () :: 1 ~ 1 => ()
()

>>> () :: 1 ~ 2 => ()

<interactive>:11:1: error:
    • Couldn't match type ‘1’ with ‘2’
        arising from an expression type signature
    • When instantiating ‘it’, initially inferred to have
      this overly-general type:
        1 ~ 2 => ()
      NB: This instantiation can be caused by the monomorphism restriction.

>>> () :: 1 ~ 'True => ()

<interactive>:12:11: error:
    • Expected kind ‘ghc-prim-0.5.0.0:GHC.Types.Nat’,
        but ‘'True’ has kind ‘Bool’
    • In the second argument of ‘~’, namely ‘True’
      In an expression type signature: 1 ~ True => ()
      In the expression: () :: 1 ~ True => ()
```

　`() :: () ~ () => ()`ってすごい面白い式じゃないですか？
任意の式の中でも屈指の面白さだと思います。


# 終わり
　定理証明系Haskellや型レベルプログラミングとかいうと引く人が多いかもしれませんが、
実際問題「型レベルプログラミング実用的ではないのか？」というと、そんなことはないと思います。

例えばextensibleパッケージのここらへんが、いい感じに型レベルプログラミングを行っていると思います。
servantもかな？

- [Data.Extensible.Internal - Stackage](https://www.stackage.org/haddock/lts-9.14/extensible-0.4.6/Data-Extensible-Internal.html)

しかし「コンパイルエラーが難解になる」という問題が（程度によって）あるので、トレードオフです。  
そのパッケージの利便性がそのリスクを上回るのであれば、現実的だと思います。


# 参考ページ

- [haskell/type-level-programming.md at master - lotz84/haskell - GitHub](https://github.com/lotz84/haskell/blob/master/docs/type-level-programming.md)
- [haskell-servant の利用例とちょっとだけ仕組みの調査 - KrdLab's blog](http://krdlab.hatenablog.com/entry/2014/12/31/170158)
