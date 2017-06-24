---
title: Haskellのtypeの中身はkind!で！（型レベルハンバーガーの型やいかに？）
tags: Haskell
---
　ここ4日間ぐらい、主に`DataKinds`と`TypeFamilies`を用いた型レベルハンバーガーの開発（型レベルプログラミング）を行っていた。

成果物はここにあるよ。

- [Hamburger.hs](https://github.com/aiya000/learning-Haskell/blob/d4d29ad26673e828bc0b0358d1cde42c295eb50b/Language/Haskell/Extension/Room/Hamburger.hs)
- [Hamburger/TH.hs](https://github.com/aiya000/learning-Haskell/blob/d4d29ad26673e828bc0b0358d1cde42c295eb50b/Language/Haskell/Extension/Room/Hamburger/TH.hs)


# typeした型の中身を表示する:kind!
　Hamberger.hsではこんな感じで、型レベル関数の結果を左辺に格納している。

```haskell
type BasicHamburgerC = HamburgerC Space Space Space Space

type HamburgerC1 = AddTopping BasicHamburgerC Cheese
type HamburgerC2 = AddTopping HamburgerC1 Tomato
type HamburgerC3 = AddTopping HamburgerC2 Meet
type HamburgerC4 = AddTopping HamburgerC3 Ushi
type HamburgerC5 = AddTopping HamburgerC4 Ushi
```

例えば`HamburgerC4`と`HamburgerC5`の結果が見たいとき、
もしこれらが（`Show`である）値であれば`print`してあげればいいものの、これらは型である。

　`type`された型を展開して表示するには、GHCiで`:kind!`を使う。

```haskell
GHCi> :kind! HamburgerC4
HamburgerC4 :: HamburgerT
= 'HamburgerC 'Cheese 'Tomato 'Meet 'Ushi

GHCi> :kind! HamburgerC5
HamburgerC5 :: HamburgerT
= 'Fail
```

　ちなみに`:info`すれば、それらどうやって（値レベルでいう）束縛を行われたのか と
行われた箇所が見れる。

```haskell
GHCi> :info HamburgerC4
type HamburgerC4 = AddTopping HamburgerC3 'Ushi :: HamburgerT
        -- Defined at Hamburger.hs:59:1

GHCi> :info HamburgerC5
type HamburgerC5 = AddTopping HamburgerC4 'Ushi :: HamburgerT
        -- Defined at Hamburger.hs:60:1
```


# 一言
　ここの一連の`type`、よく関数ローカルでいくつかの名前を`let`していくのと似てるよねー。
