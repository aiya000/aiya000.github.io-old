---
title: 今年のGitHubでの開発まとめ
tags: 備考録
---
# 今年に進捗したリポジトリ一覧の取り方
　リポジトリ一覧はこれで取りました！

```shell-session
$ for i in {1..7} ; do
    curl "https://github.com/search?l=&p=${i}&q=user%3Aaiya000+pushed%3A%3E2017-01-01+fork%3Atrue&ref=advsearch&type=Repositories&utf8=%E2%9C%93" | pup '.repo-list div div h3 a json{}' | jq -r '.[].text'
  done
```

（  
GitHub WebAPIの方だとなぜか31件しか取れなかった。
それはこう。

```shell-session
$ curl 'https://api.github.com/users/aiya000/repos?sort=pushed' | jq -r '.[].html_url'
```

）

NeoVim上でそれを実行すると、バッファにゴミと共にこんなリストが取れるので

```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 70203    0 70203    0     0  70203      0 --:--:--  0:00:01 --:--:-- 47338
aiya000/hs-kemono-friends
aiya000/aref-web.vim
aiya000/dotfiles
aiya000/aiya000.github.io
aiya000/hs-throwable-exceptions
aiya000/nico-lang
aiya000/hs-gorira
aiya000/workspace
aiya000/aho-bakaup.vim
aiya000/hs-zuramaru
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 56156    0 56156    0     0  56156      0 --:--:--  0:00:01 --:--:-- 45766
aiya000/hs-brainhack
aiya000/hs-stack-type
aiya000/hs-hucheduler
aiya000/franz-kokoro-io
aiya000/sh-hereis
aiya000/xmonad-config
aiya000/eta-doromochi
aiya000/zsh-shell-kawaii
aiya000/yi-config
aiya000/learning-Haskell
...
...
```

全部ヤンクして、てきとーな新規バッファにプットして`qagg3dd10jq6@a`という感じにします。

（ここの`6`は

`https://github.com/search?l=&p=1&q=user%3Aaiya000+pushed%3A%3E2017-01-01+fork%3Atrue&ref=advsearch&type=Repositories&utf8=%E2%9C%93`

で取れるページ数 -1 の数。
`aiya000`を変更してください :exclamation: ）

そしてあとはタブ内に、ブログ記事用のmarkdownバッファを左に、 :point_up: の一覧を右にして
`<C-b>`キーのために僕のvimrcを導入して、

`qavil"uy<C-w>hGo<CR>## <C-r>u<CR>CR>- [](https://github.com/<C-r>u)vib"+y_f[<C-b><Esc><C-w>lddq59@a`

ってやるとできます。
（`59`はリポジトリの総数 - 1）


# 進捗一覧
　本年度に1つ以上のコミットをしたリポジトリは60個くらいあったため、
ほとんど何もしてないのと、何をしたか覚えてないのは省略しました。

　最近スターの欲しさがすごいので、スターをください。

## eta-doromochi
　現在最も開発中。
Etaを使ったHaskellでのJavaFXプログラミングの実験。
ちょっとEtaの問題点が発覚してきた。

どうせ誰もPRしないだろうしWIPだし、どうせ誰も見てないので、masterに`git push -f`しまくってるげふんげふん

- [GitHub - aiya000/eta-doromochi: An Eta experience](https://github.com/aiya000/eta-doromochi)

　絵を[はっさくさん](https://twitter.com/HassakuTb)に描いて貰えたのが本当に嬉しくて、
はっさくさんの絵はすごいすごい好みなので、
絶対に完成させるぞい！

!(-_-)[締め切りが2018-01-07](https://mascot-apps-contest.azurewebsites.net/2017/About)

## learning-Haskell
　いつもHaskell

- [GitHub - aiya000/learning-Haskell: My Learning for Haskell](https://github.com/aiya000/learning-Haskell)

## workspace
　ほとんどlearning-Haskellのサブリポジトリみたいなもの。

- [GitHub - aiya000/workspace: This is file space that is my learning any language.](https://github.com/aiya000/workspace)

## hs-zuramaru
　僕のLisp処理系！

- [GitHub - aiya000/hs-zuramaru: [WIP] An experience of Make-A-Lisp ずら〜](https://github.com/aiya000/hs-zuramaru)

## dotfiles
　コミット数がいっぱい

- [GitHub - aiya000/dotfiles: my dotfiles for public.](https://github.com/aiya000/dotfiles)

## aiya000.github.io
　このブログ

- [GitHub - aiya000/aiya000.github.io: my blog](https://github.com/aiya000/aiya000.github.io)

## hs-brainhack
　Haskellでbrainf*ck処理系を作るためのライブラリ。
各トークンを定義するだけで処理系が作れる。

- [GitHub - aiya000/hs-brainhack: The brainf*ck language maker library](https://github.com/aiya000/hs-brainhack)

## nico-lang
　hs-brainhackの例で、にこにーです。

- [GitHub - aiya000/nico-lang: Nico-lang is the programing language of Nico Yazawa](https://github.com/aiya000/nico-lang)

## hs-kemono-friends
　hs-brainhackの例で、すごーい！

- [GitHub - aiya000/hs-kemono-friends: あなたはプログラミング言語フレンズなんだね！（Haskell）](https://github.com/aiya000/hs-kemono-friends)

## hs-gorira
　Haskell製Twitter bot。
動かす環境がないので、最近動かせてない。

- [GitHub - aiya000/hs-gorira: He is Twitter bot that made by Haskell.](https://github.com/aiya000/hs-gorira)

## hs-sentence-jp
　hs-gorira用のライブラリなんだけど、hs-goriraと分割する必要がなかった。

- [GitHub - aiya000/hs-sentence-jp: Easily generating sentence from texts.](https://github.com/aiya000/hs-sentence-jp)

## aho-bakaup.vim
　Vimで、ファイル保存毎にそのファイルのバックアップを取るやつ。
最新以外のバックアップも保存されるので、標準の'backup'より強い。

- [GitHub - aiya000/aho-bakaup.vim: aho-bakaup.vim backs up any files when you write the file](https://github.com/aiya000/aho-bakaup.vim)

## aref-web.vim
　VimでWeb辞書を非同期で取ってくる。
Haskellのstackageとかweblio引ける。

- [GitHub - aiya000/aref-web.vim: Web dictionaries on the vim with async.](https://github.com/aiya000/aref-web.vim)

## hs-throwable-exceptions
　TemplateHaskellを使って、例外型を生成するやつ。

- [GitHub - aiya000/hs-throwable-exceptions: Give the exception's value constructors for your haskell project](https://github.com/aiya000/hs-throwable-exceptions)

## hs-stack-type
　stackageにパッケージを上げるための練習。

- [GitHub - aiya000/hs-stack-type: The very very simply representation of the stack data type](https://github.com/aiya000/hs-stack-type)

## hs-hucheduler
　僕の実力確認用に、短時間で作ってみたやつ。

- [GitHub - aiya000/hs-hucheduler: simple schedule notifyer](https://github.com/aiya000/hs-hucheduler)

## franz-kokoro-io
　kokoro.io。

- [GitHub - aiya000/franz-kokoro-io](https://github.com/aiya000/franz-kokoro-io)

## sh-hereis
　もう使ってない。

- [GitHub - aiya000/sh-hereis: Bookmark for your shell (sh, bash, zsh and others compatible)](https://github.com/aiya000/sh-hereis)

## xmonad-config
　xmonad.hsだけど、巨大になりすぎたのでhaskell-stackプロジェクトとして管理してる。

- [GitHub - aiya000/xmonad-config: my xmonad preference](https://github.com/aiya000/xmonad-config)

## zsh-shell-kawaii
　zshで可愛いやつ。

- [GitHub - aiya000/zsh-shell-kawaii: Your shell dresses up lovely (*^-^)](https://github.com/aiya000/zsh-shell-kawaii)

## yi
　Vim/EmacsライクなHaskell製エディタyi。
設計がStatelessで美しい。

Vimでいう`:register`を実装してPRした。


- [GitHub - aiya000/yi: The Haskell-Scriptable Editor](https://github.com/aiya000/yi)

## yi-config
　Vim/EmacsライクなHaskell製エディタyiの僕用設定。

- [GitHub - aiya000/yi-config: my yi config](https://github.com/aiya000/yi-config)

## hs-snowtify
　`$ stack build`や`$ stack test`をnotifyデーモンで表示するやつ。

- [GitHub - aiya000/hs-snowtify: snowtify send your result of `stack build` (`stack test`) to notify-daemon :dog2:](https://github.com/aiya000/hs-snowtify)

## franz-lgtm-in
　はい

- [GitHub - aiya000/franz-lgtm-in: A franz plugin for LGTM.in](https://github.com/aiya000/franz-lgtm-in)

## vim-quickrun
　`elm`とか`eta`とかの対応をPRしたりした。

- [GitHub - aiya000/vim-quickrun: Run commands quickly.](https://github.com/aiya000/vim-quickrun)

## mani
　はい

- [GitHub - aiya000/mani: A window automation tool.](https://github.com/aiya000/mani)

## haan
　hi

- [GitHub - aiya000/haan](https://github.com/aiya000/haan)

## thank-you-stars
　「プロジェクト名とカレントディレクトリが同じじゃないと失敗するから、`.cabal`ファイルを指定できるようにしたよ」
ってPRしたら、
しばらく放置されてから「別仕様で対応しました」って言われてCloseされたけど、これはいいやつです。

- [GitHub - aiya000/thank-you-stars: Give your dependencies stars on GitHub!](https://github.com/aiya000/thank-you-stars)

## extensible
　`liftMaybe`あたり？をPRした。

- [GitHub - aiya000/extensible: Extensible records, variants, structs, effects, tangles](https://github.com/aiya000/extensible)

## hs-rins
　LensがわからなすぎてLensを作ろうとしたんだけど、
Lensが理解できたのでLensを作らなかった。

- [GitHub - aiya000/hs-rins: 凛はLensになるんだにゃ](https://github.com/aiya000/hs-rins)

## rsync_backupper
　僕が外付けHDDにOS (Linux)をバックアップするやつ。

- [GitHub - aiya000/rsync_backupper: :D](https://github.com/aiya000/rsync_backupper)

## adrone-hs.vim
　Vimで日記。
今でも使ってる。

- [GitHub - aiya000/adrone-hs.vim: Diary plugin for vim.](https://github.com/aiya000/adrone-hs.vim)

## programming
　ハクトーバフェスタのやつ

- [GitHub - aiya000/programming: Code a program in a language of your choice.](https://github.com/aiya000/programming)

## ilinq.py
　Linq to objectのpython3実装で、`span`関数をPRした。

- [GitHub - aiya000/ilinq.py](https://github.com/aiya000/ilinq.py)

## mvn-javafx-sample
　mvn + JavaFXの環境を練習です。

- [GitHub - aiya000/mvn-javafx-sample: Example for javafx with maven](https://github.com/aiya000/mvn-javafx-sample)

## vital.vim
　Data.EitherをPRした。

元々Data.Optionalもあったし、
Vim scriptは今後「モナドあるよ」って言える。

Data.Listをfuncref対応させつつ、
Data.List.ClosureいうやつでVim7.4でも使えるクロージャの
Data.List向け関数を提供しようとしてるんだけど、
Vim7.4のパーサの不具合？
で致命的なエラーが出ていて、致命的にめんどくさくなって放置してる。

　それさえ直せばもうマージしてもらえるはずなので、なんとかしたいんだけど、
どうしてもやる気でない。

頼む、誰かそこをなんとかしてくれないかな？ :sob:

- [GitHub - aiya000/vital.vim: A comprehensive Vim utility functions for Vim plugins](https://github.com/aiya000/vital.vim)

## hs-yohamaru
　アドベントカレンダー用に作った型レベルプログラミング（依存型）の例題だったんだけど、
SS形式で解説する意味を見出だせずボツになった。

- [GitHub - aiya000/hs-yohamaru: For Haskell Advent Calendar 2017](https://github.com/aiya000/hs-yohamaru)

## stackage
　Haskellerは皆持ってるリポジトリ。

- [GitHub - aiya000/stackage: &quot;Stable Hackage&quot;: vetted consistent packages from Hackage](https://github.com/aiya000/stackage)

## github-viewer.slack
　slackでgithub通知を対話的にも実行できるようになるやつ。

- [GitHub - aiya000/github-viewer.slack: slack plugin to view github state](https://github.com/aiya000/github-viewer.slack)

## zsh-zapack
　なぜか僕の環境ではzplugがやば遅かったので、早いやつを作った。
プラグイン機構はgit-submoduleを利用していて、自前では実装してない。

- [GitHub - aiya000/zsh-zapack: The basic minimum zsh plugin **loader** :+1:](https://github.com/aiya000/zsh-zapack)

## lens
　皆大好きLensの本家。
本家やぞ。

　何かがexport出来てなかった問題をPRした気がする。

- [GitHub - aiya000/lens: Lenses, Folds, and Traversals - Join us on freenode #haskell-lens](https://github.com/aiya000/lens)

## extensible-effects
　Haskellでの拡張可能作用の実装。

　何かがexport出来てなかった問題をPRした気がする。

- [GitHub - aiya000/extensible-effects: Extensible Effects: An Alternative to Monad Transformers](https://github.com/aiya000/extensible-effects)

## Maid
　どこかで発表したスライドとかを公開したりしてる。

VimConf2017でLTしたりした。

- [GitHub - aiya000/Maid: My slide collections.](https://github.com/aiya000/Maid)

## unite-outline
　elm対応を入れた。

- [GitHub - aiya000/unite-outline: outline source for unite.vim](https://github.com/aiya000/unite-outline)


# 参考

- [GitHub - ericchiang/pup: Parsing HTML at the command line](https://github.com/ericchiang/pup)
- [GitHub - stedolan/jq: Command-line JSON processor](https://github.com/stedolan/jq)
