---
title: Haskellのstack-build（test）の結果をGUI通知するsnowtify作ったよ
tags: Haskell
---
　[Haskell-jpのslack](https://haskell.jp/blog/posts/2017/01-first.html)の#questionで
「stack testの結果をGUIの通知デーモンに自動で表示する方法ってないですか？」と聞いたら
「残念だったな！！ 無理だ！ watchexecとかでガリガリやるんだな！！」（要約）と言われたので
作りました :dog2:

- [aiya000/hs-snowtify - GitHub](https://github.com/aiya000/hs-snowtify)
- [snowtify - Hackage](https://hackage.haskell.org/package/snowtify)

- [日本Haskellユーザーグループ発足・Slackチーム開放のお知らせ - Haskell-j](https://haskell.jp/blog/posts/2017/01-first.html)

![screenshot](https://raw.githubusercontent.com/aiya000/hs-snowtify/d4e35d1c510f7636a5f5fc043aa90f83ad023f50/screenshot.png)


# snowtifyを使う利点
　watchexecなどの、カレントディレクトリ以下のファイルの変更を監視するコマンドと組み合わせることで、
Haskellコードを書きつつファイルを保存、おそらく型が合っていないであろう場所をstack buildやstack ghciにて確認する……
といった手間を無くすことで（自動で行わせて、かつシームレスな領域--通知領域--に表示することで）、
そのようなBDDを加速させることができます。


# 現在のサポート状況
　Linuxのみです。
というのも僕がmacOSを持っていなくて、Windowsでの開発をしていないからです。
macOSとWindowsのメンテナ募集中です。


# snowtifyのインストール方法
　（haskell-stackは導入済みという体で進めていきます）

　stack installで入ると言いたいところなのですが、[PullRequestはマージされた](https://github.com/fpco/stackage/pull/2655)もののまだリリースされていないようです。

　cabal installでも入るとは思いますが、一番安定する方法としてはこれだと思います。

```console
$ git clone https://github.com/aiya000/hs-snowtify
$ cd hs-snowtify
$ stack install
```


# snowtifyを試す
　わかりやすい例を見るには、とりあえずtest-suiteが存在しつつ、かつstack testが失敗するようなhaskell-stackプロジェクトで試すのが一番だと思います。

　僕のLisp処理系のdevelopブランチに、ちょうどtestが失敗するようなコミットがあるのでこれで試しましょうか。

```console
$ git clone https://github.com/aiya000/hs-zuramaru
$ cd hs-zuramaru
$ git checkout b884e5
$ watchexec -w . snowtify &
$ touch a
```

　touch aしてから少しすると、お使いの通知デーモンに（GitHubリポジトリにある画像の例のように）
snowtifyのデフォルト挙動である`stack build`の結果が表示されるかと思います。

　stack testをsnowtifyに実行させたい場合は`snowtify test`を実行します。

　watchexecをインストールしていない方も、watchexecとtouchの代わりに以下の方法で実行できます。
ただしファイルの監視はなされません（snowtifyはhaskell-stackの--file-watchのようなオプションをサポートしていない）。

```console
$ snowtify
```


# snowtifyにおすすめの通知デーモン
　（この節はsnowtifyについての説明でないので、snowtifyについて知りたい方は読み飛ばして頂いても問題ありません。）

　作者はdunstを使っています。

- [GitHub - dunst-project/dunst: lightweight and customizable notification daemon](https://github.com/dunst-project/dunst)

　dunstは以下のように設定することで、タイムアウトによって勝手に通知が消えず、
Ctrl+.によって通知1つを、
Ctrl+,によって表示されている全ての消すことができる（はず）だからです。

~/.config/dunst/dunstrc
```config
[global]
    font                 = Ricty 15
    format               = "<b>%s</b>\n%b"
    alignment            = left
    word_wrap            = yes
    geometry             = "1000x50-30+20"
    separator_height     = 2
    padding              = 8
    horizontal_padding   = 8
    separator_color      = frame

[frame]
    width = 3
    color = "#aaaaaa"

[shortcuts]
    close     = ctrl+period
    close_all = ctrl+comma

[urgency_low]
    background = "#222222"
    foreground = "#888888"
    timeout    = 0

[urgency_normal]
    background = "#285577"
    foreground = "#ffffff"
    timeout    = 0

[urgency_critical]
    background = "#900000"
    foreground = "#ffffff"
    timeout    = 0
```

　プロジェクトのファイルに変更を加える  
→ stack testの結果が表示される  
→ 修正する  
→ 通知を消す  
→ ...

っていうループが、ほいっちゃほいっちゃ……という感じでできます。

- - -

　便利。
使ってみてください :wink:
