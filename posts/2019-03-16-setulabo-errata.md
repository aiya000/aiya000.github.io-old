---
title: 正誤表 - せつラボ 〜圏論の基本〜
tags: 頒布物
---
# Special Thanks

　[\@tadsan](https://twitter.com/tadsan)さんは当日、弊サークルの売り子さんをしてくださり、売り上げに多大な貢献をしてくださりました。

にも関わらず、第一版の頒布時点での、本書のSpecial Thanksに書かれていませんでした……。
ですのでこの場をお借りして、感謝をあげさせてください。

　@tadsanさんの精力的な当日活動がなければ、今回の良き結果は残せなかったでしょう。
本当に、ありがとうございました！

# 内容

　[せつラボ 〜圏論の基本〜](https://aiya000.booth.pm/items/1298622)の誤りについての、Web正誤表です。
逐次、更新されます。

## 第二版で発生した誤りと修正

| 誤 | 正 |
|:-|:-|
| P.46: 「リスト5.18: ダメ: IntとCharの両⽅を組み合わせた値 のコード」 **(Int, Char)** [^left-either-does-not-include] | **Either Int Char** [^right-either-does-not-include] |
| P.105:「リスト10.13: &&&とは違う？ 関数**a**」 | 「リスト10.13: &&&とは違う？ 関数**h**」 |

- - - - -

[^left-either-does-not-include]: 誤  
```haskell
-- 以下は『成り立たない』
(-10, 'a') :: (Int, Char)    --    (-10, 'a') ∈ (Int, Char)
(252, 'q') :: (Int, Char)    --    (252, 'q') ∈ (Int, Char)
(100, 'z') :: (Int, Char)    --    (100, 'z') ∈ (Int, Char)
```

[^right-either-does-not-include]: 正  
```haskell
-- 以下は『成り立たない』
(-10, 'a') :: Either Int Char    --    (-10, 'a') ∈ Either Int Char
(252, 'q') :: Either Int Char    --    (252, 'q') ∈ Either Int Char
(100, 'z') :: Either Int Char    --    (100, 'z') ∈ Either Int Char
```
