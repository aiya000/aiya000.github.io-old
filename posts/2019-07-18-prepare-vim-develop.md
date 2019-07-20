---
title: Vim本体にコントリビュートする際の僕の手順
tags: Vim
---

## 1. デバッグビルド用のconfigureをシェルスクリプトにしておく

これは最小限のビルドオプションなので、適宜修正。

```shell-session
#!/bin/bash
configure=$(cat << EOS
./configure \
    --prefix=/usr/local/ \
    --enable-fail-if-missing \
    --enable-gui=no \
    --enable-multibyte=yes \
    --enable-perlinterp=no \
    --enable-pythoninterp=no \
    --enable-python3interp=no \
    --enable-rubyinterp=no \
    --enable-luainterp=no \
    --with-lua-prefix=/usr \
    --with-luajit \
    --enable-cscope=yes \
    --with-features=huge \
    --with-compiledby=aiya000 \
    --enable-terminal
EOS
)

if [ -f ./configure ] ; then
    echo "$configure"
    eval "$configure"
else
    echo './configure cannot be found'
fi
```

## 2. ccacheでビルドを高速化する

- [Ccache - ArchWiki](https://wiki.archlinux.jp/index.php/Ccache)

~/.zshrcあたり。

```shell-session
export USE_CCACHE=1
export $CCACHE_DISABLE=0
export CCACHE_DIR=$SUGOI_IPPAI_YOURYO_ARU_TOKO
```

~~なんか今みたら、うまく動いてなかったっぽい……。~~

誰かVimでccacheを使う方法わかったら、教えて！

## 3. eval.cとかを修正する

がんばります。

- [Vim のソースのいじり方(:terminal を作るまで) - Qiita](https://qiita.com/mattn/items/ee438479b09055a2f305~)
- [Vim本体に組み込み関数を追加するパッチを投げた - Qiita](https://qiita.com/mopp/items/084abe28681202bda30e~)
- [スパルタンVim 4.0のPDF公開 &mdash; KaoriYa](https://www.kaoriya.net/blog/2014/09/19/)

## 4. gdbでデバッグする

めっちゃがんばる。
`Termdebug`めっちゃよいので、ぜひ。

- `:packadd termdebug`
- `:help :Termdebug`
- `:Termdebug path/to/vim/src/vim`

ちょっと :point_down: も参考になるかも。

- [Vimのソース内で自作した関数の結果を確認する](./2019-06-26-run-my-func-on-vim-src.html)

## 5. google/sanitizersとかvalgrindでメモリリークを検出する

- [AddressSanitizer - google/sanitizers Wiki - GitHub](https://github.com/google/sanitizers/wiki/AddressSanitizer)

- sanitizersの使い方はこちらなど :point_right: [VimをSanitizer付きでビルドして、調査ログを吐く](./2019-07-14-build-vim-with-asan.html)

valgrindは知らなかった。
vim-jpのTsuyoshi CHOさん、ありがとうございます！

```shell-session
$ cd src/testdir
$ vim Makefile  # 下記のところをコメントアウトする
```

- [vim/Makefile - vim/vim - GitHub](https://github.com/vim/vim/blob/df9c6cad8cc318e26e99c3b055f0788e7d6582de/src/testdir/Makefile#L21)

```shell-session
$ make test_自分で作ったやつなど.vim  # e.g. test_template_string.vim
$ cat valgrind.test_作ったやつなど

==3099== Memcheck, a memory error detector
==3099== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==3099== Using Valgrind-3.14.0 and LibVEX; rerun with -h for copyright info
==3099== Command: ../vim -f -u unix.vim -U NONE --noplugin --not-a-term -S runtest.vim test_template_string.vim --cmd au\ SwapExists\ *\ let\ v:swapchoice\ =\ "e"
==3099== Parent PID: 3098
==3099== 
==3099== Conditional jump or move depends on uninitialised value(s)
==3099==    at 0x234D76: utfc_ptr2len (mbyte.c:2119)
==3099==    by 0x16DB72: embed_embedded (eval.c:6032)
==3099==    by 0x16D486: parse_template (eval.c:5885)
==3099==    by 0x16CE62: get_template_string_tv (eval.c:5655)
==3099==    by 0x16AFCC: eval7 (eval.c:4625)
==3099==    by 0x16A745: eval6 (eval.c:4305)
.
.
.
```

ヤッター！！

## 6. 修正する

とてもがんばる。

終わったら「5.」でリークが検出されなくなるまで、「3.」から「6.」をくりかえしゅ！！！

ヤッター！！！！
