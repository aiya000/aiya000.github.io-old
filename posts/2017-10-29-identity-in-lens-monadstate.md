---
title: lens（のMonadState演算子など）で自己に言及したい時はidを使う
tags: Haskell
---
# まとめ
　lensにて。
例えば`Int`や`[Int]`のような単一の状態を持つ`MonadState`の文脈で、
状態自身（自己）に言及したい場合は、このようにすることで実現できる。

```haskell
import Control.Lens
import Control.Monad.State.Lazy (StateT, runStateT)

main :: IO ()
main = runStateT context [0] >>= print

-- dequeue behavior
context :: StateT [Int] IO ()
context = do
  id %= (10 <|)
  id %= (|> 20)
-- {output}
-- ((),[10,0,20])
```

```haskell
infix 4 %=
(%=) :: MonadState s m => ASetter s s a b -> (a -> b) -> m ()
(%=) :: ASetter s s a b -> (a -> b) -> StateT s m ()
(%=) :: ASetter' s a -> (a -> a) -> StateT s m ()
(%=) :: ASetter' [Int] [Int] -> ([Int] -> [Int]) -> StateT [Int] IO ()

(<|) :: a -> Seq a -> Seq a
(|>) :: Seq a -> a -> Seq a

(10 <|) :: Seq a -> Seq a
(|> 20) :: Seq a -> Seq a

type ASetter' s a = ASetter s s a a
type ASetter s t a b = (a -> Identity b) -> s -> Identity t

id :: p s (f a) -> p s (f a)
id :: (s -> f a) -> s -> f a
id :: (s -> Identity a) -> s -> Identity a
id :: ASetter' s a
id :: ASetter' [Int] [Int]

-- なので

(id %=) :: ([Int] -> [Int]) -> StateT [Int] IO ()
```


　ちなみに`Control.Lens.Equality`の`simple :: Equality' a a`の実定義は`id`。


# 参考

- [Control.Lens.Equality (simple)](https://www.stackage.org/haddock/lts-9.10/lens-4.15.4/Control-Lens-Equality.html#v:simple)
- [Control.Lens.Setter (ASetter)](https://www.stackage.org/haddock/lts-9.10/lens-4.15.4/Control-Lens-Setter.html#t:ASetter)


# Thanks

- [みょんさん](https://myuon.github.io/)
