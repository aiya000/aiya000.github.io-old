---
title: IdrisとHaskellの差異「依存型のパターンマッチが可能」
tags: Idris, Haskell
---
　Idrisに入門中なので、せっかくだからHaskellではできなかったけどIdrisではできること、
またその逆を定期的に挙げていきたいと思います :dog2:

以下のとこには載ってないものを挙げてくつもりです！

- [Idris for Haskellers - idris-lang/Idris-dev Wiki - GitHub](https://github.com/idris-lang/Idris-dev/wiki/Idris-for-Haskellers)

　初回なので、少し前提知識の補填が入るのはご容赦を。
ここでの主題はあくまで「依存型のパターンマッチが可能」というところです。

# Index

- [Idrisでは依存型のパターンマッチができる](#idris%E3%81%A7%E3%81%AF%E4%BE%9D%E5%AD%98%E5%9E%8B%E3%81%AE%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B3%E3%83%9E%E3%83%83%E3%83%81%E3%81%8C%E3%81%A7%E3%81%8D%E3%82%8B)
    - [コード全文](#%E3%82%B3%E3%83%BC%E3%83%89%E5%85%A8%E6%96%87)
    - [Haskellで書くなら](#haskell%E3%81%A7%E6%9B%B8%E3%81%8F%E3%81%AA%E3%82%89)
- [余談: 使用した諸機能の説明](#%E4%BD%99%E8%AB%87-%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%9F%E8%AB%B8%E6%A9%9F%E8%83%BD%E3%81%AE%E8%AA%AC%E6%98%8E)
    - [printLn/print](#printlnprint)
    - [Vect n a](#vect-n-a)
    - [Idrisでの自然数（Nat）は0も含む](#idris%E3%81%A7%E3%81%AE%E8%87%AA%E7%84%B6%E6%95%B0nat%E3%81%AF0%E3%82%82%E5%90%AB%E3%82%80)
    - [リストリテラル中の..記法はVectでは使えないみたい](#dotdot-in-vect)
- [IdrisではGHCのGADTs拡張相当がデフォルトで使える](#idris%E3%81%A7%E3%81%AFghc%E3%81%AEgadts%E6%8B%A1%E5%BC%B5%E7%9B%B8%E5%BD%93%E3%81%8C%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88%E3%81%A7%E4%BD%BF%E3%81%88%E3%82%8B)


# Idrisでは依存型のパターンマッチができる
　コードを見てもらえれば、感覚がわかると思う。
`Vect`型については後述。

```idris
length' : Vect n a -> Nat
length' {n = val} _ = val
```

`{n = val}`というのが依存型`n`のパターンマッチである。
`n`には例えば`Vect 5 Int`のように自然数値が入る。

その後の`_`は`Vect n a`値が束縛されるが、既に必要ないのでアンダースコアによって破棄される。

この`val`はパターンなので、例えば以下のようなマッチングもかけることができる。

（`Z : Type`と`S : Nat -> Type`は`Nat`型の値。`Z`は`0`、`S Z`は`1`を表す）

```idris
length' : Vect n a -> Nat
length' {n = Z}   _  = 0
length' {n = S _} xs = 1 + length' (tail xs)
```

## コード全文

```idris
import Data.Vect

xs : Vect 5 Int
xs = [1,2,3,4,5]

length' : Vect n a -> Nat
length' {n = val} _ = val

--length' : Vect n a -> Nat
--length' {n = Z}   _  = 0
--length' {n = S _} xs = 1 + length' (tail xs)

main : IO ()
main = printLn $ length' xs
-- {output}
-- 5
```

## Haskellで書くなら

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}

import Data.Proxy (Proxy(..))
import GHC.TypeLits

data Vect (n :: Nat) a :: * where
  Nil :: Vect 0 a
  (:::) :: a -> Vect n a -> Vect (n + 1) a

infixr 7 :::

xs :: Vect 5 Int
xs = 1 ::: 2 ::: 3 ::: 4 ::: 5 ::: Nil

-- HaskellではNatが値を持たないのでIntを使う
length' :: forall n a. KnownNat n => Vect n a -> Int
length' _ = fromInteger $ natVal (Proxy :: Proxy n)

main :: IO ()
main = print $ length' xs
-- {output}
-- 5
```


# 余談: 使用した諸機能の説明
　以上で使用した諸機能について補足をします。

## `printLn`/`print`
　Haskellでの`print`は`printLn`に該当する。
Idrisの`print`は改行を出力しない。


## `Vect n a`
　`Vect`型はその長さを型パラメータ`n`に持つ`a`のリストである。
例えば以下は長さ5を持つ。

```idris
xs : Vect 5 Int
xs = [1,2,3,4,5]
```

　`Vect`の簡略的定義はこんな感じ

```idris
data Vect : Nat -> a -> Type where
  Nil : Vect 0 a
  (::) : x -> Vect n a -> Vect (S n) a

infixl 7 ::
```

- 実定義は[IdrisDoc: Data.Vect](https://www.idris-lang.org/docs/current/base_doc/docs/Data.Vect.html#Data.Vect.Vect)

　また`Type`型はHaskellで言う`*`種である。

Idrisでは値と型の区別がなく、つまり種（型の型）も値で表現できるので、
「ある自然数と要素の型を受け取り、その型を返す」
という表現は`Nat -> a -> Type`になる。

## **Idrisでの自然数（`Nat`）は`0`も含む**
　やはりプログラミングでは`0`を含んだ方が、自然数がぐーーーんと使いやすい。

## リストリテラル中の`..`記法は`Vect`では使えないみたい <a name="dotdot-in-vect"></a>

```idris
xs : Vect 5 Int
xs = [1..5]
```

```
| xs = [1..5]
|      ~~~~~~
When checking right hand side of xs with expected type
        Vect 5 Int

Type mismatch between
        List a (Type of enumFromTo _ _)
and
        Vect 5 Int (Expected type)
```
（expected type `Vect 5 Int` but got `List a` と言っている）

## IdrisではGHCの`GADTs`拡張相当がデフォルトで使える
　上記、`Vect`の簡略定義の通り。

もちろん普通の代数的データ型もこんな感じに書ける。

```idris
data Mine = My String
```
