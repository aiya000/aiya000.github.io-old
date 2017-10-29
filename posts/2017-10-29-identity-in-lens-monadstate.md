---
title: lens（のMonadState演算子など）で自己に言及したい時はsimpleを使う
tags: Haskell
---
# まとめ
　lensにて。
例えば`Int`や`[Int]`のような単一の状態を持つ`MonadState`の文脈で、
（`id`のように）状態自身（自己）に言及したい場合は、このようにすることで実現できる。

```haskell
import Control.Lens
import Control.Monad.State.Lazy (StateT, runStateT)

main :: IO ()
main = runStateT context [0] >>= print

-- dequeue behavior
context :: StateT [Int] IO ()
context = do
  simple %= (10 <|)
  simple %= (|> 20)
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

simple :: Equality' a a

type Equality' s a = Equality s s a a
type ASetter'  s a = ASetter s s a a

type ASetter  s t a b = (a -> Identity b) -> s -> Identity t
type Equality s t a b = forall k3 p f. p a (f b) -> p s (f t)

-- 簡約
forall k3 p f. p a (f b) -> p s (f t)
    k3は幽霊            ==> forall f. p a (f b) -> p s (f t)
    p = (->)            ==> forall f. (a -> f b) -> s -> (f t)
    Identity = Identity ==> (a -> Identity b) -> s -> (Identity t)
                            = ASetter s t a b

simple :: ASetter' s a
simple :: ASetter' [Int] [Int]

-- なので

(simple %=) :: ([Int] -> [Int]) -> StateT [Int] IO ()
```


# 余談
　`simple`が`id`のようなもの、っていうのはこれを見るとわかる。

```haskell
import Control.Lens ((^.), simple)

main :: IO ()
main = print $ 10 ^. simple
-- {output}
-- 10
```
