---
title: Haskellを教えて、対価としてモンハンを買って貰ってきた
tags: 日記
---
# 発端

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">switchのモンハン欲しい……switchのモンハン欲しいよお……</p>&mdash; ノエノエの犬（あいや） (@public_ai000ya) <a href="https://twitter.com/public_ai000ya/status/909406212852031489">2017年9月17日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">僕が1日、Haskellを本気で親身に教えるので、貴方はswitchのモンハンを僕に買ってください！</p>&mdash; ノエノエの犬（あいや） (@public_ai000ya) <a href="https://twitter.com/public_ai000ya/status/909406478057873408">2017年9月17日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">いいよ。</p>&mdash; きつねのみたま@頑張らない (@nf_shirosawa) <a href="https://twitter.com/nf_shirosawa/status/909408955662606337">2017年9月17日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

ンゴ！？！？


# アバウト
　今年のこの季節、やはり常々思うことは「SwitchのモンハンXX欲しい！」ということなので、
「Haskellを教えるので、Switchのモンハンください！」とつぶやいたら、
おキツネ美少女であるところのノエノエが「いいよ」と言ってくださったので、
某所にて密会してきました。

- やった範囲
    - [すごいH本](https://www.amazon.co.jp/dp/B009RO80XY/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1)（P.1〜P.33のうち、一部を飛ばして）
        - `if`, `case`などの構文はパターンマッチで代替できる場合が多いので、時間の都合上飛ばした
        - タプルもHaskellに限った概念でないので飛ばした
    - [ことり、穂乃果と一緒に学ぶHaskell（入門）](2017-05-06-learn-haskell-with-muse.html)その1からその4（の内容）
        - 今回は代数的データ型を覚えて貰えればなと思っていた
        - これも「まずは代数的データ型を覚えて欲しい」と思って書いたものなので、内容的にちょうどよかったから引っ張り出した
    - リストMonad（リストFunctor, リストApplicative）
        - なんとはなしに「そういえばノエノエは、教えて欲しいところとかあったりする？」など聞いてみると
            - ノエノエがとても勢い良く「Monad！！」と言ってくれたので
                - リストMonadも内容に入れた


# 自己評価
　特に`Monad`については教えるのが難しかった。

　まずは`Monad`が（`Applicative`に加えて）`join`を実現するような抽象だということに焦点を当てて、
`>>=`（モナドバインド）が`map`（`fmap`）と`join`の合成で構成できることを皮切りに、
リストの`map`を一般化したものが`fmap`（`Functor`）だということを説明した。

　その次に`Applicative`を教えたのだけど、`pure`はともかく
`<*>`（`ap`）がどのようなものか伝えるのが難しかった。

　また「なぜ`Monad`はこのような形になっているのか？」という疑問を残してしまったみたいだけど、
こればっかりはこの時間では説明仕切る自身がなく、
断念した。

　Haskellの基盤……パターンマッチ含む、代数的データ型については
ノエノエから疑問が出なかったので、
うまく教えられたかと思う。


# その後
　キツネ美少女であるところのノエノエにニンテンドープリペードカード6000円分を買ってもらい、
サイゼリヤでミラノ風ドリアなどを一緒に食べた。

# 最後に
　このようなマジの機会を設けてのHaskell教えは初めてだったので
テンポよくとは行きませんでしたが、
僕は今日もずっとモンハンXXをやっています。
