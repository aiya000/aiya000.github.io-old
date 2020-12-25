---
title: brewで環境を更新したらVimでinsertモードに入ったときに固まるようになったので修正した
tags: Vim
---

雑記。

# 発生した問題

nvim-yarpに依存しているVimプラグインを使うときに？
Vimが固まる。

より具体的には「私のVimで`setf markdown`したあとにinsertモードに入ると、数秒ごとにVim固まるようになった」。
（insertモードを離れると、固まらなくなる。）

# 原因

macのbrewが、私のpython3.8を3.9に更新したこと。

# 解決

```shell-session
$ brew unlink python@3.9
$ brew link python@3.8
```

## 問題発生箇所

多分、nvim-yarpの内部のどこかで、Vimが固まっていたのだと思う。
それより深くはよくわからない。

- - -

ちなみにそもそも私は手動で`brew upgrade`をしたわけではなくて、確か何かを入れたときに勝手に環境がアップグレードされた。

そこらへん注意！
