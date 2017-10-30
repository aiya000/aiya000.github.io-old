---
title: Linuxで画面上に入力したキーを表示する（Like-macOS-keycastr）
tags: Linux プログラミング
---

- [GitHub - wavexx/screenkey: A screencast tool to display your keys inspired by Screenflick](https://github.com/wavexx/screenkey)
- [GitHub - naelstrof/slop: slop (Select Operation) is an application that queries for a selection from the user and prints the region to stdout.](https://github.com/naelstrof/slop)

　上記2つを入れ、設定をすることによって、悪くない感じになった。
設定はこんな感じ。

![prefs](/images/posts/2017-10-30-how-to-show-inputted-key-on-screen-with-linux/prefs.png)

　下記はArchでの現在のインストール方法。

```console
$ yaourt -S --noconfirm screenkey slop
```

　ただし、僕はfcitxの日本語入力切り替えを`Ctrl + Space`に設定していて、screenkey起動中はそれが効かなくなる。
