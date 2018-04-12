---
title: Arch LinuxでEast Asian Ambiguous charが幅1で表示されることについて
tags: Linux, NeoVim
---
　相当前から…僕のArch Linux上のTermite上のNeoVimで 「…」 という文字が幅1で表示されてしまう 問題に悩ませれている。
結局解決できなかったが……今後別の環境でまた同じシチュエーションになったときのために……まとめておく。

……

# この記事中の各々のバージョン

| | |
|:-:|:-:|
| NeoVim | 0.2.2 |
| Vim | 8.0.1257 |
| urxvt | 9.22 |
| Termite | 13 |
| tmux | 2.6 |

# East Asian Ambiguous charactersって？
　これ :point_down:

- [東アジアの文字幅 - Wikipedia](https://ja.wikipedia.org/wiki/%E6%9D%B1%E3%82%A2%E3%82%B8%E3%82%A2%E3%81%AE%E6%96%87%E5%AD%97%E5%B9%85)

　幅2で表示されるべき文字だが、考慮されていない環境では幅1で表示されたりする。

# 結論
~~　urxvt * Vimを使うのがいいと思う。~~  
~~（NeoVim宗教上の理由により、僕は無理だった）~~

~~　または何かしらの統合デスクトップ環境を使えば、うまく対処できるのかもしれない。~~
~~僕は統合デスクトップ環境を使っていない。~~  
~~（xmonadを使っている）~~

　[fumiyas/wcwidth-cjk](https://github.com/fumiyas/wcwidth-cjk)
をインストールして、指示通り`.zshenv`あたりに
```sh
eval `/usr/local/bin/wcwidth-cjk --sh-init`
```
と書くと、urxvt上での問題は一切合切直った。
すごい！！

- [GitHub - fumiyas/wcwidth-cjk: Run command with CJK-friendly wcwidth(3) to fix ambiguous width chars](https://github.com/fumiyas/wcwidth-cjk)

　以下の内容は僕にとってもはや無用になったが、残しておく。
誰かのためになれば幸い。

# Vim上での問題以前
　前述の通りArch Linux * Termiteな環境ではEast…charはcatでもlessでもなんでもうまく表示されなかったが、
Vimだけは例外だった。
Vimの中ではTermiteの上であろうとurxvtの上であろうと幅2で表示される。

Vimではいずれの環境でもうまく表示された。
NeoVimではダメだった。

　これについて~~Dark Vim Master~~報告者の方は
「terminalの問題っぽい。urxvtではうまく動いた」と報告しているが、
後述する僕のurxvt環境（Arch Linux * urxvt）では
cat/lessでうまく動くものの
NeoVimではうまく動かなかったので、
やはりNeoVimの問題ではないかと思う。

（もう力尽きたので、これについての調査は行っておらず…ごめん）

- [Wrong ambiwidth VTE width when VTE_CJK_WIDTH - Issue #2684 - neovim/neovim - GitHub](https://github.com/neovim/neovim/issues/2684)

　なのでNeoVimからVimに乗り換えようと思ったものの、
僕はNeoVimに頼りっきりになっていて、無理だった……
NeoVimは最強、離れられない。

# Termiteの問題
![on-termite](/images/posts/2018-04-11-fix-arch-neovim-env-asian-ambiguous/in-termite.png)

　上の画像はTermite * NeoVimでの表示。

しかしながらcat/lessでもTermite上ではうまく表示されず、
TermiteではEastふんふんcharは必ず幅1で表示されるものと思われる。

　これについてはurxvtに以降することで対処した。

urxvt上でのcat/lessではEastふんふんは幅2で表示される。
（ただし絵文字はうまく表示できず、ぐぬぬ）

# NeoVimの問題
![on-urxvt](/images/posts/2018-04-11-fix-arch-neovim-env-asian-ambiguous/in-urxvt.png)

　しかしながら未だurxvt * NeoVim環境ではふんふんが幅2で表示されている（こんな感じ :point_up:）。

　この記事で「…」を多用して下記心地を試してみたものの、
ちょっとtypoが発生してしまいそうで怖い。

今はNeoVimのfやFなどを駆使してなんとかがんばっている……。

# その他の環境でEast Asian Ambiguous character widthに問題がある場合
　その他の環境でEast Asian Ambiguous character widthに問題がある場合に役に立ちそうなもの :point_down: 。

- tmuxに問題がある場合
    - [tmux 2.3 以降において East Asian Ambiguous Character を全角文字の幅で表示する - GitHub](https://gist.github.com/z80oolong/e65baf0d590f62fab8f4f7c358cbcc34)
- libc, urxvt, emacs, Vim, xterm, mlterm, screen, w3mのいずれかに問題がある場合
    - [GitHub - hamano/locale-eaw: East Asian Ambiguous Width問題と絵文字の横幅問題の修正ロケール](https://github.com/hamano/locale-eaw)
- Qtを用いたアプリケーションに問題がある場合
    - [qtermwidget-cjk-git というパッケージを作成し、AURに登録した。｜rago1975の部屋](http://rago1975.blog.shinobi.jp/lxqt/0071)
- 汎用的で局所的な対処
    - [GitHub - fumiyas/wcwidth-cjk: Run command with CJK-friendly wcwidth(3) to fix ambiguous width chars](https://github.com/fumiyas/wcwidth-cjk)
