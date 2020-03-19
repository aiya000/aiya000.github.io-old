---
title: Products
---

- - -

# Outline

- [執筆](#texts)
    - [せつラボ 〜圏論の基本〜](#setulab1)
    - [矢澤にこ先輩といっしょに代数！](#algebra-with-nico)
- [プログラミング](#programming)
    - [Time script - 静的型付きVim script](#time-script)
    - [hs-zuramaru - Lisp方言](#hs-zuramaru)

- - -

# 執筆 <a name="texts"></a>

## せつラボ 〜圏論の基本〜 <a name="setulab1"></a>

<div class="minify">
[![サークルカット](/images/products/circle-cut-techbookfest6.png)](/posts/2019-03-16-techbookfest6.html)
</div>

女の子たちのゆるふわ、スタディノベル☆

「数学……難しそう」「数学やりたいんだけど、手が出ない……」

『数学を全く知らない方』のための本です。
数学的な事前知識を全く仮定せず、最初から数学を学んでいくことができます。

- 数学って……？
- 圏論？　Haskell？？
- どんなところが楽しいの？

読みやすい対話形式。
数学への初めての入門を、手引きします。

- [紹介＆サンプル](/posts/2019-03-16-techbookfest6.html)
- [サークルページ（技術書典7）](https://techbookfest.org/event/tbf07/circle/5762742296248320)
- [電子書籍版 - Booth](https://aiya000.booth.pm/items/1298622)
- [物理書籍版 - Booth](https://aiya000.booth.pm/items/1316747)
- [物理書籍版 - とらのあな](https://ec.toranoana.shop/tora/ec/item/040030721516)

- - - - -

## 矢澤にこ先輩といっしょに代数！ <a name="algebra-with-nico"></a>

<div class="minify">
[![サークルカット](/images/products/circle-cut-techbookfest5.png)](/posts/2018-09-12-techbookfest5.html)
</div>

ゆるふわにこまき数学！

代数的構造についての、Haskellを用いた優しい入門本です☆

- 数学・代数の雰囲気をゆるく知りたい
- 軽くHaskellを知りたい
- なんでもいいから技術系にこまきが読みたい

以上のような人に向けて。

- [紹介＆サンプル](/posts/2018-09-12-techbookfest5.html)
- [サークルページ（技術書典5）](https://techbookfest.org/event/tbf05/circle/43260001)
- [電子書籍版 - Booth](https://aiya000.booth.pm/items/1040121)
- [物理書籍版 - Booth](https://aiya000.booth.pm/items/1575006)
- [物理書籍版 - とらのあな](https://ec.toranoana.shop/tora/ec/item/040030721516)

- - -

# プログラミング <a name="programming"></a>

## Time script <a name="time-script"></a>

静的型付け & Vim script

- [GitHub - aiya000/hs-time-script](https://github.com/aiya000/hs-time-script)
- [導入（VimConf2019での発表資料）](https://aiya000.github.io/Maid/about-time-script/)

```vim
"*
 * Comment
 *"
function ExecuteFizzBuzz(): Void  " abort by default
  const xs: List<Int> = range(0, 100)
  const fizzbuzz: List<String> = []

  for x in xs
    call add(    " Add comments anywhere.
      fizzbuzz,  " Multi line without the line continuation '\'.
      s:fizzbuzz(x),
    )
  endfor

  echo string(fizzbuzz)
endfunction

function s:fizzbuzz(x: Int): String
  return
      x % 15 is 0 ? 'FizzBuzz' :
      x %  5 is 0 ? 'Fizz' :
      x %  3 is 0 : 'Buzz' : string(x)
endfunction

" Variables of functions by naming of [a-zA-Z0-9_]+ (not [A-Z][A-Za-z0-9_]+)
const f: () => Void = ::FizzBuzz  " Function references by ::
f()
```

## hs-zuramaru <a name="hs-zuramaru"></a>

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
