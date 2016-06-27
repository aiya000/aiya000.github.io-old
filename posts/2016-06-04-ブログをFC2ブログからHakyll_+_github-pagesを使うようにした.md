---
title: ブログをFC2ブログからHakyll + github-pagesを使うようにした
tags: Haskell, Shell, 環境, 日記
---
# ブログをFC2ブログからHakyll + github-pagesを使うようにした

　以前書いた [退職記事](./2016-05-26-C%23で仕事してましたが退職しました.html) がありましたが、あれはpandocでmarkdownからhtmlに変換してからFC2ブログに投稿していました。

しかし事件がここで起こり、具体的にはolとulがネストしている部分のStyleがだめになっていました。 [ありふれたhtmlの果て](https://www.amazon.co.jp/gp/product/B00J8D5WV2?ie=UTF8&*Version*=1&*entries*=0)。

ブログ環境を・・・ウッ・・・ガエダイ！！！

## 作業

　ある一時期から、FC2ブログに投稿する前のmarkdownファイルはローカルに保存していたので、その分はそのまま[Hakyll](https://jaspervdj.be/hakyll/)のpostsディレクトリに載せればそのまま動きました。 動く予定です。
( この記事は作業しながら書いているので、予定 )

　ここでちょっとしたTipsですが、\*NIXターミナルで複雑なコマンドを打つ場合は、bash使いならキーマッピングをviにしておくと便利です。  
具体的には以下の設定を.bashrcに書きます。 ( vi-insertの設定とvi-commandの設定を別個に書けないので、.inputrcには書かない )

```bash
# Set vi style keymapping mode
set -o vi

# Vim nize
bind -m vi-command '"_": beginning-of-line'
bind -m vi-insert  '"\C-\\\C-n": "\e"'

# Emacs nize
bind -m vi-insert  '"\C-n": next-history'
bind -m vi-insert  '"\C-p": previous-history'
bind -m vi-insert  '"\C-a": beginning-of-line'
bind -m vi-insert  '"\C-e": end-of-line'
bind -m vi-insert  '"\C-b": backward-char'
bind -m vi-insert  '"\C-f": forward-char'
bind -m vi-insert  '"\C-k": kill-line'
bind -m vi-insert  '"\C-d": delete-char'

# My taste
bind -m vi-insert  '"\C-l": "\e"'
bind -m vi-insert  '"\C-]": clear-screen'
bind -m vi-command -x '"\C-k\C-r": . ~/.bashrc && echo ">> bash source reloaded"'
```

( 多分、「bash vi」で検索すれば情報はうんさか出てきそう )


するとbashのviのnormalモードでvを押すと…コマンドラインが$EDITORで編集できます。  
あとはお好きに、`r!find`したりして、別のディレクトリに集めたファイル群をHakyllのpostsやimagesの構造に合わせてmvやcpすると強い。

こんなコマンドをいちいち手打ちするのは嫌ですよね、僕はVimでやりました。 ( 書き溜めてたディレクトリからpostsの形式にmv )

```
mv 2015-12-12_21-32.md 2015-12-12-ありがとうUbuntuの詩.md
mv 2014-08-03/ネクロトペンテス.html 2014-08-03-ネクロトペンテス.html
mv 2015-08-27_21-52.md 2015-08-27-虚白ノ夢をクリアしました.md
mv 2014-09-23/すんませんVrapperなめてました.md 2014-09-23-すんませんVrapperなめてました.md
mv 2015-03-31/vimrc読書会で読んでもらった、先々週に。.md 2015-03-31-vimrc読書会で読んでもらった、先々週に。.md
mv 2015-08-19_18-13.md 2015-08-19-TypeScriptでjQueryを扱う_with_tsd.md
mv 2015-11-22_01-50.md 2015-11-22-よさがぴょんぴょんするんじゃあ〜_in_VimConf2015.md
mv 2016-05-01_17-32.md 2016-05-01-HaskellでTwitterにTweetする.md
mv 2014-09-26/HowToEGit.md 2014-09-26-EclipseにEGitを入れる.md
mv 2015-07-13_21-21.md 2015-07-13-Vim_scriptで定数.md
mv 2016-05-26_21-00.md 2016-05-26-C#で仕事してましたが退職しました.md
mv 2015-01-18/Song_of_Solami.md 2015-01-18-Song_of_Solami.md
mv 2015-08-24_21-20_今日楽しかったこと.md 2015-08-24_21-20-今日楽しかったこと.md
mv 2014-12-25/自称Javaristaの僕がいかにしてHaskellに触れて純粋になったか.md 2014-12-25-自称Javaristaの僕がいかにしてHaskellに触れて純粋になったか.md
mv 2015-08-02_20-28.md 2015-08-02-静的型付けの中で型を忘れた話.md
mv 2015-08-15_00-33.md 2015-08-15-Ubuntu15.04にnodejsとtypescriptを入れた.md
```

　この際になぜかhtmlで書かれていた記事とかをpandocでmarkdownに変換しつつ校正した。  
bashをviキーマッピングにして$EDITORをVimにしておくと、コマンドラインをVimで書けて かつ 他の作業もついでにできるので本当におすすめ。  
zshは全く知らない。


## 構造

　今回はHakyllで作ってるブログ楮自体も管理したかったのでこちらを参考に。

- [Hakyll - Using Hakyll with GitHub Pages](https://jaspervdj.be/hakyll/tutorials/github-pages-tutorial.html)

成果物のリポジトリはこちら。

- [aiya000.github.io](https://github.com/aiya000/aiya000.github.io)


## まとめ

- なぜJekyllじゃなくてHakyllにこだわったのか？ Haskell使いたいからです
- bashのviキーバインドは超ベンリ
- Markdownは超ベンリ
- github-pages使ってるだけなので、ドメインあるし無料だし最高
- 就職先探してます
