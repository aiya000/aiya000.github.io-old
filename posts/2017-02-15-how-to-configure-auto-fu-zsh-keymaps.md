---
title: auto-fu.zshを使う際のzshのviキーバインド設定方法
tags: Linux, zsh
---
　[auto-fu.zsh](some)とはzshのneocomplete.vim（deoplete.vim）みたいなものです（すごいてきとう）。  
これを導入するとCLI環境がなんだかIDEチックになって格好いいのですが、もともと設定していた`bindkey -v`と`bindkey -M viins foo`、`bindkey -M vicmd bar`がうまく効かなくなってしまいました。


# 具体的修正内容
　詳細は[こちら](https://github.com/aiya000/dotfiles/commit/b3f564f33478d1c5fc2a98bb4850c00fd43db526)。

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

# My taste
bindkey -M vicmd '^v' edit-command-line
bindkey -M viins '^l' vi-cmd-mode
bindkey -M viins '^]' clear-screen
```

After
```sh
# Vim nize
bindkey -M afu-vicmd '_'  vi-first-non-blank
bindkey -M afu-vicmd 'g_' vi-end-of-line

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

# My taste
bindkey -M afu-vicmd '^v' edit-command-line
bindkey -M afu '^l' afu+vi-cmd-mode
bindkey -M afu '^]' clear-screen
```


# 解説
　まず、auto-fu.zshをロードした時点でキーマッピングがafuになるので、`bindkey -v`は必要なくなります。  
afuはviins相当のキーマッピングで、afu-vicmdはvicmd相当のキーマッピングになりますので、`bindkey -M`する対象を合わせて書き換えます。  
また、afuとafu-vicmdとの行き来は専用のもの（`afu+vi-cmd-mode`）が用意されているので、そちらを使うようにしました。


- - -


けものフレンズの2〜4話が観たい（観れてない）。
