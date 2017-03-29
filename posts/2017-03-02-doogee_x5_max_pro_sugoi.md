---
title: DOOGEE X5 Max Proがコスパ最強で最高の端末
tags: Android
---
　半年前くらいからDOOGEE X5 Max Proを使っているのですが、ようやくおすすめできる環境になったのでおすすめします。  
↓↓↓

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=aiya00003-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B01IHN4YCQ&linkId=feef6789588f5c6ac316ee7c50a7a9a9&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr"></iframe>
<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=aiya00003-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B01J9IQ90S&linkId=10d26b5b0d9d152566b46d2e2bc1f67f&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr"></iframe>
<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=aiya00003-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B01MCUL371&linkId=1600ec59bd3023efb963cf86b1e4f723&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr"></iframe>
<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="https://rcm-fe.amazon-adsystem.com/e/cm?ref=qf_sp_asin_til&t=aiya00003-22&m=amazon&o=9&p=8&l=as1&IS2=1&detail=1&asins=B015J44R0U&linkId=82100b1cccf8d7950fbdd5a1ecb3770c&bc1=000000&lt1=_blank&fc1=333333&lc1=0066c0&bg1=ffffff&f=ifr"></iframe>

↑↑↑

全て合わせて、本日時点では`14,578`円。  
低価格マニアにとって最高の逸品になってます。


# DOOGEE X5 Max Proの何がいいの？
　コスパが最高。 
iPhone6 Plusから乗り換えDOOGEE X5 Max Proを使っていますが、ほとんど性能的不満を感じません。 
たまに動作が遅くなりますが、どんな時におそくなったか覚えてないくらいには瀕発しません、全然しないよ。
（僕はやらないのでわからないけど、激しいゲームとかをすると違うのかな）  
Greenifyが良くしてくれる。

具体的なスペックから見て、大丈夫だと思う。 へーきへーき！  
めっちゃいいよ。

- 価格: `11,500`
- RAM: `2GB`
- ROM: `16GB`
- CPU: `MTK6737 1.3GHz (Quad core)`
- OS: Android6.0 （後述にて、Android6.0.1に書き換えるけどね）
- バッテリー: `4000mAh`
- 画面: 5インチ
- 特筆: 指紋認識


# DOOGEE X5 Max Proの何が悪いの？
　初期OSがマルウェアだらけ。  
[NoRootファイアーウォール](https://play.google.com/store/apps/details?id=app.greyshirts.firewall&hl=ja)と、
アプリのインストールを検出する用の[AVL（アンチウイルス）](https://play.google.com/store/apps/details?id=com.antiy.avl&hl=ja)と、
Android6標準のアプリ凍結機能
を使って様子を見ていましたが、ファイアウォールを外すと勝手にへんなアプリをインストールしてきたりしていてやばい。

あとは、カメラの画質かな。  
でも後述のCyanogenModにしたら良くなった。 カメラappの性能かな？


# やばくない？ どうするの？
　CyanogenModという最強で最高のAndroidがあるので、それをインストールします。  
CyanogenModは完全にOSSで、実際安全です。  
ちなみにAndroid7にしたければ、LineageOS 14がインストールできますよー。

- CyanogenModについて
    - [CyanogenMod - Wikipedia](https://ja.wikipedia.org/wiki/CyanogenMod)
    - [CyanogenMod - GitHub](https://github.com/CyanogenMod)


# 導入
　詳細な手順は、僕も参考にした各リンク先を見てもらうとして、こんなん。  
安心してね、WindowsやmacOSが無くても、ArchLinuxでもちゃんとできたよ。

1. [adbとfastbootでTWRPを叩いてバックアップする](http://andmem.blogspot.jp/2014/08/twrp-boot.html)
    - 僕はこれをやらないでいきなりROMにTWRPをインストールしたので、internal storage (SD Card) のデータが開けなくなった
        - Android6がinternal storageへ施した、なんらかの暗号化アルゴリズムのキー値が予測できる時代が来れば復号化できるし、へーきへーき！
2. [TWRPをROMにインストールする](https://forum.xda-developers.com/android/development/doogee-x5-max-pro-root-recovery-ota-t3501830)
    - `fastboot flash recovery recovery.img`を実行した一回目はなぜかうまくいかなかったけど、二回目はうまくいったので良かった
3. [CyanogenMod 13をROMにインストールする](http://www.getdroidtips.com/install-unofficial-cm13-doogee-x5-max-pro/)
    - これをインストールしたら、一緒にGAPPSも入ってくれた


# めっちゃ楽しい
　従来のAndroid（AOSPではなくx5max_proのOfficial ROM）だと

- LINEを常にバックグラウドで立ち上げておかなきゃ、通話の通知がこない
- 050Plusをフォアグラウンドで立ち上げておかなきゃ、着信の通知がこない

っていうのがあったけど、直ってくれたよ。  
killとGCの扱い方の問題？？  
その他もろもろ挙動が怪しかった部分やもろもろ性能周りも改善された気がするし、最高。  
ただ、WifiテザリングがONにならなくなった……。 僕の問題かな？

CyanogenModをDOOGEE X5 Max Pro用にビルドしてくれた人には最高の感謝……🙌

CyanogenMod入れた後は、めっちゃ楽しくて数日間ずっとDOOGEE X5 Max Proで遊んでました。
遊んでます。

今は、SD Cardをext4にしてexternal storageとして扱えないか画策してる。  
なんか最近のAndroidではfstabの扱いが変わったのかな、{/system,}/etc/{vold.,}fstabがないんだよね…。

楽しい！ いいぞ〜！
