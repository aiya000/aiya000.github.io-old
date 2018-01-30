---
title: haskell-stackで 'collect2; エラー; ldはステータス1で終了しました' が出た場合の対処
tags: Haskell
---
　先日`yaourt -Syuu`すると、haskell-stackのプロジェクトがビルドできなくなった。

```shell-session
$ cd {a-stack-project} && stack build
Configuring clock-0.7.2...
Building clock-0.7.2...
Preprocessing library clock-0.7.2...
/tmp/stack19865/clock-0.7.2/Clock.hsc:44:0: 警告: "hsc_alignment" が再定義されました
/tmp/stack19865/clock-0.7.2/In file included from .stack-work/dist/x86_64-linux-tinfo6-nopie/Cabal-1.24.2.0/build/System/Clock_hsc_make.c:1:0:
/home/aiya000/.stack/programs/x86_64-linux/ghc-tinfo6-nopie-8.0.2/lib/ghc-8.0.2/template-hsc.h:88:0: 備考: ここが以前の宣言がある位置です
#define hsc_alignment(t...) \

/bin/ld: .stack-work/dist/x86_64-linux-tinfo6-nopie/Cabal-1.24.2.0/build/System/Clock_hsc_make.o: relocation R_X86_64_32 against `.rodata' can not be used when making a shared object。 -fPIC を付けて再コンパイルしてください。
/bin/ld: 最終リンクに失敗しました: 出力に対応するセクションがありません
collect2: エラー: ld はステータス 1 で終了しました
```

　Haskellができないとか意味がわからないので、直す。
これで直った。

```shell-session
$ yaourt -Rns libtinfo
$ yaourt -S ncurses5-compat-libs
$ rm -rf ~/.stack .stack-work

$ cd /usr/lib
$ sudo mv libncurses.so{,.bak}
$ sudo ln -s libncursesw.so.6.0 libncurses.so
```

原因は謎。

　後半のコマンドについてはこれ。

- [あいや☆ぱぶりっしゅぶろぐ！ - haskell-stackでcan't load .so/.DLL for 〜/libncurses.soが出た場合の対処](2017-04-12-how-to-fix-libncurses-problem-of-stack.html)

# 上記がダメだったときに試すその他方法
クラキ カコ ヲ ケシサル ノダ

```shell-session
$ rm -rf ~/.stack
$ cd {your-stack-project} && rm -rf .stack-work
```

ナンジ スタティック ノ チカラ ヲ テニセヨ

```shell-session
$ yaourt -S stack-static
```
