---
title: にこ、希と一緒に学ぶHaskell（番外）「extensible-effectsの基本作用」 +絵里
tags: ラブライブ！で学ぶ, にこ、希と一緒に学ぶHaskell, Haskell
---

せーのっ

希・絵里「にこ（っち）、ハッピーバースデー！♡」

:tada: ﾊﾟﾊﾟｰﾝ!!

にこ「わ……」  

- - -

- [本編その1（ことり、穂乃果と一緒に学ぶHaskell（入門）その1「代数的データ型の定義」）](./2017-05-06-learn-haskell-with-muse.html)
- [前回 - にこ、希と一緒に学ぶHaskell（番外）「型クラスの定義と実装（Extra）」](./2017-05-27-learn-haskell-with-muse-extra.html)
- [更新履歴 - μ'sと一緒に学ぶHaskell](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)
- [記事一覧 - にこ、希と一緒に学ぶHaskell（番外）](/tags/にこ、希と一緒に学ぶHaskell.html)

- - -

# 7月22日（矢澤にこ誕生日）
希「いや〜〜、うちなんかさっきまでにこっちの誕生日知らんかったわ〜〜」  
にこ「な……なによもう」  
希「なーんて、冗談やでw　ちゃんと今日はエリチも呼んで、お祝いがてらのHaskell番外編や」  

絵里「ハロー。　ノーエリー・ノーライフ！」ｷﾗｯ  

にこ「誕生日なのに、すごく急に駆り出されたかと思ったら、そういうことだったのね。
　Haskellに関することじゃなかったらキレてたかもしれないけど、それならいいわ」  

- - -

にこ「ところで絵里は、Haskellのこと知ってるのかしら？」  
絵里「基本知識を備えている程度ね。　`Maybe`, `Either`, `Monad`。　ハラショー！」  
にこ「なるほど、だいたいわかったわ」  

希「今日はにこっちの誕生日やし、うち このために、にこっちが好きそうな構造を勉強したんよ」  
希（エリチはちょっと置いてきぼりにしちゃうかもしれんけど……）  

にこ「！　なにかしら？」  

希「その名も……effect-systemや！」ﾄﾞﾄﾞｰﾝ  
にこ「！」  


# extensible-effects
希「といっても今回うちが使ったんは、その実装の1つである`extensible-effects`っちゅうライブラリやん。
　正直なところeffect-systemが何かは……論文読んだりしたことないしわからんわ」  

希（ちなみに、うち知らんかったんやけど、`freer`っていう、もうちょっといいらしいeffect-system実装もあるらしいで〜）  

- [freer: Implementation of the Freer Monad - hackage](https://hackage.haskell.org/package/freer)

絵里「私も、なにやら『`Monad`スタックを置き換える』やら……って聞いたことあるわ。
　`Monad`スタックも正直わからないけど……」  
にこ「`Monad`スタックの詳細についてはまた今度改めて、回を開きましょうか。
　私も『`MonadTrans`の`lift`よりも高速に動く』って聞いたことがあるわ」  
希「パフォーマンスうんぬんは測定してなくて正直わからないんやけど、確かにエリチが言ってた−−`Monad`スタックを置き換える−−方のやつは確認したで〜」  


# 長くなるし、基本はこっちを読んでくれな〜
希「基本的なことはこっちに書いておいたので、読んでくれな〜」  

- [extensible-effects入門者がextensible-effectsをやってみた軌跡 - この世界線では私が希ちゃんの代わりに代筆しております](./2017-07-07-eff-experience.html)

希「まあ基本は`Member`, `SetMember`, `Lift`でアレアレコレコレエリエリチカチカする感じやね」  
にこ「へー、なるほど。
　アレアレコレコレエリエリチカチカするのね。
　面白いわね！」  
絵里「なるほど、すごいわね！」（←わかってない）  


# Monadスタックの大体としての作用の合成
希「てな感じに、`State Foo`, `Reader Bar`のようなモノを`Member`または`SetMember`で指定するわけやね」  

```haskell
context :: (Member (State Foo) r, Member (Reader Bar) r) => Eff r a
```

```haskell
impureContext :: ( Member (State Foo) r, Member (Reader Bar) r
                 , SetMember Lift (Lift IO)
                 ) => Eff r a
```

希「これを見ても『`Monad`スタックを代替する』っていうのはよくわからへんと思う。　`MonadTrans`使っても同じこと書けるしな」  

```haskell
context' :: (MonadState Foo m, MonadReader Bar m) => m a
```

```haskell
impureContext' :: ( MonadState Foo m, MonadReader Bar m
                  , MonadIO m
                  ) => m a
```

絵里「すごく見た目が同じね」  
希「そう、ここまでは同じなんよ。　でも、型を具体化した時にその特徴が表れるんや！」  


## 作用の合成やん
希「さっきの`impureContext`の型を具体してみるで〜」  

```haskell
impureContext :: Eff (State Foo :> Reader Bar :> Lift IO :> Void) a
```

希「具体化する時は、右端に`Void`を忘れんようにね」  

にこ「`(:>)`って？」  

希「GHCの`TypeOperators`っていう拡張で書けるようになる、いわゆる型演算子やね」  
希「まあイメージ的にはこんなデータ型やね。　実際は各関数の型を制御するための幽霊型として`EmptyDataDecl`を使って定義されてるんやけど」  

イメージ
```haskell
data a :> b = SumOfType a b
```

にこ「つまりは`(:>)`は`a`,`b`という情報を持つ型……単なる型と型の足し算を表す型って感じかしら」  
希「さすがやねにこっち、その通りや」  

絵里「なるほど……」（←わかってない）  

希「ここでは`(:>)`の左辺の型及び右辺の型を『作用』って言っていくで〜」  

希「そして……これに対して、さっきの`impureContext'`を具体化するとこんな感じのスタックになるね」  

```haskell
impureContext' :: StateT Foo (ReaderT Bar IO) a
```

希「よりわかりやすい例としては、前者は作用のみを`type`できるけど、後者は全体が各`Monad`のスタックを現してるから部分ぶぶんは`type`できへんね♡」  

```haskell
type LibraryEffect = State Foo :> Reader Bar :> Lift IO :> Void
impureContext :: Eff LibraryEffect a
```

```haskell
type Library a = StateT Foo (ReaderT Bar IO) a
impureContext' :: Library a
```

にこ「なるほど、確かにスタックを積んでる感じはしないわね。　`LibraryEffect`の定義なんて、綺麗なものねー」  

希「そうなんよ！　`State Foo :> Reader Bar`なんて、なんか『合成』って感じがせえへん！？」  
にこ「するわね！！」  
絵里「そうなるわね！」（←わかってない）  


# 夏色えがおで1,2,run!
希「あとは`runReader`やらで、その合成……幽霊型を除去したりするだけやね♪」  
絵里「だけね！」  

```haskell
-- Reader e :> rからReader eを引いてrにする
runReader :: Typeable e
          => Eff (Reader e :> r) w -> e -> Eff r w
```


# extensible-effectsには怖いこともあってな……
希「まあeffはこんな感じやね！　`MonadTrans`と比べて楽に書けるって人もいそうやんっ」  
にこ「私もさっそく試してみようかしら！」  

希「でも少しだけeffには怖いものがあってな……」  
にこ「」ｶﾀｶﾀｶﾀｶﾀ型ｶﾀ  

希「型を具体化せずに、綺麗な抽象化を保ったままミスをすると……ちょっと面白さんなコンパイルエラーが出るからそこはおおきにな♡」  
にこ「ｸﾞｱｱｱｱｱｱｱｱｱ！！」  

```haskell
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}

import Control.Eff (Eff, Member, (:>))
import Control.Eff.Exception (Exc)
import Control.Eff.Reader.Lazy (Reader)
import Control.Eff.State.Lazy (State)
import Data.Void (Void)

data Foo
data Bar

context :: (Member (State Foo) r, Member (Reader Bar) r, Member (Exc String) r) => Eff r ()
context = return ()

realContext :: Eff (State Foo :> Reader Bar :> Void) ()
realContext = do
  a <- context
  return a

main :: IO ()
main = return ()

```

```
• Couldn't match type ‘extensible-effects-1.11.0.4:Data.OpenUnion.Internal.OpenUnion2.Member'
                         (Exc String) Void’
                 with ‘'True’
    arising from a use of ‘context’
• In a stmt of a 'do' block: a <- context
  In the expression:
    do { a <- context;
         return a }
  In an equation for ‘realContext’:
      realContext
        = do { a <- context;
               return a }
```

- - -

...

- - -

絵里「もー、のぞみぃ、私さっきから全然わかんないわよー！」ﾌﾟﾝｽｺ  
希「ごめんやでエリチw　ほらにこっちも、そのコンパイルエラーは後で解決してあげるし、ケーキ食べよ♪」  
にこ「わーい、ケーキだー！　ぷりぷりのいちごが、可愛いニコニーにお似合いねー♡　なんてー♡♡♡」  
希「いやそれはどうなん……」  
絵里「にこは、今日も今日とて飛ばしまくりねっ♪」ﾆｺｯﾖｼﾖｼ  
にこ「ぬぅわによその反応は〜〜！！」ﾜｱｧｧﾜｱｧｧﾜｱｧｧ..  


# 参考にした資料やで♪

- [extensible-effects - stackage](https://www.stackage.org/lts-8.11/package/extensible-effects-1.11.0.4)
