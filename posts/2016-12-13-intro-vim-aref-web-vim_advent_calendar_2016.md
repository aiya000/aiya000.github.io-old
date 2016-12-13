---
title: aref-web.vimの紹介 - Vimアドベントカレンダー2016 - 14日目
tags: Vim, AdventCalendar
---
　ドーモ、この前「HaskellでTwitterのbot作ってるんですよー」って言ったら  
「ああ、このアカウントですよね！」って言われて、僕のメインアカウントを指されたあいやです :D

[aref-web.vim](https://github.com/aiya000/aref-web.vim)の紹介をします！  
インストールしてね！


# aref-web.vimとは
　[weblio翻訳](http://ejje.weblio.jp/)やHaskellの[Hoogle](https://www.haskell.org/hoogle/)など…
いわゆるWeb辞書をVim上から扱うプラグインです。  
Webページを開いたり、開いたページの次ページへ行ったり(※)できます。

MSDNとかJavadocとかも使えるかもしれん :D

![sample-view](https://github.com/aiya000/aref-web.vim/raw/master/aref-web-vim_preview.gif)

- - -

※ちょっと今は設定インターフェースが悪いので、Issue来たら直す

```
<Plug>(aref_web_show_next_page)		*<Plug>(aref_web_show_next_page)*
	有効モード: normal mode

　もし 'https://www.stackage.org/lts-6.6/hoogle?q=Int+->+Int&page=1'
のように、 URLの整数型のクエリ文字列があれば
'https://www.stackage.org/lts-6.6/hoogle?q=Int+->+Int&page=2'
のような、末尾のクエリ文字列の整数値を +1 したURLを
現在のaref_webバッファに (非同期的に) 読み込みます。
```
```
<Plug>(aref_web_show_prev_page)		*<Plug>(aref_web_show_prev_page)*
	有効モード: normal mode

<Plug>(aref_web_show_next_page)と似たような動作をしますが、
こちらは、その整数値を -1 したURLを (非同期に) 読み込みます。
```

- - -

aref-web.vimとStackage検索(Hoogleと似たもの)を使っての作業風景をYouTubeで見ることができます。

- - -

[The scene of using aref-web.vim - YouTube](https://www.youtube.com/watch?v=lQ-QpPtGck4&feature=youtu.be)

- - -

　helpは以下で見ることができます :D

- - -

[aref-web.vim/aref\_web.jax - GitHub](https://github.com/aiya000/aref-web.vim/blob/master/doc/aref_web.jax)

- - -

　w3mコマンドに依存していて、Vim8以降で動きます。  
[open-browser.vim](https://github.com/tyru/open-browser.vim)が入っていると、Vimで開いたページをブラウザで開けます :)


# なぜ作った
　今までthincaさんの[vim-ref](https://github.com/thinca/vim-ref/)のweb-dictを使っていたのですが、丁度Vimにasync系の関数が入ってきたので、
そうなるとweb-dictを非同期で開きたいじゃないですか。  
作りました :)


# 使ってね
　使ってね :D
