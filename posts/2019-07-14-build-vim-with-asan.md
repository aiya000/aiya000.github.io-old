---
title: VimをSanitizer付きでビルドして、調査ログを吐く
tags: Vim
---
　vim-jpでichizokさんに指南をいただきました。
ありがとうございます :sunglasses:

## 結

```shell-session
$ cd /path/to/vim
$ SANITIZER_CFLAGS="-g -O1 -DABORT_ON_INTERNAL_ERROR -DEXITFREE -fsanitize=address -fno-omit-frame-pointer" make

Starting make in the src directory.
If there are problems, cd to the src directory and run make there
cd src && make first
make[1]: Entering directory '/path/to/vim/template-string/src'
ccache gcc -c -I. -Iproto -DHAVE_CONFIG_H     -g3 -O0 -Wall  -g -O1 -DABORT_ON_INTERNAL_ERROR -DEXITFREE -fsanitize=address -fno-omit-frame-pointer      -o obj
ects/eval.o eval.c
make[2]: Entering directory '/path/to/vim/template-string/src/po'
make[2]: Nothing to be done for 'first'.

.
.
.

$ cd src/testdir
$ LD_PRELOAD='/usr/lib/libasan.so' ASAN_OPTIONS="print_stacktrace=1 log_path=asan" make test_template_string

rm -f test_template_string.res test.log messages
make -f Makefile test_template_string.res
make[1]: Entering directory '/path/to/vim/src/testdir'
make[1]: *** [Makefile:162: test_template_string.res] Error 1
make[1]: Leaving directory '/path/to/vim/src/testdir'
make: *** [Makefile:76: test_template_string] Error 2

$ ls asan.*
asan.12870

$ cat asan.12870

=================================================================
==12870==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 12 byte(s) in 1 object(s) allocated from:
    #0 0x7f9b5fc79ada in __interceptor_malloc /build/gcc/src/gcc/libsanitizer/asan/asan_malloc_linux.cc:144
    #1 0x55fccd45ddde in xmalloc (/usr/bin/bash+0x80dde)

SUMMARY: AddressSanitizer: 12 byte(s) leaked in 1 allocation(s).
```

## 起

　突然ですが現在、僕はVimにtemplate string対応を入れようと、活動しております。

- [Proposal: the string interpolation (the template string) - Issue #4491 - vim/vim - GitHub](https://github.com/vim/vim/issues/4491)
- [Support 'template string' ('string interpolation') by aiya000 - Pull Request #4634 - vim/vim - GitHub](https://github.com/vim/vim/pull/4634)
- [Vim scriptにstring interpolation対応を入れる - 進捗ノート](https://shinchoku.net/notes/38463)

　具体的にはこんな感じ。

```vim
echo $'I have ${10}'  " 'I have 10'
echo $'I like ${function("function")}'  " I like function('function')

echo $'${[10, 20]}'  " [10, 20]
echo $'${{"x": 10}}'  " {'x': 10}
echo $'${42.1}'  " 42.1
```

　ところでC言語はメモリリークがコワイですよね。

＼(・ω・＼)SAN値!(／・ω・)／ピンチ!  
＼(・ω・＼)SAN値!(／・ω・)／ピンチ!  
＼(・ω・＼)SAN値!(／・ω・)／ピンチ!  
＼(・ω・＼)SAN値!(／・ω・)／ピン!

ということでSAN値チェックです。

1. 以下のフラグ付きでmakeする
    - `SANITIZER_CFLAGS="-g -O1 -DABORT_ON_INTERNAL_ERROR -DEXITFREE -fsanitize=address -fno-omit-frame-pointer"`
1. 以下のフラグ付きでVimを起動する
    - `ASAN_OPTIONS="print_stacktrace=1 log_path=asan"`
    - `ASan runtime does not come first in initial library list; you should either link runtime to your application or manually preload it with LD_PRELOAD.`  
      って言われたら libasan.soがある場所を探して、`LD_PRELOAD='/path/to/libasan.so'`も付ける
1. Vimを操作してみる
    - 今回はtemplate string対応のデバッグなので、Vimで`:echo $'Hi ${"Vim"}'`などしてみたり
1. カレントディレクトリに `asan\.[0-9]+` なファイルができる
    - **これが調査結果です！**

完了！

- - -

　なんでC言語を学ぶことが大切なのか？　僕にはそれが答えられます。
Vim本体にコントリビュートできるようになるからです。

## 参考

- [＼(・ω・＼)SAN値!(/・ω・)/ピンチ! (さんちぴんち)とは【ピクシブ百科事典】](https://dic.pixiv.net/a/%EF%BC%BC%28%E3%83%BB%CF%89%E3%83%BB%EF%BC%BC%29SAN%E5%80%A4%21%28%2F%E3%83%BB%CF%89%E3%83%BB%29%2F%E3%83%94%E3%83%B3%E3%83%81%21)
