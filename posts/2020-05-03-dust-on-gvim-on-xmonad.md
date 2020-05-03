---
title: XMonad上のGVimで画面にゴミが出る場合は'renderoptions'
tags: Vim
---

## 解決策

```vim
set renderoptions=type:directxset ambiwidth=double
```

## 問題

僕は今、Windows上で最強のLinux環境を求めて、旅をしています。
現在は次のような環境です

- Windows 10 Home
    - VirtualBox 6.1.2
        - ArchLinux

ArchLinuxのウィンドウマネージャーにはxmonadを使っています。

- [aiya000/xmonad-config: A windows manager implementation that is implemented by xmonad as a window manager buliding library.](https://github.com/aiya000/xmonad-config)

その上でGVimを起動すると、**<C-f>でVimウィンドウ移動したときに、ゴミが画面に残るようになってしまいました**。

## 解決策

renderoptionsを設定するだけでよいようです。

以上！

## 参考URL

- [Windows版gVimでConsolas+メイリオを使う - Qiita](https://qiita.com/7680x4320/items/f8353e7bc7593b7f4ddc)
