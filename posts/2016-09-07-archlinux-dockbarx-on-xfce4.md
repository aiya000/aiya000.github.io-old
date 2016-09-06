---
title: xfce4でWindowsのWin+\[1-9\]キーみたいな切り替えを実現する
tags: Linux
---

![kore](/images/posts/2016-09-07-archlinux-dockbarx-on-xfce4/kore.png)

　Windows環境では、複数のGUIアプリを立ち上げている際に`Winキー + 1~9キー`でウィンドウを切り替えることができる。  
便利なので僕のArchLinux + xfce4環境にも導入する。

# インストール
　AURから`dockbarx`と`xfce4-dockbarx-plugin`を入れる。
```console
$ yaourt -S dockbarx xfce4-dockbarx-plugin
```


# 設定
　後はxfce4のパネルを右クリックしてDockbarXを追加して、自由にdockbarxの設定をしたりなどする。
