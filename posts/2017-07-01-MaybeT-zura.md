---
title: MaybeTを使ってリファクタリングしたずら
tags: Haskell
---
　オラ、今日はLisp処理系の作成を進めてたずら。

- 進捗
    - [Use MaybeT instead of my FlipUp - aiya000/hs-zuramaru@ce6d56b - GitHub](https://github.com/aiya000/hs-zuramaru/commit/ce6d56bdfa9bb57582252cc5ef29aa4a343accf3)

　最初はIOの文脈で`<-`するために、Monadの順序の入れ替え用のこんな関数を使って連鎖してたずら。

```haskell
flipUp :: Maybe (IO a) -> IO (Maybe a)
```

- [past L76](https://github.com/aiya000/hs-zuramaru/blob/cc9e6bc64c989e17185b1ffffe376f4b5ada34f1/src/Maru/Main.hs#L76)

けどオラはここで、奇妙な既視感を覚えた。
「この連鎖、何かに似てる」……って。

　この正体は「`MonadTrans`のモナドバインド（`>>=`）」だったずら。

　`MonadTrans`である`MaybeT`……を使った`MaybeT IO`で上のrepl数を書き換えると

- [past L80](https://github.com/aiya000/hs-zuramaru/blob/cc9e6bc64c989e17185b1ffffe376f4b5ada34f1/src/Maru/Main.hs#L80)

こう何度もfmapしてたものをこのように……

- [future L73](https://github.com/aiya000/hs-zuramaru/blob/ce6d56bdfa9bb57582252cc5ef29aa4a343accf3/src/Maru/Main.hs#L73)

平坦なコードにできるずら！
しかも`MaybeT IO`のrepl関数内では`Maybe`の性質を完全に文脈に持たせてるから、
`IO`のときのようにいちいちそれが`Maybe a`の値であることを意味しなくて済むずら〜♪

ほら、各名前にmaybeほにゃらら〜〜って命名をしないようにしたずら。
だってそこには、`Maybe`の意味合いはないから……♪


# 参考ページ

- [有志がAqoursのお互いの呼び方をまとめてくれたぞ！これは助かる！【ラブライブ！サンシャイン!!】](http://lovelive-sunshine.info/17411)
- [国木田花丸ちゃんの声優・誕生日・自己紹介・プロフィールまとめ【ラブライブ！サンシャイン!!】](http://lovelive-sunshine.info/1683)
