---
title: PullRequestをしよう！ - プロ生アドベントカレンダー2016 - 1日目
tags: AdventCalendar
---
この記事は[Qiitaプロ生アドベントカレンダー2016](http://qiita.com/advent-calendar/2016/pronama-chan)、一日目の記事です！ :)

# 起
　プログラマ諸君、PRをしましょう！（唐突）
 
　Qiitaプロ生アドベントカレンダーはIT関連の記事なら何でもOKということで、珍しくGenericな記事を書いてみます。  
ちなみに[マスコットアプリ文化祭](https://mascot-apps-contest.azurewebsites.net/2016/About)では

![僕の作品の画像](/images/posts/2016-11-23-pronama_advent_calendar_2016/my.png)

こういうものを登録しました :D


# 僕
　僕は…Unityの物理演算、VR、スマホアプリ作成やコミPo!などが(Twitter上で)多く観測されるプロ生界隈の中では
少数派かもしれない…非メディア系の技術を好んで学んでいます。

現在だと、型システム入門を頑張って読んで、構造的操作的意味論をいい感じにアレしてたり  
HaskellでTwitter bot書いてたり。

　そうすると割と他者に披露する際に、視覚的印象が少ない分、ウケがよくないかなとか思ったり。  
そこで自己顕示欲を保つための行動としてPRしよう！！ って感じのアレです。


# PullRequest(PR)とは
　OSSへの機能追加や修正などの修正を自前で行って、その変更をそのOSSにマージしてもらうように提案すること。

PRをすることにより、以下の効能があります。

- 自己顕示欲が満たされる
    - 自分の行った変更がマージされると、自分の作った変更がそのOSSユーザの人達に使われることになる
    - そのOSSのメンバーの人達と会話する機会が少し生まれるので、良い
- そのOSSへの理解が生まれる
    - OSSが使用している言語の知識がアレする
    - OSS独自の知識がアレする

なんか有名なOSSにPR投げてマージされると、そのOSS使ってる知人に  
「それ俺が実装した機能だぜ」  
とか言える。

直近だとこんなPRした。

- [yi-editor/yi - Add vim ex command :registers to listing register details](https://github.com/yi-editor/yi/pull/936)
- [vim-jp/vimdoc-ja-working - Translate test functions in eval.jax](https://github.com/vim-jp/vimdoc-ja-working/pull/86)


# PR投げる際の心配事とか

- 英語でやりとりしなきゃいけないけど、英語あんまりわかんない
 
　僕の未熟な英語でもなんかちゃんと接してくれた感じがする。  
「最近は『しっかりした英語』よりも『意味が伝わる程度の英語』が重要」とか聞いた気もするので、きっと大丈夫では。（無責任）

- PRでやるべきことは？

　もちろん、機能の修正や追加などのメインの目的が主なんだけど、**テスト**の修正や追加を気にしたりすると良さそう。  
この前、これ忘れそうになった。


# 結
　PRしよう。


# あ、
　そういえばvim-jpで行われているVimの:helpの翻訳(vimdoc-ja)で、人手が欲しいそうです。  
Vimにcontributeするチャンス！
PRのチャンス！

詳しくはここを参照！

- [vim-jp/vimdoc-ja-working Wiki](https://github.com/vim-jp/vimdoc-ja-working/wiki)
    - [eval.jax の未訳文を翻訳する](https://github.com/vim-jp/vimdoc-ja-working/issues/48)

以上！  
かしこまっ！
 
