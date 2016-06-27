---
title: HaskellでTwitterにTweetする
tags: プログラミング, Haskell
---
# HaskellでTwitterにTweetする

## About

* 成果物
    - [hs-gorira (GitHub)](http://github.com/aiya000/hs-gorira)のcommit 8a2a7bddb33303dd8b4aa5adb4dc7f7711ac47bd
    - [あいやゴリラ (Twitter)](https://twitter.com/aiya_gorira)

* 参考URL
    - [HaskellでTwitterにpostする - yunomuのブログ](http://yunomu.hatenablog.jp/entry/2012/05/13/210629)
    - [Haskell で OAuth - EAGLE 雑記](http://d.hatena.ne.jp/eagletmt/20100820/1282253083)
    - [Haskellのコード150行で, Twitterに投稿するだけのクライアントを作ったよ - プログラムモグモグ](http://itchyny.hatenablog.com/entry/20110911/1315741853)
    - [GET oauth/authorize](https://dev.twitter.com/oauth/reference/get/oauth/authorize)

* Haskellの超便利なやつ
    - [Stackage](https://www.stackage.org/)
        - Hoogleみたいに型での検索とかできる
        - なぜかHoogleで各hackageの関数が検索できなかったのでこちらを使用した


## Detail

　成果物のコードのベースつまり大部分は[yunomu氏のモノ](http://yunomu.hatenablog.jp/entry/2012/05/13/210629)です、感謝 :P

* したこと
    - コードを少し整理した ( 少し )
        - 動かなくなっていたところを直した
        - Twitter API 1.1用のコードにした ( 少しの書き換え )
        - Readインスタンスの型の値を外部ファイルから読み込んでみた ( ちゅーんさんの教え、Thanks :P )
    - Conduitがどのようなものなのかを少し勉強した ( 少し )
    - 美しい型の海を泳ぐ ( 綺麗 ( モナドトランスファーわかってません ) )
        - Conduitの($$+-)関数を探し回っていた (Source型とResumableSource型の問題)
        - すごい人が「モナドトランスファーはliftIOするとなんかIOが動く」って言ってたの、本当だ…って思った

　面白かった話の一つとして、設定を外部ファイルに持つときに僕はyamlを使おうとしていたのだけど、  
ちゅーんさんが「Haskellで読み込みたい設定値がReadインスタンスの型の値なら、read(とreadFile)だけで読み込める」(要☆約)  
って言ってたから「確かに！！」ってなったというのがありました。
すごいです。 しゅごいい。

こんなん。

```haskell
readFooSetting :: IO SomeType
readFooSetting = do
  foo <- read <$> readFile "path/to/config_file"
  return foo
```

　設定値を1つのファイルにまとめなくていいケースであれば、yamlやjsonすらいらないね！！
すごい！！


## ほげ

　そういえばyunomu氏のブログ記事にsignOAuth関数の型にMonad__Unsafe__IOというのがあったけれど、
今のバージョンだとちゃんとUnsafeじゃなくなってたのでよかった。(大丈夫)
