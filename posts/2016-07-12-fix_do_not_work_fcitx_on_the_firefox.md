---
title: Firefoxをアップデートしたらfcitxが動かなくなったので
tags: 環境
---

# Firefoxをアップデートしたらfcitxが動かなくなったので
## 解決
　Firefoxのバージョンとしては47.0.1だけど、多分43より後のバージョンでは発生する…うちの環境では。

* うちの環境
    - Arch Linux 64bit
    - pacman -Syu したばかり

解決方法としては、`~/.xinitrc`に以下を記述します。 それだけ。

```zsh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
```

僕の`.xinitrc`はこんな感じ。 exec startxfce4の後にexportを書いててちょっとハマった。

```zsh
#!/bin/sh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
exec startxfce4
```

[参考](https://wiki.archlinuxjp.org/index.php/fcitx)

- - -

最近いきなりArchが暴れ始めている。  
あとはFirefoxだけで音がならない問題を修正しなければ。
…これのせいで、ちょくだいさんのエロゲ放送がほとんど見られなかった…。
