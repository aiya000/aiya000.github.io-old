---
title: xf86-input-wacomをインストールしたら依存関係ダメだったから直した
tags: Linux
---
xf86-input-wacomをインストールしようとしたら、xorg-serverとの依存関係でダメだった。

```sh
$ yaourt -S xf86-input-wacom
依存関係を解決しています...
衝突するパッケージがないか確認しています...
:: xf86-input-wacom と xorg-server が衝突しています。xorg-server を削除しますか？ [y/N] n
エラー: 解決できないパッケージの衝突が検出されました
エラー: 処理の準備に失敗しました (衝突する依存関係)
:: xf86-input-wacom と xorg-server が衝突しています (xorg-server<1.19)
```

xorg-serverをアップデートしたら直った。

```sh
$ yaourt -S xorg-server
依存関係を解決しています...
衝突するパッケージがないか確認しています...
:: xorg-server と xf86-input-evdev が衝突しています (X-ABI-XINPUT_VERSION)。xf86-input-evdev を削除しますか？ [y/N] y

パッケージ (4) libxfont2-2.0.1-1  xf86-input-evdev-2.10.3-1 [削除]  xf86-input-libinput-0.23.0-1  xorg-server-1.19.1-1
```

```sh
$ yaourt -S xf86-input-wacom
依存関係を解決しています...
衝突するパッケージがないか確認しています...

パッケージ (1) xf86-input-wacom-0.34.0-1
```
