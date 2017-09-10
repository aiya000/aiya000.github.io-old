---
title: lensの演算子と同じことをする関数一覧表
tags: Haskell
---
　`view`と`(^.)`のように、
型は違えど（`flip`されていたり、一般化されていても）同じことをする
関数と演算子がある。

　よく`review`と`preview`を間違えて覚えてたりして困るので、
これをここにまとめておく（随時更新、PRウェルカム）。

| 演算子                                        | 関数                                                               |
|:----------------------------------------------|:-------------------------------------------------------------------|
| (^.) :: s -> Getting a s a -> a | view :: MonadReader s m => Getting a s a -> m a |
| (^?) :: s -> Getting (First a) s a -> Maybe a | preview :: MonadReader s m => Getting (First a) s a -> m (Maybe a) |
| (.~) :: ASetter s t a b -> b -> s -> t | set :: ASetter s t a b -> b -> s -> t |
| (?~) :: ASetter s t a (Maybe b) -> b -> s -> t | 対応なし |

　余談だけど、演算子でなく関数を使った方が綺麗に書けるパターンとして、以下のように
`Functor`の内側にアクセッサを適用したいというものがある。

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
