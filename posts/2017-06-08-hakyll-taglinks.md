---
title: Hakyllの各記事ページのタグにリンクを付けた
tags: Haskell
---
# 成果物
- [2b5ac07b3c870c3904354f68e48cd3559f0d530c](https://github.com/aiya000/aiya000.github.io/commit/2b5ac07b3c870c3904354f68e48cd3559f0d530c)
- [6e78793b0294d10dccfd4d675718b545d4d2ff02](https://github.com/aiya000/aiya000.github.io/commit/6e78793b0294d10dccfd4d675718b545d4d2ff02)
- [8730bd90589369749c7010e44aec68d22e8e6964](https://github.com/aiya000/aiya000.github.io/commit/8730bd90589369749c7010e44aec68d22e8e6964)


# 何？
　👆にあると思うんですが、Tagsにリンクがつくようになりました。

![before](/images/posts/2017-06-08-hakyll-taglinks/before.png)

![after](/images/posts/2017-06-08-hakyll-taglinks/after.png)

　HakyllとHakyllのドキュメントがわからないので、`Compiler`, `Item`, `Identifier`, `Context`についてctagsを駆使して、諸関数を走り回っていました。
だってドキュメントに情報があまり書いてないんだもん。

- [ドキュメント](https://www.stackage.org/haddock/lts-8.11/hakyll-4.9.5.1/Hakyll-Core-Identifier.html)

　うおー、頭が最高になっていて、疲労もあるけど充実していて、そして最高になっていて充実感がある。


# 何？？
　つまりタグにタグページへのリンクを貼りたかったんです。
しかしHakyll公式のどこにもドキュメントが見つからなかったので、降りてきたHaskellの意思と同化し、そして達成した。


# 回答
　メタデータ全体を取ってきて、その中の、どこかの関数が設定するだろう"tags"フィールドを","区切りにしてできたものを"tagName"というフィールドに入れて、
それをlistFieldの"tagNames"としてpostCtx（記事用`Context`）に突っ込んだ。


# TODO
- なんで`urlField`（と（多分）他の`fooField`系関数）じゃだめで、`titleField`だと対象のフィールド名にtagsの値を設定できたのか？
- どこが"tags"をメタデータに設定しているのか？
- そもそも`MonadMetadata`あたり？ の状態っぽいのから"tags"を取ってくるんじゃなくて、純粋に書くページ用の生成することができるのではないか？
     - そう、`buildTags "posts/*"`のように！


# 感想
　最高。
全てが充実感にあふれており、この記事には知性が少なく、しかし充実感がある。
およそ文章の体を成していないこの記事を後日見たときに、おそらく恥ずかしくなるかもしれないけど、最高なのでいい。
うおー、最高だー。


# 参考ページ

- [Accessing list metadata in Hakyll](http://mattwetmore.me/posts/hakyll-list-metadata.html)
