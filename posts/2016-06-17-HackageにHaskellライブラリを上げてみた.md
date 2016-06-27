---
title: HackageにHaskellライブラリを上げてみた
tags: Haskell, 日記
---
# HackageとHaskellライブラリを上げてみた

Hackageデビュー。

* パッケージ
    - [Hackage](https://hackage.haskell.org/package/sentence-jp)

* 参考
    - [Haskell環境構築_20151226_最新版_4_投稿済み_stack-1.0.0対応版.md](http://qiita.com/philopon/items/879c2011ce8744c838de)
    - [Haskellのライブラリを作ってHackageに公開するまで](http://qiita.com/gogotanaka/items/a021ffce4fa33ce3c60b)

* やったこと
    1. Hackageに会員登録
    2. `stack upload .`でHackageにupload


　stackageにもPR(stackageへのパッケージ登録申請)を送りたかったのですが、sentence-jpはCライブラリであるmecabに依存しているので…
(sentence-jpが依存しているパッケージ(hsmecab)がmecabに依存している)  
stackだけで完結できないのはまずいと思いやめました。

```
Hello :)
I'm stackage beginner.
    and my English is poor, sorry X(
I made a 'sentence-jp' package.
I want to register it to stackage,
    but it depends a C library (mecab).
Can I register it ?
```

とか送ればよかったのかな？  
英語出来る人、間違っていたら校正してください。


- - -

* 多分成されないTODO
    - HackageのMudulesに関数のドキュメントが表示されていない(自分ではソース内に埋め込んだつもり)  
      原因を知っている人がいれば教えてプリーズ
