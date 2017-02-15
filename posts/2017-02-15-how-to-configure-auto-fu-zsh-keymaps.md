---
title: auto-fu.zshを使う際のzshのviキーバインド設定方法
tags: Linux, zsh
---
　[auto-fu.zsh](some)とはzshのneocomplete.vim（deoplete.vim）みたいなものです（すごいてきとう）。  
これを導入するとCLI環境がなんだかIDEチックになって格好いいのですが、もともと設定していた`bindkey -v`と`bindkey -M viins foo`、`bindkey -M vicmd bar`がうまく効かなくなってしまいました。


# 注意
　この記事では簡単のため、viinsとemacsやmainを統一して「viins」と書いてますよー。


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
bindkey -M viins '^r' fzf-history-search-backward
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
bindkey -M vicmd '^v'   edit-command-line
bindkey -M viins '^l'   vi-cmd-mode
bindkey -M viins '^]'   clear-screen
bindkey -M viins '^x^f' fzf-path-finder
```

After
```sh
# Vim nize
bindkey -M afu-vicmd '_'  afu-vicmd+vi-first-non-blank
bindkey -M afu-vicmd 'g_' afu-vicmd+vi-end-of-line

# Emacs nize insert mode
bindkey -M afu '^r' fzf-history-search-backward
bindkey -M afu '^n' afu+down-history
bindkey -M afu '^p' afu+up-history
bindkey -M afu '^a' afu+beginning-of-line
bindkey -M afu '^e' afu+end-of-line
bindkey -M afu '^b' afu+backward-char
bindkey -M afu '^f' afu+forward-char
bindkey -M afu '^k' afu+kill-line
bindkey -M afu '^u' afu+backward-kill-line
bindkey -M afu '^d' afu+delete-char

# My taste
bindkey -M afu-vicmd '^v' edit-command-line
bindkey -M afu '^l'   afu+vi-cmd-mode
bindkey -M afu '^]'   clear-screen
bindkey -M afu '^x^f' fzf-path-finder
```


# 解説
　まずauto-fu.zshは、それとviキーマッピングを調和させるために、afuキーマッピングとafu-vicmdキーマッピングを独自定義しています。  
afuがviins、afu-vicmdがvicmdに対応します。

またzshが定義する、viins用のキーマッピングは`afu+`プリフィックス付き、vicmd用のキーマッピングは`afu-vicmd+`プリフィックス付きで再定義されます。

+ Example
    - vi-end-of-line（zshのvicmd版） `=>` afu-vicmd+vi-end-of-line（afu版）
    - end-of-line（zshのviins版） `=>` afu+end-of-line（afu版）
<!--
|vicmd版           |viins版        |auto-fu.zsh版               |
|:--:              |:-------------:|:--------------------------:|
|vi-end-of-line    |               |afu-vicmd+vi-end-of-line    |
|vi-first-non-blank|               |afu-vicmd+vi-first-non-blank|
|                  |end-of-line    |afu+end-of-line             |
|                  |forward-char   |afu+forward-char            |
-->

なので、例えばauto-fu.zshのvi insertモード（afu）の`Ctrl + p`に`up-history`を設定したい場合は
```sh
bindkey -M afu '^p' afu+up-history
```
このようにします。


# おっ
　最後に。  
ここで問題になることがあって、auto-fu.zshは、viinsとvicmdのキーマッピングの一部しか再定義していません。  
使いたいキーマッピングが再定義されていない場合は、PRを送るのがいいと思います。

auto-fu.zshの最新版で、コードの構造が変更されていなければ  
[`$afu_zles`](https://github.com/aiya000/auto-fu.zsh/blob/84c71c506c136536bc7bda52e76d18ef7b2c8516/auto-fu.zsh#L285)
にviins用のキーマッピングを追加すると、afuに`afu+`プリフィックス付きで再定義されます。

同じく（これは先ほどauto-fu.zshにPRを出した内容になってしまいますが）
[`$afu_vicmd_zles`](https://github.com/aiya000/auto-fu.zsh/blob/84c71c506c136536bc7bda52e76d18ef7b2c8516/auto-fu.zsh#L300)
にvicmd用のキーマッピングを追加すると  
afuに`afu-vicmd+`プリフィックス付きで再定義されます。


- - -


けものフレンズの2〜4話が観たい（観れてない）。
