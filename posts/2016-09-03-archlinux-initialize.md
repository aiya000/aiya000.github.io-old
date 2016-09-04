---
title: 僕がArchLinuxインストール直後にインストールしたパッケージ全集
tags: Linux
---

# 公式リポジトリより
+ 基本
    - tmux
    - git
    - rsync
    - pkgfile
    - mlocate
        - updatedb + locate コマンド
    - gvim
    - w3m
    - fzf

+ カーネル/ブートローダ 周り
    - grub
    - os-prober
        - grub-mkconfig時にWindows(とか？)を検知するために入れる
    - linux-lts
        - 今回そもそも最新linuxカーネルによって環境が死んだことによるOSのクリーンインストールなので、
          カーネルをlinuxパッケージじゃなくてlinux-ltsでalternateする
        - linuxの代わりにlinux-ltsを使うのは、linuxパッケージを削除した後にgrub-mkconfigすればいい
    - linux-lts-headers
        - VirtualBox使いたい時に(linux-ltsとセットで？)必要になる

+ X周り
    - xfce4-goodies
    - xorg-server
    - xorg-server-utils
    - xorg-xinit
    - dockbarx
    - network-manager-applet
        - networkmanagerをxfce4のパネルで使う用
    - xfce4-notifyd
    - gamin
        - ごめんこれがなんだかよく調べてない
    - xf86-input-synaptics
        - ノートPCのタッチパッドの挙動を正常にするため

+ IME周り
    - fcitx
    - fcitx-mozc
    - fcitx-gtk3
    - fcitx-configtool

+ ネットワーク周り + 依存関係
    - networkmanager
    - wifi-menu用
        - dialog
        - wpa\_supplicant
    - rfkill
        - ハードウェアの無線LANロック状態確認用
    - iwconfig
    - wireless\_tools
    - dhclient
        - 手動でdhcpサーバに問い合わせる用

+ AUR用
    - yaourt
    - namcap

+ その他
    - slim
    - haskell-stack
        - 現在、pacmanからインストールすると[これ](https://github.com/commercialhaskell/stack/issues/257)になるので
          yaourtで入れることが推奨されている
        - 僕の`ArchLinux 64bit`の場合、上記方法でも直らなかったので
          `sudo ln -s /usr/lib/libtinfo.so /usr/lib/libtinfo.so.5`というダーティハックした
    - ruby
    - python
    - lua
    - espeak
        - [喋らせる](/posts/2016-09-03-archlinux-initialize.html)
    - firefox
    - flashplugin
    - libreoffice
        - 安定版を使いたいのでlibreoffice-stillパッケージグループからインストール



# AURより
- ttf-ricty
    - 必須、綺麗なフォント
- dockbarx
- xfce4-dockbarx-plugin
    - xfce4で Windowsキー + \[1-9\] を使う用
- mecab
    - hs-goriraの開発で使ってる
- mecab-ipadic
    - mecab用辞書
