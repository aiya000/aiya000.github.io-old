---
title: ことり、穂乃果と一緒に学ぶHaskell（入門）その5「様々な文字列型とIsStringそしてOverloadedStrings」
tags: ラブライブ！で学ぶ, ことり、穂乃果と一緒に学ぶHaskell, Haskell
---

- [前回 - ことり、穂乃果と一緒に学ぶHaskell（入門）その4「型クラスの定義と実装」](./2017-05-27-learn-haskell-with-muse.html)
- [記事一覧 - ことり、穂乃果と一緒に学ぶHaskell（入門）](/tags/ことり、穂乃果と一緒に学ぶHaskell.html)
- [更新履歴 - μ'sと一緒に学ぶHaskell](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)


# Happy☆Birthday！
ことり「穂乃果ちゃん、ハッピーバースデー！」  
海未「穂乃果、誕生日おめでとうございます！」  

:tada:

穂乃果「ことりちゃん、海未ちゃん、ありがとー！」  

- - -

ことり「今日は穂乃果ちゃんの誕生日なので、海未ちゃんもお呼びしたよ♪」  
海未「私はHaskellをやっているわけではありませんが、前々からお二人だけで勉強会をしているとのことで。
　穂乃果の誕生日でしたし気になっていたので、お祝いがてらお邪魔させていただきます」  

穂乃果「ごめんね海未ちゃん、別に海未ちゃんを蔑ろにしてたわけじゃなかったんだけど。
　ちょうどことりちゃんがHaskell経験者だったから教えて貰ってたんだ！」  
海未「気にしていませんよ。
　どちらかというと気になっているのは、穂乃果がちゃんと勉強しているのか……ということですね」  
穂乃果「し……してるもん！！　わ、割と！」  

海未「割と、ですか。　ふふ、冗談ですよ。　ことりもついていますし、心配はしていません」  


# OverloadedStrings
海未「さて私は傍らで見学していますので。
　今日は誕生日パーティーの時間になるまで勉強会をするんでしたよね」  
穂乃果「うん、雪穂が『料理できるまで遊んでて』って言ってたから、Haskell教えてもらおうと思って！」  

ことり「今日は型クラスの応用のうち一つである、`IsString`型クラスと`OverloadedStrings`GHC拡張についてやっていくよ」  
穂乃果「型クラスは`deriving`か`instance`で実装するんだったよね。
　`IsString`は`deriving`できるの？
　それと……GHC拡張って？」  

ことり「`IsString`は`deriving`できないから、手動で`instance`する必要があるんだ。
　でもね、`IsString`は`Show`や`Eq`などと違って、そんなには自分で作ることはあんまりないかなぁ」  

ことり「GHC拡張……っていうのは、Haskellのコンパイラの一つである『Glasgow Haskell Compiler』が独自実装する、Haskellの言語規格にはない機能を提供するもののことだよ」  

- [Home — The Glasgow Haskell Compiler](https://www.haskell.org/ghc/)

穂乃果「？？？」  

ことり「穂乃果ちゃんはHaskellの環境にhaskell-stackを使ってるよね？
　haskell-stackはコンパイラとして、デフォルトでGHCを使ってるんだ。
　穂乃果ちゃんは何をせずとも、普通にhaskell-stackを使ってれば、GHC拡張を使えるよ♪」  

穂乃果「へ〜。　ってことは、GHC以外を使ってる場合はGHC拡張は使えないのかな？」  
ことり「それはそう……なんだよね〜。
　まあ今の主流はGHCだし、GHCが破綻したりしない限りは大丈夫なはずだから、そんなに気にしなくても平気かな」  

ことり「昨今のHaskellはよくGHC拡張に依存しすぎているって言われたりもするけど、
Haskell98レポート『あらすじ>言語とライブラリ』の章に書いてあるHaskellの理念からして
GHC拡張はHaskellの正当な進化系だと思うんだ。
心配ないよ♡」  

- [Haskell98レポート - あらすじ](http://www.sampou.org/haskell/report-revised-j/preface-jfp.html)
- [The Haskell 98 Report - Preface](https://www.haskell.org/onlinereport/preface-jfp.html)

穂乃果「なるほどね？」  


## ByteStringとText
ことり「今回はHaskell特有の話になるから、Javaの話はあんまり交えられないかも……」  
ことり「逆に言うとJavaと対比することもないくらいで、そんなに複雑な話ではないんだ」  

ことり「前提知識として、Haskellには大きく分けて3つ、細かく分けて7つくらいの、文字列を表す型があるんだ」  
穂乃果「ななつ……どうゆうことなの！？」  

ことり「うーん、かつてのHaskellが`String`で日本語とかを扱うことが苦手だったっていう歴史的経緯が含まれたりもするんだけど……」  
ことり「実は`String`って、単なる`[Char]`の別名でね。　これは`String`をリストとしての側面を与える代わりに、処理効率はよくないとされてるんだ。　一般的には。」  

```haskell
type String = [Char]
```

ことり「それを改善するために作られたのがこの2つ」  

- [text: An efficient packed Unicode text type.](https://hackage.haskell.org/package/text-1.2.2.2)
- [bytestring: Fast, compact, strict and lazy byte strings with a list interface](https://hackage.haskell.org/package/bytestring-0.10.8.2)

ことり「その2つの中にそれぞれLazy版、Strict版が含まれる」  
ことり「`ByteString`に至ってはそれに加えて`Char8`モジュールがあるよ」  

- Prelude(String)
- Data.Text （Strict版）
    - Data.Text.Lazy （Lazy版）
- Data.ByteString （Strict版）
    - Data.ByteString.Lazy （Lazy版）
    - Data.ByteString.Char8 （Strict版亜種）
    - Data.ByteString.Lazy.Char8 （Lazy版亜種）

ことり「一般的なユースケースでは……Strict版の方が処理効率がよくて、その代わりLazy版の方がHaskell特有の評価戦略が活かせるって感じかな」  

穂乃果「評価戦略……授業で習ったような……。
　遅延評価ってやつ？」  
ことり「それそれ♪
　正確に言うと、必要時評価で名前呼びでメモ化されるの！」  

穂乃果「？」  
ことり「えーと……ごめんね。　これについて語るには、今回の枠じゃちょっと時間が足りないかなあ……」  
ことり「でも大丈夫。　わたしは今のHaskellなら、不都合がない限り`String`だけで良いかなって思うよ。　O(n^m)とかのループを何回もも回すとかじゃない限りはね♪」  

穂乃果「えーと、`String`使っていいの？」  
ことり「うん♪」  


### ByteString
穂乃果「`ByteString`の`Char8`ってなに？」  

- Data.ByteString
    - Data.ByteString.Char8

ことり「えっとね、`Char8`じゃない`ByteString`が、`Char8`の`ByteString`のオリジナルになっているの」  

ことり「`Char8`の`ByteString`が`String`と同じように文字型として`Char`を扱うのに対して、
`Char8`じゃない`ByteString`は文字列型として`Word8`を使うよ」  
ことり「`Word8`は8-bitで表現できるうちの整数……つまりutf-8の文字コードを現してて……」  

ことり「それを列としたものが`Char8`じゃない方の`ByteString`」  
ことり「またそれをラップして、`Char`を扱うようにしたのが`Char8`の`ByteString`だよ♪」  

- [Data.ByteString](https://hackage.haskell.org/package/bytestring-0.10.8.2/docs/Data-ByteString.html#t:ByteString)

穂乃果「なるほど。
　utf-8文字列`ByteString`と、そのラップの`Char8.ByteString`なんだね！」  
ことり「そうそう♪」  


## OverloadedStringsとIsString
ことり「今度は`IsString`について」  

ことり「`IsString`……はね。　ここで出てきた`ByteString`と`Text`が`IsString`インスタンスなんだ」  
穂乃果「ほむ……`IsString`ってどんな型クラスなの？」  

ことり「Javaで文字列型っていうと、普通はString型だけでしょ？　こうやって簡単に代入できる」  

```java
String powerful = "wao-wao";
```

ことり「でもHaskellでは`Text`や`ByteString`みたいに文字列型を自由に定義できることを許されているんだ」  
ことり「そこで問題になるのが、`"wao-wao"`みたいなリテラルが`String`型である。
　ってところなんだ」  

ことり「`String`型の名前（変数）を定義するには、こうするよね」  

```haskell
powerful :: String
powerful = "wao-wao"
```

ことり「でも同じことを`Text`や`ByteString`に対してやると、普通はこんな感じになっちゃうの」  

```haskell
import Data.ByteString.Char8 (ByteString) -- ByteStringを使いたいならChar8（or Lazy.Char8）がおすすめだよ！
import Data.Text (Text)
import qualified Data.ByteString.Char8 as B
import qualified Data.Text as T

-- B.pack :: String -> ByteString
powerfulB :: ByteString
powerfulB = B.pack "wao-wao"

-- T.pack :: String -> Text
powerfulT :: Text
powerfulT = T.pack "wao-wao"
```


### OverloadedStrings
穂乃果「`pack`っていう関数が、`String`からそれぞれへの変換をしてるんだよね、これ」  
ことり「その通り。
　`String`が`pack`無しで扱えるのに対して、`ByteString`と`Text`は`pack`が必要になっちゃう」  

ことり「せっかくHaskellが文字列型を自由に定義することを許してるのに、これは面倒だよね」  

ことり「そこでファイルの**先頭**に、LANGUAGEプラグマって呼ばれるものを書いてあげると、なんと`pack`が必要なくなるの☆」  

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Data.ByteString.Char8 (ByteString)
import Data.Text (Text)
import qualified Data.Text.IO as TIO

powerfulB :: ByteString
powerfulB = "wao-wao"

powerfulT :: Text
powerfulT = "wao-wao"

-- TIO.putStrLnはTextを画面に出力する
-- TIO.putStrLn :: Text -> IO ()
main :: IO ()
main = TIO.putStrLn ("powerful day !" :: Text)
```

### IsString
穂乃果「えっ、`"wao-wao"`がそれぞれ違う型の値になるってこと？？？」  
穂乃果「それってすごいね！　……でもなんだろう、なんだかわからないんだけど、ちょっともやもやする……」  

ことり「多分、なんだけど。　Javaで`"wao-wao"`っていうリテラルを使うとそれは必ず`String`型になる」  
ことり「でも`OverloadedStrings`を導入したHaskellでは、それはどの文字列型になるかわからない。
　……っていう不安なのかも」  
ことり「例えば、ある文字列の後ろに`"ラブアローシュート！"`を付け足す関数`shoot`に`"wao-wao"`を適用した形`shoot "wao-wao"`。
　その`shoot`の型を`Text -> Text`にすべきか`ByteString -> ByteString`にすべきか、っていうのがわからないんじゃないかな？」  

海未「！？」  

穂乃果「そうなのかな？」  
ことり「きっとそう！　わたし、穂乃果ちゃんの気持ちならいつでもわかるから！」  

穂乃果「えっ」  

ことり「それはね穂乃果ちゃん、わたしが穂乃果ちゃんをいっぱい想ってるから☆☆……
穂乃果ちゃんの思ってること、ことりはぜーんぶわかるんだよ♪」  

穂乃果「……それは嬉しいんだけど……えっとえっと、今はそっちじゃなくって……」  

ことり「ふふふ。
　大丈夫だよ、そういう不健全さはHaskellには（ほとんど）ないの！」  

ことり「`OverloadedStrings`を使った後は、文字列リテラルは`IsString a => a`として扱われます」  
ことり「具体的には、以下を可能にするよ」  

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Data.String (IsString)
import qualified Data.Text.IO as TIO

powerful' :: IsString a => a
powerful' = "wao-wao"

main :: IO ()
main = TIO.putStrLn powerful'
```

ことり「そして`TIO.putStrLn powerful'`時点で`powerful'`が`Text`として推論されます！
　`TIO.putStrLn`が`Text -> IO ()`だからね♪」  

穂乃果「なるほど……リテラルが多相的な型として扱われるんだ。
　なんか少し変な感じだけど、さっきの変な感じはなくなったなあ」  

穂乃果「すごいねー。　ありがと、ことりちゃん！」  
ことり「えっへへ、どういたしまして！」  


# おはようPowerful day!
海未「ことり、穂乃果。　雪穂から伝言です。　『準備できたよ〜』とのことです」  
ことり「……ということで、ちょうどいい感じのタイミングで終われたね♪」  
穂乃果「今日もありがとう、ことりちゃん！　海未ちゃんも、伝言ありがと！」  

………


# 誕生日おめでとう！
雪穂「はい、お姉ちゃん。　誕生日プレゼントだよ！　最近、Haskell頑張ってるみたいだから……」  
穂乃果「！　『
[すごいHaskell楽しく学ぼう！](https://www.amazon.co.jp/%E3%81%99%E3%81%94%E3%81%84Haskell%E3%81%9F%E3%81%AE%E3%81%97%E3%81%8F%E5%AD%A6%E3%81%BC%E3%81%86-Miran-Lipova%C4%8Da/dp/4274068854/ref=tmm_pap_swatch_0?_encoding=UTF8&qid=&sr=)
』だ！　すごい読みやすいっていう話だし、嬉しいよ雪穂ー！」  

ことり「わたしからも誕生日プレゼントだよ、はい♪」  
穂乃果「わー、『
[プログラミングHaskell](https://www.amazon.co.jp/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0Haskell-Graham-Hutton/dp/4274067815)
』だ〜〜！」  
ことり「これはちょうど『すごいHaskell楽しく学ぼう！』を読んだ後に読むのがいいかも！」  

海未「それではこちらは、私からです。　最近はとてもよく勉強できているようですから」  
穂乃果「海未ちゃんからは何かなー……。　…………こ……これは……まさか」  

『[型システム入門](https://www.amazon.co.jp/%E5%9E%8B%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E5%85%A5%E9%96%80-%E2%88%92%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E8%A8%80%E8%AA%9E%E3%81%A8%E5%9E%8B%E3%81%AE%E7%90%86%E8%AB%96%E2%88%92-Benjamin-C-Pierce/dp/4274069117)
-プログラミング言語と型の理論−』

穂乃果「これ……初学者には結構難しいって聞いたことあるんだけど……。
　海未ちゃん？　私は……私には……これは重いんじゃないかなあ。
　『私からのプレゼントは不服ですか？』……って？
　違う……違うよ、そうじゃないけど……そうじゃないけど……
うああ、ありがとう海未ちゃん、嬉しいよーーーーー！！！」  


# 参考にしたページだよ☆

- [WAO-WAO Powerful day!　　Printemps - 歌詞タイム](http://www.kasi-time.com/item-77730.html)


# 備考
　型システム入門は丁寧に書かれていて、親切な構成になっています。
その上、理解に必要な前提知識も、ほとんどがその中に書かれています。
穂乃果もきっと、読みだしたらこの素晴らしさをわかってくれることでしょう。
皆様も是非、読んでみてはいかがでしょうか。

園田海未より
