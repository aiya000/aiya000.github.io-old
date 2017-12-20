---
title: にこ、希と一緒に学ぶHaskell（番外）「あまり知られていないGHC拡張の紹介」
tags: ラブライブ！で学ぶ, にこ、希と一緒に学ぶHaskell, Haskell, AdventCalendar2017, AdventCalendar
---
　この記事は[Haskell (その3) Advent Calendar 2017](https://qiita.com/advent-calendar/2017/haskell3)の
21日目の記事です！

　この記事にはSS表現、ラブライブが含まれます。
これらが苦手な方はブラウザバックを推奨します。

- - -

- [記事一覧 - ことり、穂乃果と一緒に学ぶHaskell（入門）](/tags/ことり、穂乃果と一緒に学ぶHaskell.html)
- [記事一覧 - にこ、希と一緒に学ぶHaskell（番外）](/tags/にこ、希と一緒に学ぶHaskell.html)
- [更新履歴 - μ'sと一緒に学ぶHaskell](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)

# Outline

- [MultiParamTypeClasses](#multiparamtypeclasses)
- [ConstrainedClassMethods](#constrainedclassmethods)
- [RebindableSyntax](#rebindablesyntax)
    - [NoImplicitPrelude（補足）](#noimplicitprelude%E8%A3%9C%E8%B6%B3)
- [InstanceSigs](#instancesigs)
- [ImpredicativeTypes](#impredicativetypes)
- [ExplicitNamespaces](#explicitnamespaces)
- [参考ページ](#%E5%8F%82%E8%80%83%E3%83%9A%E3%83%BC%E3%82%B8)


# 前回の型ライブ！
放課後、部室に集まって、よく知られたGHC拡張について語り合う
にこっち と うち。

希「GHC拡張っていっぱいあるんやね！」  
にこ「Haskell reportに『実験的な機能を取り入れた、この言語の拡張や 変形の出現はのぞむところである。』って書いてあるくらいだしね」  

調べれば調べるほど出てくるGHC拡張に対して、改めて全能感を感じる。  
でも、Haskellの力はまだまだこんなもんやない。

そんな充実感を抱きながらお風呂から上がると、うちのGoogleHangoutに、謎のビデオ電話がかかってきた！


# にこののぞみ
希「はい、もしもし」  
にこ「こんばんは、希」  
希「にこっちやん。どうしたの？」  

にこ「そのね、今日は珍しくママ……じゃなくてっ！」  

にこ「お母さんが早く帰ってきてて、チビたちの面倒を見てくれてるから暇なんだけど、
Haskellのリモート勉強会しない？
……なんて。」  
希「おっ、ええやん！
うちも実は、今ひまやったんよ」  

にこ「そ、そう！
じゃ、じゃあ……
放課後だけじゃあんまり語り尽くせなかったし、
またGHC拡張について話さない？」  

希「いいね！
実はさっき面白いページ見つけてな。
知らないGHC拡張がいっぱいあったんよ。
これ見ていくの、どうやろ？」  

- [面白いページ -> 言語拡張 - shiatsumat/wiwinwlh-jp Wiki - GitHub](https://github.com/shiatsumat/wiwinwlh-jp/wiki/%E8%A8%80%E8%AA%9E%E6%8B%A1%E5%BC%B5)

にこ「ええ、いいわねっ」  


# MultiParamTypeClasses
希「さっき見つけたのが面白いのがあるんよ」  

希「`MultiParamTypeClasses`については、にこっち多分知っとると思うんやけど」  
にこ「ええ」  
希「これって、0個の型に対するインスタンスも定義できるらしいやね」  

```haskell
{-# LANGUAGE MultiParamTypeClasses #-}

class Nullary
instance Nullary

main :: IO ()
main = return ()
```

にこ「！？
型クラスの受け取る型を、1個以上……
じゃなくて0個以上として一般化する拡張だったのね……」  

にこ「これ、何にどうやって使うのかしら」  
希「うーん、わからへん……」  


# ConstrainedClassMethods
にこ「なにこれ、しらないわ」  
希「型クラスの関数に、型制約を設けることができるようになるみたいやね」  

```haskell
{-# LANGUAGE ConstrainedClassMethods #-}

class UnitedConvertible a where
  toItself :: a -> a
  -- ConstrainedClassMethods allows to restrict constraints in the type class function
  toString :: Show a => a -> String

main :: IO ()
main = return ()
```

希「Haskell98は型クラス関数に型制約を設けることを禁止してるらしくって」  
希「それの回避策らしいみたい。
Haskell98がそれを禁止してるの、なんでやろな？」  
にこ「Haskell reportは実装に言及しないらしいし、実装都合じゃあなさそうね。
なんでかしら」  

にこ「ていうか、型クラスの関数って、型制約付けられなかったのね。
型クラス関数に他の型クラスの制約をつけることなんてあまりないものね……」  


# RebindableSyntax
にこ「名前からして面白そうね」  
希「やね！ふむふむこれは……
Haskel reportでは以下の変換規則が規定されているらしいんやけど」  

```haskell
1
↓
Prelude.fromInteger (1 :: Integer)
```

希「それを以下の変換規則に付け替えるんやって。」  

```haskell
1
↓
fromInteger (1 :: Integer)
```

にこ「ふむふむ、Preludeの定義を参照はずのものを、ローカルの定義への参照に変えられるのね」  

にこ「うわっ、`putStrLn 1`式を合法にできた……」  

```haskell
{-# LANGUAGE RebindableSyntax #-}

-- RebindableSyntax turns on NoImplicitPrelude
import Prelude hiding (fromInteger)

-- In the Haskell report specification,
-- a literal `1` is expanded to `Prelude.fromInteger (1 :: Integer)`.
--
-- RebindableSyntax changes it to that is expanded to `fromInteger (1 :: Integer)`,
-- also it means `1`'s convertion is able to rebind.
fromInteger :: Integer -> String
fromInteger _ = ";P"

main :: IO ()
main = putStrLn 1
-- {output}
-- ;P
```

希「`putStrLn 1`、字面がすごいわ……。
ああこれ、`NoImplicitPrelude`も有効になるんね」  

希「他にはこんな変換規則を付け替えられるみたいやね」  

| | |
|:--|:--|
| `252.52` | `Prelude.fromRational (252.52 :: Rational)` |
| `x == y` | `x Prelude.== y` |
| `x - y` | `x Prelude.- y` |
| `x >= y` | `x Prelude.>= y` |
| `- x` | `negate x` |
| `if x then y else z` | `ifThenElse x y z` |
| `#nozo` (if `OverloadedLabels` is used) | `fromLabel @ "nozo"` |
| リスト色々 | [OverloadedLists - GHC User's Guide](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/glasgow_exts.html#overloaded-lists) |

希「あとは`do`, `mdo`, リスト内包記と`Arrows`についても変換規則があるみたいやけど、明記はされてないんね。
`do`は多分こんな感じかなあ。
本当は多分パターンマッチまで考慮してそうやね」  

```haskell
do
  x' <- x
  y
  z
↓
x Prelude.>>= \x' ->
y Prelude.>> z
```

- [10.3.15. Rebindable syntax and the implicit Prelude import - 10.1. Language options - Glasgow Haskell Compiler 8.2.2 User's Guide](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/glasgow_exts.html#rebindable-syntax-and-the-implicit-prelude-import)


## NoImplicitPrelude（補足）

- [No import of Prelude - HaskellWiki](https://wiki.haskell.org/No_import_of_Prelude)

にこ・希（読んでの通り、暗黙的に`import Prelude`を行わないための拡張。
これを指定しない限り、GHCは暗黙的にそれを行う）  


# InstanceSigs
にこ「これは、インスタンスを定義するときに、型クラスの関数の具体的シグネチャをインスタンス側で書けるやつね」  
希「さすがにこっちやね、知っとったか」  

```haskell
{-# LANGUAGE InstanceSigs #-}

class Identical a where
  id' :: a -> a

instance Identical Int where
  -- InstanceSigs allows this type declaration
  id' :: Int -> Int
  id' = id

main :: IO ()
main = return ()
```

にこ「ええ。
インスタンス側の型クラス関数が、そのときに使いたい型になっているか不安なときに使ったりするわ」  
にこ「でも、一度コンパイルが通ったら消しちゃうことも少なくないわ……
コンパイル速度が落ちそうな気がしちゃって」  

希「どうなんやろな？」  


# ImpredicativeTypes
にこ「非可述的な……型々？」  
希「なんやろこれ？？」  

にこ「こういう時はここを見るのが一番ね。
あったあった、GHC Wikiページ！」  

- [ImpredicativePolymorphism - GHC](https://ghc.haskell.org/trac/ghc/wiki/ImpredicativePolymorphism)

```haskell
{-# LANGUAGE ImpredicativeTypes #-}
{-# LANGUAGE RankNTypes #-}

f :: Bool -> b -> b
f = const id

g :: (forall a. a -> a) -> Int
g = undefined --const 10

foo :: Bool -> Int
foo x = g $ f x

--foo' :: Bool -> Int
--foo' = g . f

main :: IO ()
main = return ()
```

にこ「なるほど、うーん。
多分、`f`の型変数`b`と、`g`の**ランク2多相**の型変数`a`が、同一のものとして具体化できるか
というのが問題っぽいわね」  

希「`ImpredicativeTypes`を使うと、こんな感じの型変数`x`が決定できる？」  

```
      f
Bool --> (x -> x)
    \     |
     \    | g
      \   v
       > Int
```

にこ「うーん、そうっぽい？」  
希「うーん」  

...

にこ「`g`の実定義を`g = const 10`にしたら、
`ImpredicativeTypes`を外してもコンパイルが通るわ」  
にこ「逆に`foo'`をコメントインすると、`ImpredicativeTypes`を有効にしていてもコンパイルが通らないわ」  

希「うーん、さらにいろいろ機能があるみたいやね」  
希「ここが参考になりそうやん」  

- [10.1. Language options - Glasgow Haskell Compiler 8.2.2 User's Guide](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/glasgow_exts.html#impredicative-polymorphism)
- [Boxy type inference for higher-rank types and impredicativity - Microsoft Research](https://www.microsoft.com/en-us/research/publication/boxy-type-inference-for-higher-rank-types-and-impredicativity/)


# ExplicitNamespaces
にこ「ああ、型演算子を作った時に、
importとmoduleでのエクスポートで`type`って書けるのは
この子のおかげだったのね」  

Helper.hs

```haskell
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Helper
  ( type (-<|)
  , (-<|)
  ) where

type family (-<|) a b where
  x -<| _ = x

(-<|) :: a -> b -> a
(-<|) = const
```

Main.hs

```haskell
{-# LANGUAGE ExplicitNamespaces #-}

-- `ExplicitNamespaces` allows 'type' keyword in import/export
import Helper (type (-<|), (-<|))

x :: (-<|) Int Char
x = 10 -<| 'a'

main :: IO ()
main = return ()
```

希「この`type`ってなんなん？」  

にこ「このHelper.hsで、`(-<|)`は型レベルと値レベルのどちらでも定義されてるでしょ？」  
にこ「それだとエクスポート時に`module Helper ((-<|)) where`って書いたときと、
import時に`import Helper ((-<|))`って書いたとき」  
にこ「それぞれどちらをインポート、エクスポートしたらいいかわからないわよね」  

にこ「だから`type`を指定したときには、型レベルの方を表すの」  

希「なるほどな〜。
デフォルトで値レベルの`(-<|) :: a -> b -> a` を、
`type`を指定したときには型レベルの`(-<|)`を扱うって感じやんな！」  


# 夜更け
希「はぁ〜ふぅ」あくび  

にこ（……もう24ね）  
にこ「眠い？」  
希「うーん、ちょっと眠くなってもうたわ」  

にこ「明日眠くなって調子でなかったら大変だし、今日はもう寝ましょうか」  
希「せやね〜」  

希「楽しかったよ〜。
普段はにこっちから『遊ぼう』って言ってくれることなんてないし」  
にこ「悪かったわね。
アイドルに子育てにHaskell。
にこは忙しいのよ」  

にこ「でも今日はありがとう、私も楽しかったわ」  
希「うんん、いつでも呼んでな。
うち、Haskellerとしてのにこっちのことも、尊敬してるんよ」  
にこ「……//」  


# 参考ページ

- [言語拡張 - shiatsumat/wiwinwlh-jp Wiki - GitHub](https://github.com/shiatsumat/wiwinwlh-jp/wiki/%E8%A8%80%E8%AA%9E%E6%8B%A1%E5%BC%B5)
- [アニメ/ラブライブ/前回のラブライブ - Palantir's Wiki](http://www.palantir-k.net/palawiki/index.php?%E3%82%A2%E3%83%8B%E3%83%A1%2F%E3%83%A9%E3%83%96%E3%83%A9%E3%82%A4%E3%83%96%2F%E5%89%8D%E5%9B%9E%E3%81%AE%E3%83%A9%E3%83%96%E3%83%A9%E3%82%A4%E3%83%96)
- [【ラブライブ！】まさかの呼称に感じた弱さと強さ【矢澤にこ】 - Togetter](https://togetter.com/li/688135)
- [10.1. Language options - Glasgow Haskell Compiler 8.2.2 User's Guide](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/glasgow_exts.html#overloaded-lists)
