---
title: xmonadが最高のウィンドウマネージャである理由
tags: Linux
---
この記事は僕がxmonadの利点を思いつくたびに更新されていきます。  
いくらでも思いついちゃうからね :D


# xmonadとは
[こんなん](https://ja.wikipedia.org/wiki/Xmonad)


# 一般的利点
- タイル型である
- マウスめっちゃ使わなくなる
- 設定がチューリング完全 (設定次第でなんでもできる)
    - 例えばworkspaceの切り替えを`Super + [1-9]`に割り当てるなどのような規則のある設定とかを、
      愚直に書かずにプログラミングによって生成、設定できる
- [xmonad-contrib](http://xmonad.org/xmonad-docs/xmonad-contrib/)というxmonadのアドオンがあって
  誰でもxmonadをカスタマイズできるようになっている
    - [xmonad標準](http://xmonad.org/xmonad-docs/xmonad/)にはないレイアウトとかツールが有志によって提供されている
- キーマッピングをxmonadで設定できるので、autokeyなどのツールが不要
- 結構枯れている


# 個人的利点
- プログラマブルなツールである
    - 自分でどこまでも便利にできる
- Haskellで設定できる
    - Haskellの局所的で実用的知識がつく
- xmonad-contribのAPIはなんかもうすごいいっぱい項目があるので、めっちゃ読める


# 僕が最近設定したいい感じのこと
- `XMonad.Layout.SubLayouts`を使ってレイアウトを`TwoPane + Tabbed | Grid + Tabbed`にした
    - 1つのworkspaceでTwoPaneとGridを切り替え可能かつ、Tabbed(firefoxのタブみたいな感じのレイアウト)と併用できる

![](/images/posts/2016-09-29-xmonad_is_best_the_wm/ex-tabbed-twopane.png)

- `ImageMagick, dunst, notify-send, espeak`を使って、いい感じのスクリーンショットを取るやつを実装した
