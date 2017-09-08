---
title: メモ：これでraspi3のイヤホンジャックから音が出た
tags: Linux
---
　ラズパイのイヤホンジャックを初めて利用してみたのだけど、aplayしても音が出ない。

```console
$ cd /opt/vc/src/hello_pi
$ sudo ./rebuild.sh
$ ./hello_audio/hello_audio.bin
```

とすると

```
failed to open vchiq instance
```

と言われた。

　こうするとできた。

```console
$ echo 'SUBSYSTEM=="vchiq",GROUP="video",MODE="0660"' | sudo tee /etc/udev/rules.d/10-vchiq-permissions.rules
$ sudo gpasswd -a aiya000 video
$ sudo gpasswd -a pi video
$ sudo reboot
$ /opt/vc/src/hello_pi/hello_audio/hello_audio.bin
```


# 参考
- [ラズパイのカメラモジュールでfailed to open vchiq instanceエラー - Qiita](http://qiita.com/katsew/items/5dbb2be552167f4dc104)
- [Raspberry Piで音を出すまで - Qiita](http://qiita.com/plsplsme/items/57b8d79d3725497fd69b)
