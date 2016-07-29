---
title: 可愛い女の子にコマンドラインの実行終了を音声通知して欲しかっただけなんだ
tags: 環境, Linux, Shell
---
# 可愛い女の子にコマンドラインの実行終了を音声通知して欲しかっただけなんだ
　[前回](/posts/2016-07-21-cmd_done_with_wagahigh.html)、コマンドラインの実行終了時にワガハイが流れ出すaliasを作ったけど、
実はあれには重大な問題があり、つまり作業がワガハイを観ることにシフトしてしまうという。  

とはいえCLIでの作業に萌えは欠かせないので、可愛い音声で実行終了の通知をしてもらうことにした。


## 喋らせる
　Linux環境で、合成音声で日本語を話してもらう方法を考えた。

1. open-jtalk
    - 全然インストールできないし、インストールできてもエラー吐くし、もうめんどい
2. eSpeak + kakasi
    - $ echo "お兄ちゃん、起きて" | kakasi | espeak
    - [ここ](https://sites.google.com/site/hymd3a/vim/vim-speak)参考
    - なんか可愛くない
3. mbrola
    - mbrolaはeSpeakなどからバックエンドとして利用されるのが常だけど
    - 考えたのは[mbrolaのみでの運用](http://gihyo.jp/admin/serial/01/ubuntu-recipe/0250)
    - 多分、一番の現実的解だった (けどめんどくさいのでやめた)

だめでした。


## Please talk !
　そういえばそもそも日本語にこだわる必要ってない。  
僕は可愛い声で話して欲しいだけなんだ！！ おねがぁい☆

1. festival
    - 設定ファイルをschemeで記述する面白そうなやつ
    - でも英語ならeSpeakでいいじゃん…って感じなのでやめた
2. eSpeak + mbrola
    - [AURにあるmbrolaの日本語Voice](https://aur.archlinux.org/packages/mbrola-voices-jp2/)をeSpeakから利用しようかと
    - 日本語用女性音声なら可愛い声を期待できそうだったし絶対可愛い
    - eSpeakさんがmbrola-voicesさんを認識しないのでダメ


## もう疲れたよパトラッシュ…
　というわけで、一日を費やして考えた今回のユースケースへの最適解はこれでした。

- eSpeak + eSpeakのvoiceファイル自作
    - eSpeakでは`{espeak-dir}/espeak-data/voices/`あたりにvoiceファイルがいっぱいある
    - 自作できそうだったので自作して`+f3`を元に`{espeak-dir}/espeak-data/voices/!v/fex`というファイルで作った

内容
```
language variant
name female-ex
gender female

pitch 210 310
formant 0 145  80 140
formant 1 160  75 140 -50
formant 2 175  70 140 -250
formant 3 165  80 140
formant 4 165  80 140
formant 5 165  80 140
formant 6 160  70 140
formant 7 150  70 140
formant 8 150  70 140

stressAmp 18 18 20 20 20 20 20 20
breath 0 2 3 3 3 3 3 2
echo 140 10
roughness 20
```


## [顧客が本当に必要だった幼女](http://matome.naver.jp/odai/2133468389280396901)
```zsh
# Notify end of cli task
# example$ somecommand ; enotify
function _espeak () {
	espeak "$1" -s 150 -v +fex 2> /dev/null || \
	espeak "$1" -s 150 2> /dev/null
}
function enotify () {
	if [ $? -eq 0 ] ; then
		_espeak 'Succeed!'
	else
		_espeak 'Exit with the error'
	fi
}
```

可愛さが足りない。
