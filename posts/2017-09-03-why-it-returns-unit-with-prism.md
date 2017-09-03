---
title: なぜ(^.)にMonoidのPrismを指定できるのか
tags: Haskell
---
　ここ

- [あいや☆ぱぶりっしゅぶろぐ！ - lensの(^?)はなぜGetting (First a) s aを引数に取るのか](2017-08-16-why-prism-accessor-takes-getting-first-a-s-a.html)

に書いた通り、
`(^?)`はある`Prism`を引数に取る。

　でもPrismは必ず`(^?)`と一緒に使わなきゃいけないわけじゃなくって、
`Monoid r => Getting r s a`の形になった`Prism`は
Lensの`(^.)`にも指定できる。
（例えば`_Right`）

```haskell
import Control.Lens
import Data.Monoid (Sum)

x :: Either Char (Sum Int)
x = Left 'a'

-- xはRight値ではないので、Sumの単位元であるSum 0が返る
main :: IO ()
main = print $ x ^. _Right

-- {output}
-- Sum {getSum = 0}
```

　実用上、`Prism`の`(^.)`が（上記のように）失敗した場合は
単位元が返されるのが便利なのはわかったけど、
なんで`(^.)`に`Monoid`の`Prism`を指定できるのか？

　型を簡約して、`_Right`が`(^.)`の型に合致することを確認してみる。


## なぜ(^.)にPrismを適用できるのか

```haskell
-- _RightはPrism
_Right :: Prism (Either c a) (Either c b) a b

-- Prismの定義により
-- type Prism s t a b = forall p f. (Choice p, Applicative f) => p a (f b) -> p s (f t)
_Right :: (Applicative f, Choice p) => p a (f b) -> p (Either c a) (f (Either c b))

-- ここからf,pに具体型を代入して、簡約していく

-- (->)はChoiceなので
_Right :: Applicative f => (a -> (f b)) -> Either c a -> f (Either c b)

-- `Monoid r => Const r`はApplicativeなので
_Right :: Monoid r => (a -> Const r b) -> Either c a -> Const r (Either c b)
```

　ここから`Getting`に特殊化すると

```haskell
-- b = aにする（bにaを代入する）
_Right :: Monoid r => (a -> Const r a) -> Either c a -> Const r (Either c a)

-- Getting r s aは`(a -> Const r a) -> s -> Const r s`のtypeシノニムなので
_Right :: Monoid r => Getting r (Either c a) a
```

　`(^.)`に、この特殊化された`_Right`の型を当てはめると

```haskell
(^.) :: Monoid r => s -> Getting r (Either c a) a -> a
```

になるので、`(^.)`には`_Right`を当てはめることができる。


## なぜ、この(^.)は単位元を取ってくるのか
　上記の型を見ると、確かに……
直和型の値の取得に失敗した際は、単位元を取ってくるんだろうなということが読み取れる。

　確認はここまででも十分だとは思うけど、せっかくなので`(^.)`の実装を確認して、
真に納得してみる。

　ひたすら簡約。

```haskell
Left 'a' ^. _Right
= Left 'a' ^. (prism Right $ either (Left . Left) Right)
= Left 'a' ^. dimap (either (Left . Left) Right) (either pure (fmap Right)) . right'
= getConst $ ((dimap (either (Left . Left) Right) (either pure (fmap Right))) (right' Const)) (Left 'a')
= getConst $ ((dimap (either (Left . Left) Right) (either pure (fmap Right))) (fmap Const)) (Left 'a')
= getConst $ (dimap (either (Left . Left) Right) (either pure (fmap Right)) (fmap Const)) (Left 'a')
= getConst $ either pure (fmap Right) . fmap Const . either (Left . Left) Right $ (Left 'a')
= getConst $ either pure (fmap Right) . fmap Const $ (Left . Left) 'a'
= getConst $ either pure (fmap Right) $ (Left . Left) 'a'
= getConst $ pure $ Left 'a'
= getConst $ pure (Left 'a')
= getConst $ Const mempty
= mempty
= Sum 0
```

　確かに単位元を取ってくることができた。


# 余談
　`Monoid a => Applicative (Const a)`の`pure`に引っかかってしまって、
この簡約にちょうど丸々1時間かかった。
