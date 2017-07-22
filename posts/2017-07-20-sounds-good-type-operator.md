---
title: 見た目がひどい型をTypeOperatorsで改善したらロジックと同じ見た目になった
tags: Haskell
---

before
```haskell
myLayoutHook :: Choose (ModifiedLayout Gaps (Choose (ModifiedLayout (Decoration TabbedDecoration DefaultShrinker) (ModifiedLayout (Sublayout Simplest) TwoPane)) Grid)) Full Window
myLayoutHook = (taskbarMargin $ twoTabbedPane ||| Grid) ||| Full
  where
    taskbarMargin = gaps [(D, 40)]
    twoTabbedPane = subTabbed $ TwoPane (1/55) (1/2)
```

after
```haskell
infixr 1 :$
type (:$) = ModifiedLayout

type (:.) x y z = x :$ (y :$ z)

infixr 2 :|||
type (:|||) = Choose

type MyLayoutHook  = (TaskbarMargin :$ TwoTabbedPane :||| Grid) :||| Full
type TaskbarMargin = Gaps
type TwoTabbedPane = SubTabbed TwoPane
type SubTabbed x   = (Decoration TabbedDecoration DefaultShrinker :. Sublayout Simplest) x

myLayoutHook :: MyLayoutHook Window
myLayoutHook = (taskbarMargin $ twoTabbedPane ||| Grid) ||| Full
  where
    taskbarMargin = gaps [(D, 40)]
    twoTabbedPane = subTabbed $ TwoPane (1/55) (1/2)
```

比較
```haskell
type MyLayoutHook = (TaskbarMargin :$ TwoTabbedPane :||| Grid) :||| Full
{--} myLayoutHook = (taskbarMargin  $ twoTabbedPane  ||| Grid)  ||| Full
```

Haskellの表現力はすごい :dog2:
