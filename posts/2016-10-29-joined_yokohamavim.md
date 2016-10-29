---
title: Yokohama.vim#8に行ってきた
tags: イベント
---
まともな参加記事は以下！

- [thincaさんの](http://thinca.hatenablog.com/entry/yokohamavim-8)

# 出来事
　最初の出来事といえば、エレベーターの中で出会ったderisさんをyoshitiaさんと言ってしまい、間違えた。  
ごめんなさい！！？

# 自己組織化ゲーム(Vim)
　参加者の緊張やシャイさを考慮した粋な枠。  
自己組織化ゲーム(Vim)というのは、以下のルールのゲーム。

1. 参加者は各々の二人組になる
2. 組のうち1人は、もう1人から指示を受けるだけのアレになる
3. 組のうちもう1人は
    - 発声により、指示を受けるアレの人に以下の指示を与えることができる
        - H - アレの人を一歩分、左に移動させる
        - J - アレの人を一歩分、下？に移動させる
        - K - アレの人を一歩分、上？に移動させる
        - L - アレの人を一歩分、左に移動させる
    - 指示を受けるアレの人が進んだ歩数を数える

{H,J,K,L}については、本来の自己組織化ゲームだと{左,後,前,右}という発声に変わるが、今回においては完全にVimナイズされている。  
J,Kについては、Vim本来の意味では上下に移動という意味なので完全に怪しい動きになってしまう。  
なので各々で{後,前}のどちらかをどちらかに自前定義するということになった。

Vimmerは意外とキーマッピングを頭で覚えていないようで、皆混乱してた。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">難しすぎでは... <a href="https://twitter.com/hashtag/yokohamavim?src=hash">#yokohamavim</a></p>&mdash; ryunix (@ryunix) <a href="https://twitter.com/ryunix/status/787525436175622144">2016年10月16日</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

<blockquote class="twitter-tweet" data-lang="ja"><p lang="ja" dir="ltr">H (ひだり)<br>L (Left)<a href="https://twitter.com/hashtag/yokohamavim?src=hash">#yokohamavim</a></p>&mdash; Haskell使おうbot (@aiya_000) <a href="https://twitter.com/aiya_000/status/787527041486692352">2016年10月16日</a></blockquote>
 <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

　僕はかのTweetVimの作者であるbasyuraさんとペアになったぞ、羨ましかろう。

# 発表
## [DSL でナンデモプログラミング!? ～TeX と Vim script を比較してみた～](https://speakerdeck.com/watsondna/dsl-programming)
- @Watson_DNAさん

TeXでプログラミングするアレです。  
やべえ。

## Vim script で C のコンパイラを作ろうとしてる話
- @Linda_ppさん
- [repository - 8cc.vim](https://github.com/rhysd/8cc.vim)

ELVMというのを使ってなんかするやばいやつ。  
何らかの言語で？ ELVM用のコードを書いて？ ELVMが何らかの言語のコードを？ 出力するらしい。
多分近い未来では、Vim scriptでVim scriptを書くことができるようになりそう。

## Vim8のドキュメント読み
- @thincaさん

すごい。  
完全に読んでいて、説明力だった。

# 僕の当日作業
　僕は[Yiエディタ](https://github.com/yi-editor/yi)のコントリビュータになりたいと思っているので、yi.hsを書き書きしていた。  
冒涜的な作業。

# 懇談会
PizzaとSushiがあったので、食べた。  
犬さん達はgitの政治的な知見を集めていたり、ryunixさんthincaさん達はすごい勢いでもくもくしていた。  
僕は各位のところに行ったり、もくもくしたりしていた。

[コレ](http://qiita.com/aiya000/items/4d6493d1ef3098907a23)に遭遇していたので、やばかった。

# 次回
[VimConf2016](http://vimconf.vim-jp.org/2016/)のちょい枠で発表します :D

- - -

以上の内容は[プロ生48回目](https://atnd.org/events/82027)で書いた。
