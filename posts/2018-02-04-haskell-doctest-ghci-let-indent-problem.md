---
title: Haskellのdoctest (ghci) の:{..:}中のletでincorrect indentation
tags: Haskell
---
こんな感じのdoctestを書いていると怒られた :sob:

```
-- >>> :{
-- >>> let result = "good"
-- >>> "good"
-- >>> :}
-- "good"
```

```
### Failure in Foo.hs:364: expression `:{
 let result = "good"
 "good"
:}'
expected: "good"
 but got:
          <interactive>:436:2: error:
              parse error (possibly incorrect indentation or mismatched brackets)
```

let式を使うと（letにinを付けると）正しく実行された。

```
-- >>> :{
-- >>> let result = "good" in
-- >>> "good"
-- >>> :}
-- "good"
```

ちなみにこれもだめだった :confused:

```
-- >>> :{
-- >>> let result = "good"
-- >>> return "good"
-- >>> :}
-- "good"
```

マジかよ :exclamation: :exclamation:

- - -

参考までに、以下は「こんな感じ」の実例。

```
-- >>> :{
-- >>> let result = [z|
-- >>>               (do
-- >>>                 (def! x 10)
-- >>>                 (def! y (+ 10 x))
-- >>>                 (fn* (a) (+ x y)))
-- >>>              |] in
-- >>> case result of
-- >>>      [pp|(fn* (a) (+ 10 20))|] -> "good"
-- >>>      _ -> "bad: " <> readable result
-- >>> :}
-- "good"
```

```
### Failure in src/Maru/Eval.hs:364: expression `:{ilures: 0
 let result = [z|
               (do
                 (def! x 10)
                 (def! y (+ 10 x))
                 (fn* (a) (+ x y)))
              |]
 case result of
      [pp|(fn* (a) (+ 10 20))|] -> "good"
      _ -> "bad: " <> readable result
:}'
expected: "good"
 but got:
          <interactive>:441:2: error:
              parse error (possibly incorrect indentation or mismatched brackets)
```
