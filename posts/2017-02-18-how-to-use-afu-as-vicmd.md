---
title: bindkey -vしてた人向けのauto-fu.zsh導入方法
tags: shell
---
　[このPR](https://github.com/hchbaw/auto-fu.zsh/pull/45)で色々教えてもらったので書いときます。

　まず今まで使ってたキーバインド名、`viins`は`afu`、`vicmd`は`afu-vicmd`という名前に割当たります。  
`afu`は補完機能付き`viins`、`afu-vicmd`は`afu`と`vicmd`（の代わり）を行き来するためのものです。


# auto-fu.zshの導入前後の、zsh設定の具体的な変更内容

Before
```sh
# Use viins
bindkey -v

# Vim nize
bindkey -M vicmd '_'  vi-first-non-blank
bindkey -M vicmd 'g_' vi-end-of-line

# Emacs nize
bindkey -M viins '^n' down-history
bindkey -M viins '^p' up-history
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^b' backward-char
bindkey -M viins '^f' forward-char
bindkey -M viins '^k' kill-line
bindkey -M viins '^u' backward-kill-line
bindkey -M viins '^d' delete-char
```

After
```sh
source /path/to/auto-fu.zsh

# Use afu-vicmd
zle -N zle-keymap-select auto-fu-zle-keymap-select

# Vim nize
bindkey -M afu-vicmd '_'  vi-first-non-blank
bindkey -M afu-vicmd 'g_' vi-end-of-line
bindkey -M afu '^['   afu+vi-cmd-mode
bindkey -M afu '^X^V' afu+vi-cmd-mode  # Escでafu-vicmdに行く

# Emacs nize insert mode
bindkey -M afu '^n' down-history
bindkey -M afu '^p' up-history
bindkey -M afu '^a' beginning-of-line
bindkey -M afu '^e' end-of-line
bindkey -M afu '^b' backward-char
bindkey -M afu '^f' forward-char
bindkey -M afu '^k' kill-line
bindkey -M afu '^u' backward-kill-line
bindkey -M afu '^d' delete-char
```

実際に`viins`と`afu`、`vicmd`と`afu-vicmd`が割り当たってるのがわかるかと思います。


# 最後に注意
　`zle -N zle-keymap-select auto-fu-zle-keymap-select`は既存の`zle-keymap-select`を上書きするので、他の設定がある場合は以下のようにしましょう。

```sh
function zle-keymap-select {
	auto-fu-zle-keymap-select "$@"
	shell_kawaii_build_prompt
	zle reset-prompt
}
zle -N zle-keymap-select
```
（この例はauto-fu.zshと[zsh-shell-kawaii](https://github.com/aiya000/zsh-shell-kawaii)の複合設定）
