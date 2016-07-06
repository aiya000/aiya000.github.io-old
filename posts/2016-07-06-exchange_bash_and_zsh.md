---
title: シェル環境をbash-viからzsh-viinsに移行している
tags: 環境
---
# シェル環境をbash-viからzsh-viinsに移行している
## 今までのシェル環境
+ bash
    - set -o vi (viキーマッピング)
    - vi-commandとvi-insertを使い分け
    - vi-insertはEmacsライクなカーソル移動を手動定義してる
    + プラグイン
        - プラグインマネージャ無し
        - 自作プラグインはdotfilesのみに集約
- tmux


## これからのシェル環境
-  zsh
    - bindkey -v (viinsキーマッピング)
    - zshのviinsはvi同様にEscやC-\[でvicmdモードに出れる
    - viinsはEmacsライクなカーソル移動を手動定義してる
    + プラグイン
        - zplug
        - 自作プラグイン用にリポジトリを作成
- tmux


## zsh超面白いやつ

- $PROMPTなどに色をつける場合、8色のみ使うならば以下の変数を使うことで超楽に設定できる
    - $fg
    - $bg
    - $reset\_color
- `zstyle ':completion:*' menu select`で、Tab補完が超ベンリになる
- `autoload -U promptinit && promptinit`で[有効になるやつ](https://wiki.archlinuxjp.org/index.php/Zsh#.E3.83.97.E3.83.AD.E3.83.B3.E3.83.97.E3.83.88)がすごく面白い
    - Vimの`:Unite colorscheme`みたいな感じ


## zsh設定で困ったこと
- bashに比べてmanが難しい
- bashの`bind -m`のようにモードを指定してキーマッピングを定義できない？
- history関連の設定が、bashのようにデフォルトで定義されてない
    - 以下のあたりのことを.zprofileと.zshrcに追加した
    - とかいうのをやった後に[こちら](http://qiita.com/b4b4r07/items/8db0257d2e6f6b19ecb9)にそれ用のコードが載っているのを発見した
- bashのvi-commandモードのvキーで起動するアレがzshでできない
    - [ここ](http://itchyny.hatenablog.com/entry/20111120/1321803120)を見て[自前実装で解決](http://qiita.com/aiya000/items/337b71e7d669cfa66128)

```zsh
export HISTFILE=$ZDOTDIR/.zsh_history
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
```


## 自作プラグイン
+ [sh-hereis](https://github.com/aiya000/sh-hereis)
    - ファイルパスをブックマークする感じなことをできる
    - ブックマークしたパスは、aliasとして自動定義される
+ [zsh-shell-kawaii](https://github.com/aiya000/zsh-shell-kawaii)
    - ももんがさんの[vimshell-kawaii.vim](http://blog.supermomonga.com/articles/vim/make-vimshell-cute.html)をリスペクトしてる
    - 今後、メイドさんがvimshell-kawaii.vimのように変化するようにする
+ [sh-tovim](https://github.com/aiya000/sh-tovim)
    - [vim-jpで上がってたアレ](http://vim-jp.org/blog/2015/10/15/tovim-on-shell-command-pipes.html)をプラグイン化しただけ


## とりあえず
　いい感じに整った。
