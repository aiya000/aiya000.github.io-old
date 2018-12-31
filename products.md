---
title: Products
---

- - -

- Outline
    - [文書](#texts)
    - [プログラム](#programs)

- - -

<a name="#texts"></a>

#### 矢澤にこ先輩といっしょに代数！

[![サークルカット](/images/posts/2018-09-12-techbookfest5/circle-cut.png)](https://techbookfest.org/event/tbf05/circle/43260001)

代数的構造についての、Haskellを用いた優しい入門本。

- [頒布物紹介（サンプル）](/posts/2018-09-12-techbookfest5.html)
- [サークルページ](https://techbookfest.org/event/tbf05/circle/43260001)
- [電子書籍版（販売中）](https://aiya000.booth.pm/items/1040121)

- - -

#### hs-zuramaru

- [GitHub - aiya000/hs-zuramaru](https://github.com/aiya000/hs-zuramaru)

Haskell製Lisp方言（+ inline-lisp for Haskell）

```haskell
>>> print [parse|(1 2 3)|]
Cons (AtomInt 1) (Cons (AtomInt 2) (Cons (AtomInt 3) Nil))

>>> case AtomInt 123 of; [parse|123|] -> "good"
"good"

>>> fromSing (sing :: Sing [parse|10|])
AtomInt 10

>>> [parsePreprocess|'10|]
Quote (AtomInt 10)

>>> [zurae|(print 10)|]
10Nil

>>> [zurae|'10|]
AtomInt 10
```

- - -
