---
title: 型レベルハンバーガーについての報告
tags: Haskell
---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- index
    - [これは私的な近況報告です](#%E3%81%93%E3%82%8C%E3%81%AF%E7%A7%81%E7%9A%84%E3%81%AA%E8%BF%91%E6%B3%81%E5%A0%B1%E5%91%8A%E3%81%A7%E3%81%99)
    - [解説](#%E8%A7%A3%E8%AA%AC)
        - [型レベルハンバーガーの目的、主題](#%E5%9E%8B%E3%83%AC%E3%83%99%E3%83%AB%E3%83%8F%E3%83%B3%E3%83%90%E3%83%BC%E3%82%AC%E3%83%BC%E3%81%AE%E7%9B%AE%E7%9A%84%E4%B8%BB%E9%A1%8C)
        - [型レベルハンバーガーの見どころ](#%E5%9E%8B%E3%83%AC%E3%83%99%E3%83%AB%E3%83%8F%E3%83%B3%E3%83%90%E3%83%BC%E3%82%AC%E3%83%BC%E3%81%AE%E8%A6%8B%E3%81%A9%E3%81%93%E3%82%8D)
        - [型レベルハンバーガーへのToppingの追加](#%E5%9E%8B%E3%83%AC%E3%83%99%E3%83%AB%E3%83%8F%E3%83%B3%E3%83%90%E3%83%BC%E3%82%AC%E3%83%BC%E3%81%B8%E3%81%AEtopping%E3%81%AE%E8%BF%BD%E5%8A%A0)
        - [型レベルプログラミングを解決するためにTemplateHaskellを使うのは1回 回った感がある（TH.hsについて）](#th.hs)
        - [値レベルハンバーガー](#%E5%80%A4%E3%83%AC%E3%83%99%E3%83%AB%E3%83%8F%E3%83%B3%E3%83%90%E3%83%BC%E3%82%AC%E3%83%BC)
        - [ということで](#%E3%81%A8%E3%81%84%E3%81%86%E3%81%93%E3%81%A8%E3%81%A7)
    - [元ネタ](#%E5%85%83%E3%83%8D%E3%82%BF)
    - [参考](#%E5%8F%82%E8%80%83)
    - [Special Thanks !](#special-thanks-)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# これは私的な近況報告です
　ここ4日くらいは型レベルプログラミングの体験をしていました！  
その成果物である、型レベルハンバーガーはHamburger.hs及びHamburger/TH.hsから成ります。

<!-- 出力結果 {{{ -->

出力結果

```console
SHamburger (Space Space Space Space)
SHamburger (Cheese Space Space Space)
SHamburger (Cheese Tomato Space Space)
SHamburger (Cheese Tomato Meet Space)
SHamburger (Cheese Tomato Meet Ushi)
```

<!-- }}} -->

<!-- Hamburger.hs {{{ -->

- [Hamburger.hs](https://github.com/aiya000/learning-Haskell/blob/d4d29ad26673e828bc0b0358d1cde42c295eb50b/Language/Haskell/Extension/Room/Hamburger.hs)

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Hamberger where

import Hamburger.TH (defineInstances)

-- | A kind of the topping, and types.
data Topping = Space -- ^ Mean a space, it can be inserted some @Topping@
             | Cheese | Tomato | Meet | Ushi

-- |
-- A type level function
-- that maps @HamburgerT@ and @Topping@ to @HamburgerT@.
--
-- If @HamburgerC a b c d@ :: @HamburgerT@ of the domain has no space, or @Fail@ is specified to the domain,
-- return @Fail@ type.
type family AddTopping (h :: HamburgerT) (t :: Topping) :: HamburgerT where
  AddTopping (HamburgerC Space b c d) t = HamburgerC t b c d
  AddTopping (HamburgerC a Space c d) t = HamburgerC a t c d
  AddTopping (HamburgerC a b Space d) t = HamburgerC a b t d
  AddTopping (HamburgerC a b c Space) t = HamburgerC a b c t
  AddTopping _ _ = Fail

-- | A kind of the abstract hamburger
data HamburgerT = HamburgerC Topping Topping Topping Topping -- ^ A type constructor of the abstract hamburger
                | Fail -- ^ Mean a fail of a mapping of @AddTopping@


{- The dependent type -}

-- |
-- A concrete of the hamburger
-- (A type constructor for a type of @HamburgerT@ kind).
data SHamburger (h :: HamburgerT) where
  Concrete :: STopping -> STopping -> STopping -> STopping -> SHamburger (HamburgerC a b c d :: HamburgerT)

-- | A singleton type for @Topping@ kind.
data STopping = SSpace | SCheese | STomato | SMeet | SUshi
  deriving (Show)

-- | Represent the simply dependent type
class Singleton (h :: HamburgerT) where
  sing :: SHamburger h


-- Define any instances for 126 patterns !
defineInstances


type BasicHamburgerC = HamburgerC Space Space Space Space

type HamburgerC1 = AddTopping BasicHamburgerC Cheese -- these kind is @HamburgerT@
type HamburgerC2 = AddTopping HamburgerC1 Tomato
type HamburgerC3 = AddTopping HamburgerC2 Meet
type HamburgerC4 = AddTopping HamburgerC3 Ushi
type HamburgerC5 = AddTopping HamburgerC4 Ushi -- = Fail

x0 = sing :: SHamburger BasicHamburgerC
x1 = sing :: SHamburger HamburgerC1
x2 = sing :: SHamburger HamburgerC2
x3 = sing :: SHamburger HamburgerC3
x4 = sing :: SHamburger HamburgerC4
--x5 = sing :: SHamburger HamburgerC5 -- This is the compile error because Refl is not a Fail's value


main :: IO ()
main = do
  print x0
  print x1
  print x2
  print x3
  print x4
```

<!-- }}} -->

<!-- Hamburger/TH.hs {{{ -->

- [Hamburger/TH.hs](https://github.com/aiya000/learning-Haskell/blob/d4d29ad26673e828bc0b0358d1cde42c295eb50b/Language/Haskell/Extension/Room/Hamburger/TH.hs)

```haskell
{-# LANGUAGE TemplateHaskell #-}

module Hamburger.TH where

import Language.Haskell.TH (Type(..), Name, mkName, Exp(..), DecsQ, Dec(..), Clause(..), Pat(..), Body(..), Lit(..))

type TypeName = String

type Topping4 = (TypeName, TypeName, TypeName, TypeName)


topping4s :: [Topping4]
topping4s = [(w, x, y, z) | w <- toppings, x <- toppings, y <- toppings, z <- toppings]
  where
    toppings :: [TypeName]
    toppings = ["Space", "Cheese", "Tomato", "Meet", "Ushi"]

-- | Make a AST of @Type@ is like "(HamburgerC Space Cheese Tomato Meet)"
hamburgerC :: Topping4 -> Type
hamburgerC (w, x, y, z) = ParensT (ConT (mkName "HamburgerC") 
                            `AppT` ConT (mkName w)
                            `AppT` ConT (mkName x)
                            `AppT` ConT (mkName y)
                            `AppT` ConT (mkName z))

-- |
-- Make a AST of @Exp@ is like "Concrete SSpace SCheese STomato SMeet"
-- (@Topping4@ elements are added "S" prefix for @STopping@).
concrete :: Topping4 -> Exp
concrete (w, x, y, z) = ConE (mkName "Concrete")
                 `AppE` ConE (mkName $ "S" ++ w)
                 `AppE` ConE (mkName $ "S" ++ x)
                 `AppE` ConE (mkName $ "S" ++ y)
                 `AppE` ConE (mkName $ "S" ++ z)


-- | Define @Singleton@ instances and @Show@ instances for any pattern of @topping4@
defineInstances :: DecsQ
defineInstances = do
  let singletonInstances = map defineSingletonInstance topping4s
      showInstances      = map defineShowInstance topping4s
  return $ singletonInstances ++ showInstances
  where
    defineSingletonInstance :: Topping4 -> Dec
    defineSingletonInstance t4@(w, x, y, z) =
      InstanceD Nothing []
        (ConT (mkName "Singleton") `AppT` hamburgerC t4)
        [
          FunD (mkName "sing") [Clause [] (NormalB $ concrete t4) []]
        ]

    defineShowInstance :: Topping4 -> Dec
    defineShowInstance t4@(w, x, y, z) =
      InstanceD Nothing []
        (ConT (mkName "Show") `AppT` ParensT (ConT (mkName "SHamburger") `AppT` hamburgerC t4))
        [
          FunD (mkName "show") [Clause [WildP] (NormalB $
              (LitE . StringL $ "SHamburger (" ++ w ++ " " ++ x ++ " " ++ y ++ " " ++ z ++ ")")
          ) []]
        ]
```

<!-- }}} -->


# 解説

## 型レベルハンバーガーの目的、主題
　型レベルハンバーガーは

1. 5つ以上のトッピングを追加されると、例外ではなくコンパイルエラーで失敗を報告します
2. 失敗していない有効なハンバーガーは、値として取得できます

というのが目的（主題）です。
（2つ目のやつは後付け）

詳細にはこんな感じ。

1. 5つ以上の`Topping`を追加されると（`x5`を介して）コンパイルエラーになります
2. `Topping`の追加はTypeFamiliesの型関数`AddTopping`によって追加されます
3. `Topping`の追加は種`HamburgerT`の型`Hamburger a b c d`に対して行われます
    - `type family AddTopping (h :: HamburgerT) (t :: Topping) :: HamburgerT`
    - （擬似的には`HamburgerT -> Topping -> HamburgerT`）
4. 種`HamburgerT`を持つ型のうち有効なもの（つまり`Fail`以外）は値レベルに降格できます
    - 備考: 依存型って、値から型への昇格を扱うだけのものじゃなかったんだね


## 型レベルハンバーガーの見どころ
　これの見どころ（こだわりどころ）は、Hamburger.hsのトップレベルにある`x5`をコンパイルしようとすると、コンパイルエラーになるところです。  
それは、`x5`の型である`SHamburger HambergerC5`が`SHamburger Fail`であり
（※[:kind!](/posts/2017-06-24-ghci-type-level-debug.html)）
`Fail`はHamburger.hsに定義されている型クラス`Singleton`のインスタンスではないからです。
（`sing`関数は`Singleton`の関数）

　以下の型の`Singleton`インスタンスは

- `SHamburger BasicHamburgerC`
- `SHamburger HamburgerC1`
- `SHamburger HamburgerC2`
- `SHamburger HamburgerC3`
- `SHamburger HamburgerC4`

TemplateHaskellによってHamburger.hsのトップレベルで展開される`defineInstances`によって定義されます。
`defineInstances`はTH.hsによって提供されているメタ関数です。


## 型レベルハンバーガーへのToppingの追加
```haskell
type family AddTopping (h :: HamburgerT) (t :: Topping) :: HamburgerT where
  AddTopping (HamburgerC Space b c d) t = HamburgerC t b c d
  AddTopping (HamburgerC a Space c d) t = HamburgerC a t c d
  AddTopping (HamburgerC a b Space d) t = HamburgerC a b t d
  AddTopping (HamburgerC a b c Space) t = HamburgerC a b c t
  AddTopping _ _ = Fail
```

　このパターンそのまんまですね、TypeFamiliesです。


## 型レベルプログラミングを解決するためにTemplateHaskellを使うのは1回 回った感がある（TH.hsについて）
　TH.hsにある`defineInstances`は`SHamburger (HamburgerC a b c d :: HamburgerT)`の形をした126個の型の`Singleton`インスタンスを生成します。
（つまり`SHamburger (h :: HamburgerT)`のうち`Fail`以外に対する）

　`Singleton`は依存型（もどき？）を扱うためのものです。

　[参考にしたページ](http://konn-san.com/prog/2013-advent-calendar.html)では自然数の帰納法を使ってインスタンスを実装してましたが、
依存型を使うことを考える前に考えた構造が全然帰納的でなかったので、TemplateHaskellを使って力技で解決しました。
（誰かうまい方法を教えてください！）


## 値レベルハンバーガー
```haskell
data SHamburger (h :: HamburgerT) where
  Concrete :: STopping -> STopping -> STopping -> STopping -> SHamburger (HamburgerC a b c d :: HamburgerT)

data STopping = SSpace | SCheese | STomato | SMeet | SUshi
  deriving (Show)
```

　各`Singleton`インスタンス実装は`defineInstances`が行うので具体的なコードはありませんが、このようなものになります。

```haskell
instance Singleton (HamburgerC Cheese Ushi Meet Space) where
  sing = Concrete SCheese SUshi SMeet SSpace
```

　Haskellでは依存型は実際には使えないらしいので、インスタンスになる型と`sing`（の具体値）はこのような一対一対応になります。

```
型レベル: HamburgerC Cheese Ushi Meet Space
値レベル: Concrete SCheese SUshi SMeet SSpace
```

`HamburgerC`に`Cheese Ushi Meet Space`が指定されれば、その値は`Concrete`と`SCheese SUshi SMeet SSpace`に限り  
その逆もまた同じく限る感じです。

一意的ってことですね。


## ということで
　進捗報告はこんな感じでした :dog2:


# 元ネタ
<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">@ U科各位<br><br>Java課題ソースコード<a href="https://t.co/NOUtZAxB44">https://t.co/NOUtZAxB44</a></p>&mdash; 焼きそばメロンパン@🍣 (@ice_arr) <a href="https://twitter.com/ice_arr/status/876673209575251968">2017年6月19日</a></blockquote><script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

# 参考
- [定理証明系 Haskell - konn-san.com](http://konn-san.com/prog/2013-advent-calendar.html)

# Special Thanks !

- [Type Level Humberger by Hexirp · Pull Request #1 · aiya000/learning-Haskell · GitHub](https://github.com/aiya000/learning-Haskell/pull/1)
    - and Haskell-jp members !

- 僕がTemplateHaskellによって何個のインスタンスを生成したのかをRubyインタプリタで調べてくれたぶらっきぃくん
