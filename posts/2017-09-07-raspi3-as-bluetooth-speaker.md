---
title: メモ：Rasberry PI 3 model B+をBluetoothスピーカーにした
tags: Linux
---
　僕はbluetoothスピーカーが欲しかった。
でも僕の部屋には、コンセントから電源が供給されるイヤホンジャック接続のスピーカー（アナログスピーカー？）
が既にあり、買うのもなんかもったいなかった。

　なのでRasberry PI 3 model B+（以下raspi3）にそれを繋いで、raspi3をbluetoothスピーカーにできないかと思って、
やってみたらできた。

　そこらの情報は検索するとうんさか見つかるので、これは私的なメモになる。

- - -

　まずはここの`各種パッケージ導入`以下を行った。

- [audio - Setup Raspberry Pi 3 as bluetooth speaker - Raspberry Pi Stack Exchange](https://raspberrypi.stackexchange.com/questions/47708/setup-raspberry-pi-3-as-bluetooth-speaker)

この時点でAndroidからraspi3に接続はできるも、スピーカーとして使えていなかった。
今思うと多分、以下の`pair`をしてなかっただけだと思う。

```consle
$ sudo bluetoothctl
[NEW] Controller YY:YY:YY:YY:YY:YY raspberrypi [default]
[NEW] Device XX:XX:XX:XX:XX:XX Doogee X5 Max Pro
[bluetooth]# power on
Changing power on succeeded
[bluetooth]# agent on
Agent registered
[bluetooth]# default-agent
Default agent request successful
[bluetooth]# discoverable on
Changing discoverable on succeeded
[CHG] Controller YY:YY:YY:YY:YY:YY Discoverable: yes
[bluetooth]# pairable on
Changing pairable on succeeded
[CHG] Device XX:XX:XX:XX:XX:XX ServicesResolved: yes
[Doogee X5 Max Pro]# trust XX:XX:XX:XX:XX:XX
Changing XX:XX:XX:XX:XX:XX trust succeeded
[CHG] Controller YY:YY:YY:YY:YY:YY Discoverable: no
```

　もし他の機器から接続した時に、`Connected: yes`が表示された後にすぐ`Connected: no`になってしまうようであれば、
（pulseaudioデーモンが起動されていない可能性があるので）`$ pulseaudio -vD`などするといいかもしれない。

　結局こっちに準拠してみた時点で、Androidからraspi3へのスピーカーとしての接続ができて、音声出力が確認できた！
- [audio - Setup Raspberry Pi 3 as bluetooth speaker - Raspberry Pi Stack Exchange](https://raspberrypi.stackexchange.com/questions/47708/setup-raspberry-pi-3-as-bluetooth-speaker)

　一番悩んだのは、上記の`ragusa87 script`の`AUDIOSINK`に何を指定するのか、これであってるのか？
ということだったけど、確かに以下であっていた。

```console
>>> pactl list sources short
0       alsa_output.platform-soc_audio.analog-stereo.monitor    module-alsa-card.c      s16le 2ch 44100Hz       SUSPENDED
```

`alsa_output.platform-soc_audio.analog-stereo.monitor`
