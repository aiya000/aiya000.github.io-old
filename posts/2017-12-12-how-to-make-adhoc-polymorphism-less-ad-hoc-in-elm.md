---
title: How to make type classes without implicit parameter in Elm
tags: Elm, AdventCalendar2017, AdventCalendar
---
# 諸注意
　実案件で本アプローチを使用しないでください、特がありません！

- - -

<p class='dodon'>How to make and use type classes without implicit parameter in Elm</p>
<p class='dodon' style='text-align: center'>\- 侵略者 -</p>

- - -

# 本記事は
　Elm Advent Calendar 2017の12日目の記事です！

- [Elm Advent Calendar 2017 - Qiita](https://qiita.com/advent-calendar/2017/elm)


# Elmへの型クラスの導入
　この記事では、Philip Wadlerの論文「How to make ad-hoc polymorphism less ad hoc」
にて示される型クラスの導入を元にした、Elmに型クラスの導入を行うためのアプローチを示します。

- [How to make ad-hoc polymorphism less ad hoc](https://www.google.co.jp/search?q=philip+wadler+how+to+make+ad-hoc+polymorphism&ie=utf-8&oe=utf-8&client=firefox-b&gfe_rd=cr&dcr=0&ei=YbIOWq34J5KL8QeCm6GQAw)

　元文では

　基本的に表現は元の論文に準拠しつつ、
かつ修正が見込める場合は現代的な表現を用います。


# 本題: 単純な型クラスの導入
## ステップ1: Num型クラスの定義
　例として`Num`型クラスの定義を行います。

```elm
type NumD a = NumDict
  { add : a -> a -> a -- (+)の代わり
  , mul : a -> a -> a -- (*)の代わり
  , neg : a -> a      -- negateの代わり
  }

add : NumD a -> (a -> a -> a)
add (NumDict {add}) = add

mul : NumD a -> (a -> a -> a)
mul (NumDict {mul}) = mul

neg : NumD a -> (a -> a)
neg (NumDict {neg}) = neg
```

また、ここの各レコードは`Basics`ライブラリとの命名衝突を避けた命名がなされています。

　以下はHaskellのNum型クラスです。

```haskell
class Num a where
  add :: a -> a -> a -- 本来は(+)
  mul :: a -> a -> a -- 本来は(*)
  neg :: a -> a      -- 本来はnegate

-- add :: Num a => a -> a -> a
-- mul :: Num a => a -> a -> a
-- neg :: Num a => a -> a -> a
```

　ここで`NumD`型 = `Num`型クラスとみなします。

　本記事では、型クラスとなる型名には`D`サフィックスを、
そのインスタンス定義（後述）に用いられる値構築子には`Dict`サフィックスを付加します。


## ステップ2: Numインスタンスの定義

```elm
{-| IntのNumインスタンスの定義 -}
numDInt : NumD Int
numDInt = NumDict
  { add = (+)
  , mul = (*)
  , neg = negate
  }

{-| FloatのNumインスタンスの定義 -}
numDFloat : NumD Float
numDFloat = NumDict
  { add = (+)
  , mul = (*)
  , neg = negate
  }
```

　これでインスタンスの定義は完了です。

　`Int`及び`Float`のインスタンスの、`add`, `mul`, `neg`関数を使用してみます。

```elm
> add numDInt 1 2
3 : Int
> mul numDFloat 3.0 3.0
9.0 : Float
> neg numDFloat 3.0
3.0 : Float
> add numDInt 1 2.0
（Int and Floatのタイプミスマッチエラー！）
```

Good!

<p class='kosokoso'>…これ、実際はREPLで実行していなくて、コンパイルしてから似たような動作確認してます…。
elm-replはなぜ、ファイル読み込みを実装してくれないの？</p>


### ステップ2.5: Num型クラス制約のある関数を実装する

```haskell
square :: Num a -> a -> a
square x = mul x x
-- x * x
```

このHaskellコードと同じ内容を、本アプローチのElmで実装します。

```elm
square : NumD a -> a -> a
square numDa x = mul numDa x x
```

## ステップ3: 深いインスタンスを定義する
　ここでの「深い」とは、以下のようにインスタンスに型制約を持ち、
かつ抽象型（具体型でない型）のインスタンスであることを示します。

```elm
numDPair : (NumD a, NumD b) -> NumD (a, b)
numDPair numDab =
  let
    addPair : (NumD a, NumD b) -> (a, b) -> (a, b) -> (a, b)
    addPair (numDa, numDb) (x1, y1) (x2, y2) = (add numDa x1 x2, add numDb y1 y2)
    mulPair : (NumD a, NumD b) -> (a, b) -> (a, b) -> (a, b)
    mulPair (numDa, numDb) (x1, y1) (x2, y2) = (mul numDa x1 x2, mul numDb y1 y2)
    negPair : (NumD a, NumD b) -> (a, b) -> (a, b)
    negPair (numDa, numDb) (x, y) = (neg numDa x, neg numDb y)
  in NumDict
      { add = addPair numDab
      , mul = mulPair numDab
      , neg = negPair numDab
      }
```

これは以下のHaskellコードと同等です。

```haskell
instance (Num a, Num b) => Num (a, b) where
  add = addPair
    where
      addPair :: (Num a, Num b) => (a, b) -> (a, b) -> (a, b)
      addPair (x1, y1) (x2, y2) = (add x1 x2, add y1 y2)
  mul = mulPair
    where
      mulPair :: (Num a, Num b) => (a, b) -> (a, b) -> (a, b)
      mulPair (x1, y1) (x2, y2) = (mul x1 x2, mul y1 y2)
  neg = negPair
    where
      negPair :: (Num a, Num b) => (a, b) -> (a, b)
      negPair (x, y) = (neg x, neg y)
```

…

```elm
> add (numDPair (numDInt, numDFloat)) (1, 2.0) (3, 4.0)
(4,6.699999999999999)
```

:diamond_shape_with_a_dot_inside: OK! :diamond_shape_with_a_dot_inside:

## ステップX: まとめ
　まとめとして、型安全な値の比較をする関数`eq`を持つ型クラス`Eq`を作成します。

```elm
import List

{-|
class Eq a where
  eq :: a -> a -> Bool
-}
type EqD a = EqDict
  { eq : a -> a -> Bool
  }

{-|
eq :: Eq a => a -> a -> Bool
-}
eq : EqD a -> a -> a -> Bool
eq (EqDict {eq}) = eq

{-|
instance Eq Int where
  eq = (==)
-}
eqDInt : EqD Int
eqDInt = EqDict
  { eq = (==)
  }

{-|
instance Eq a => Eq (List a) where
  eq xs ys = zipWith eq xs ys & List.all id
-}
eqDList : EqD a -> EqD (List a)
eqDList eqDa =
  let
    eqList : EqD a -> List a -> List a -> Bool
    eqList eqDa xs ys = List.map2 (eq eqDa) xs ys |> List.all identity
  in EqDict
      { eq = eqList eqDa
      }

member : EqD a -> List a -> a -> Bool
member eqDa xs y = case xs of
  []      -> False
  (x::xs) -> eq eqDa x y || member eqDa xs y
```

```elm
> eq eqDInt 1 1
True
> eq (eqDList eqDInt) [1, 1] [1, 2]
False
> eq (eqDList (eqDList eqDInt)) [[10], [1, 2]] [[10], [1, 2]]
True
> member eqDInt [1, 2, 3] 2
True
```


# 複数の型制約を受け取る

```haskell
memsq :: (Eq a, Num a) => [a] -> a -> Bool
```

　このような2つ以上の型制約（aに対する`(Eq a, Num a)`）を持つ場合は、単純に

```elm
memsq : (EqD a, NumD a) -> List a -> a -> Bool
memsq (eqDa, numDa) xs y = member eqDa xs (square numDa y)
```

のようにしてあげるとよいです。

```elm
> memsq (eqDInt, numDInt) [1, 3, 5, 7, 9] 3
True
```

- - -

（本章の以下は余談です）

　もしかしたら、元論文を読んだ人が本章を読んだときに、違和感を感じたかもしれません。
というのも、ここでは元論文のこれについての内容を省略していることによるものです。

　元論文では、例えば以下のような関数

```haskell
memsq :: (Eq a, Num a) => [a] -> a -> Bool
```

の制約`(Eq a, Num a)`を今までのルールに載せるには
「`Eq a`もしくは`Num a`のクラス宣言で、どちらかをどちらかのサブクラスにするといい」
と。

つまり`Eq`型クラスを

```haskell
class Num a => Eq a where ...

memsq :: Eq a => [a] -> a -> Bool
```

と改変するか
（おそらくこの「改変」はプリプロセス時あたりを仮定している）

もしくは

```haskell
class Eq a => Num a where ...

memsq :: Num a => [a] -> a -> Bool
```

とするとよい。

と書いてある思うのですが、
本アプローチではそれも必要ないので、ばっさり省略しています。


# 終章: 複数の引数を持つ型クラス（multi param type class）
　複数の引数（実装の対象）を持つ型クラス（multi param type class）
を実装できることを示し、これで締めとします。

（「示す」だけに「締め」ということで）

例として、`a`から`b`への変換ができることを表す型クラス`Coerce`を実装します。

```elm
type CoerceD a b = CoerceDict
  { coerce : a -> b
  }

coerce : CoerceD a b -> a -> b
coerce (CoerceDict {coerce}) = coerce

coerceDIntFloat : CoerceD Int Float
coerceDIntFloat = CoerceDict
  { coerce = toFloat
  }
```


# 補足
　本記事のタイトルに付けた 'without implicit parameter'
の意ですが、
本アプローチではご覧の通り、型クラスインスタンスを表す値を
関数呼び出し時に省略することができません。

e.g. ここの`eqDInt`

```elm
--   vvvvvv
> eq eqDInt 1 1
True
```

（例えばScalaはこれを`implicit`でうまいこと解決していると思う）
（Haskell（GHC）は`ImplicitParams`拡張を使うことで、この`eqDInt`を省略させることができます。
いや、Haskellは構文レベルで型クラスをサポートしてるけどね）


# 終わりに
　この記事は、実際ネタ枠です。
現実的には、構造的部分型とかもっと単相的にやるとかの方がいいと思います。
