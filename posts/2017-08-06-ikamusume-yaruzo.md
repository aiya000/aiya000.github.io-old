---
title: コミケ92 1日目金曜日 東た11bのλカ娘に記事を書いた
tags: イベント, 備考録
---
　8/11のC92、東た11bの『簡約！？ λカ娘10』に参加します！

　λカ娘は、昨今の関数型プログラミングや定理証明系の超最新情報が集まったりしてる本っぽいです。
今回はどうやら厚めの薄い本になるみたいです。

　僕は今回のλカ娘に『矢澤にこ先輩と一緒にモナドモナド！』っていうHaskellの記事を書きました。

![cover-illust](/images/posts/2017-08-06-ikamusume-yaruzo/cover.png)


　本記事は、本書を読んでみての感想かつ紹介記事になります :D


# 参考

- [コミケ92 金曜日 東た11bでの同人誌に記事を書きました | その他ブログ - masterq](https://kiwamu.wordpress.com/2017/08/04/コミケ92-金曜日-東た11bでの同人誌に記事を書きまし/)


# 矢澤にこ先輩と一緒にモナドモナド！（[\@public_ai000ya](https://twitter.com/public_ai000ya)）
　Haskellの`mmorph`というパッケージにある型クラス`MMonad`を、Haskellプロの矢澤にこにーと一緒に、順々に理解していく記事です。
`Haskell + 圏論`でHaskell寄りの内容になります。

- [Control.Monad.Morph](https://www.stackage.org/haddock/lts-8.11/mmorph-1.0.9/Control-Monad-Morph.html#t:MMonad)

　`MMonad`は、よく知られたモナド変換子`MonadTrans`の上位型クラスです。  
`Monad`や`MonadTrans`を（作ったことはなくとも）カジュアルに使えるようになったのでもっとモナドをこじらせてみたい。  
圏論も、圏や関手などの初歩は理解できた。 でも`Free`モナドとかよくわからんし……。  
というHaskellerにおすすめです。


# モナドとひも（[\@myuon_myonさん](https://twitter.com/myuon_myon)）
```
「最近Haskellを始めた」
「へぇ、またどうして？」
「モナドの勉強をしていて、その流れで」
```

　`Monad`を題材に、各関数をString Diagramと呼ばれる図式で書いてみるというチュートリアル的な内容です（Stringは紐の意）。  
圏論のCommutative Diagramのなどと比べて、String Diagramは関数の性質が視覚にもろに現れてる感じがして、とても興味深い。  
登場人物のキャラがちゃんとたっていて、うーん百合、という感慨が深かったです（そういう話ではないっぽい）。


# Coqダンジョン:底抜けの壺の夢（[\@master_qさん](https://twitter.com/masterq_mogumog)）
```
ううーん。Coqの宿題がぜんぜん解けないじゃなイカ……
Coqの宿題は人間には解けてもワシには無理でゲソ!
...
未だにこのタクティックが何をするのかさっぱりわからんでゲソ。
さっそくintroタクティックのソースコードを読んでみようじゃなイカ!
...
introタクティックのソースコードを読んでみたら、ワシもタクティックを作ってみたくなったでゲソ。
Coqをワシ好みに改造すれば、ひょっとしたら宿題が楽に解けるかもしれないじゃなイカ
```

　Coq全く知らないんですが、CoqわからないからCoqを改造するのはイカ娘さん的には普通なんですかね。
イカ娘さんはやっぱりすげーよ。  
これ絶対、これが必要な人にはかなり有用で貴重なやつですよね。


# IST(Internal Set Theory)入門(後編)（[\@dif_engineさん](https://twitter.com/dif_engine)）
　[簡約！？ λカ娘９](http://www.paraiso-lang.org/ikmsm/books/c90.html)に掲載されているIST(Internal Set Theory)入門(前編)の後編！
9巻はC92でも頒布されるみたいです。  
パチュリー, アリス, 魔理沙の魔法使い組がISTという集合論の一種について会合を開いて、魔理沙が教えてもらう形式で進みます。  
僕は前編を読んでいなくって理解していないのですが、
内容がマジだけど人物たちの対談形式なので読みやすく、読み物としても学術書としても面白かったです！


# 静的コード解析はいいぞ！（[\@master_qさん](https://twitter.com/masterq_mogumog)）
　CとJavaのコード検証器verifastの基本をイカ娘さんが教えてくれる！  
検証器の概念から基本的な使い方までを書いてあって、かつ読み物形式で読みやすい。  
verifastを使ってみるつもりの人から「検証器ってなに？」って人まで幅広く読めそう :D

- [GitHub - verifast/verifast: Research prototype tool for modular formal verification of C and Java programs](https://github.com/verifast/verifast)


# VeriFastチュートリアル（訳:[\@eldesh](https://twitter.com/eldesh), [\@master_q](https://twitter.com/eldesh), 著: Bart Jacobs）
　verifastの公式チュートリアルの翻訳。  
『静的コード解析はいいぞ！』は柔らかく表面を解説していたのに対して、
こちらは公式なので深く解説をしている。

- - -

　当日は一部の時間の間、売り子として僕も行くのでよろしくお願いします :dog2:  
元々λカ娘は興味が合って巻の物理版の方を買いたかったのですが、つてがなく諦めていました。
しかしこのような機会があり、大変ありがたいです！

　また、自分で技術本を書いて売り出すのも夢の１つでしたので、その大きな第一歩となります。
ヨッシャ！

　「会員名簿じゃなイカ？」の僕の欄は、ZZガンダムのジュドー・アーシタのセリフのオマージュです。
