---
title: lensの演算子と等価な関数の対応表
tags: Haskell
---
　`view`と`(^.)`のように、
型は違えど（`flip`されていたり、一般化されていても）同じことをする
関数と演算子があります。

　よく`review`と`preview`を間違えて覚えてたりして困るので、
これをここにまとめておきます。

　なおここでの「等価」という言葉は「QuickCheckで両者の比較したら同じものが返ってくることをテストできるだろう」程度の意味合いで用いています。

|演算子                                         |関数                                                                | 役割                         |
|:----------------------------------------------|:-------------------------------------------------------------------|:----------------------------:|
|(^.) :: s -> Getting a s a -> a                |view :: MonadReader s m => Getting a s a -> m a                     | `Lens`型向けのgetter         |
|(^?) :: s -> Getting (First a) s a -> Maybe a  |preview :: MonadReader s m => Getting (First a) s a -> m (Maybe a)  | `Prism`型向けのgetter        |
|(.~) :: ASetter s t a b -> b -> s -> t         |set :: ASetter s t a b -> b -> s -> t                               | `Lens`型向けのsetter         |
|(?~) :: ASetter s t a (Maybe b) -> b -> s -> t |対応なし                                                            | 直和型に対するsetter**？？** |


# 使用例
　以下ではこれのimportを省略します。

```haskell
import Control.Lens
import Data.Void (Void)
```

## ^.

```haskell
-- _1はLens
main :: IO ()
main = print $ ('a', Right 10) ^. _1
-- {output}
-- 'a'
```

## ^?

```haskell
-- _RightはPrism
main :: IO ()
main = print $ ('a', Right 10) ^? _2 . _Right
-- {output}
-- Just 10
```

```haskell
-- _LeftはPrism
main :: IO ()
main = print $ ('a', Right 10 :: Either Void Int) ^? _2 . _Left
-- {output}
-- Nothing
```

## .~

```haskell
main :: IO ()
main = print $ ('a', Right 10 :: Either Void Int) & _1 .~ 20
-- {output}
-- (20,Right 10)
```

`.~`は`Prism`にも使えます。

```haskell
main :: IO ()
main = print $ ('a', Right 10 :: Either Void Int) & _2 . _Right .~ 20
-- {output}
-- ('a',Right 20)
```

```haskell
-- 評価されないから恥ずかしくないもん！
dummy :: Void
dummy = undefined

-- _Leftの照合に失敗するので、変更が起こらない
main :: IO ()
main = print $ ('a', Right 10 :: Either Void Int) & _2 . _Left .~ dummy
-- {output}
-- ('a',Right 10)
```

## ?~

```haskell
main :: IO ()
main = print $ ('a', Right 10) & _2 ?~ 20
-- {output}
-- ('a',Just 20)
```

```haskell
main :: IO ()
main = print $ ('a', Just 10) & _2 ?~ 20
-- {output}
-- ('a',Just 20)
```

```haskell
main :: IO ()
main = print $ ('a', Right 10 :: Either Void Int) & _1 ?~ 20
-- {output}
-- ('a',Just 20)
```


# 余談
## 関数の方の使いどころ
　演算子でなく関数を使った方が綺麗に書けるパターンとして、以下のように
`Functor`の内側にアクセッサを適用したいというものがあります。

```haskell
{-# LANGUAGE TemplateHaskell #-}

import Control.Lens

makeLensesFor [("runIdentity", "_Identity")] ''Identity

x :: Identity (Identity Int)
x = Identity $ Identity 10

-- ここ
z :: Identity Int
z = x <&> view _Identity

main :: IO ()
main = print z
```


## ?~ってなに？
　`?~`の使いどころがいまいちわからず…。
わかる人、どうか教えてください…。
