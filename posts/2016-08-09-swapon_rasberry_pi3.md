---
title: ラズパイスワップマシマシノンデバイスで
tags: RasberryPi, 環境, Linux
---
# ラズパイスワップマシマシノンデバイスで
　なぜかラズパイのデフォルト仮想メモリサイズが100Mだったので足りない。  
物理メモリが1Gなようなので、仮想メモリも1G\~2Gが順当だろうて。


## 参考ページ
- [Connecting The Dots: Raspberry PiのSwapファイルの容量を変更する](http://tai1-mo.blogspot.jp/2013/06/raspberry-piswap.html)
- [linux スワップ（swap）領域の作成](http://kazmax.zpp.jp/linux_beginner/mkswap.html)
- [65./etc/fstabについて その2](http://www.linux-beginner.com/linux_kihon65.html)
- [余計なディスク書き込みを軽減させよう～noatime編～](http://www.itmedia.co.jp/help/tips/linux/l0298.html)


## 実行するやつ
```console
$ cd {1GBの仮想メモリファイルを置く場所,できればメインのHDDやSSD以外がいいと思う}
$ sudo dd if=/dev/zero of=swap bs=10M count=100
$ sudo mkswap swap
$ sudo swapon swap
$ sudoedit /etc/fstab  # {1GBの仮想メモリファイルを置く場所,できればメインのHDDやSSD以外がいいと思う}/swapを再起動後に自動マウントさせるようにする
```

　僕の場合、ラズパイの編成は8GBのmicroSDと32GBのUSBメモリという感じにしているので、
USBメモリをもう抜かないつもりでswapファイルをUSBメモリに置いた。  
なのでfstabにはUSBメモリとswap両方をマウントするようにした。


## Zaurus懐かしい
　こういう作業は昔、Zaurusでいっぱいやっていたので楽しい。  
現代のZaurusは、Rasberry Piなのかもしれない！ :P
