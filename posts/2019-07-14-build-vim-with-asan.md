---
title: VimをSanitizer付きでビルドして、メモリリークを検出する
tags: Vim, C
---

　vim-jpでichizokさんに指南をいただきました。
ありがとうございます :sunglasses:

## 結

```shell-session
$ cd /path/to/vim
$ SANITIZER_CFLAGS="-g -O1 -DABORT_ON_INTERNAL_ERROR -DEXITFREE -fsanitize=address -fno-omit-frame-pointer"
$ ASAN_OPTIONS="print_stacktrace=1 log_path=asan"
$ make

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
$ make test_template_string

rm -f test_template_string.res test.log messages
make -f Makefile test_template_string.res
make[1]: Entering directory '/path/to/vim/src/testdir'
make[1]: *** [Makefile:162: test_template_string.res] Error 1
make[1]: Leaving directory '/path/to/vim/src/testdir'
make: *** [Makefile:76: test_template_string] Error 2

$ ls asan.*
asan.12870

$ cat asan.12870
```

- - - - -

結果

<details>
<summary>cat asan.12870</summary>

<!-- {{{ -->

```
=================================================================
==35931==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 520 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590adfa521  (/usr/lib/libXt.so.6+0x13521)

Indirect leak of 21152 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590a88d291  (/usr/lib/libxcb.so.1+0xc291)

Indirect leak of 16384 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590acd7c13  (/usr/lib/libX11.so.6+0x30c13)

Indirect leak of 5040 byte(s) in 2 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590acd7f7d  (/usr/lib/libX11.so.6+0x30f7d)

Indirect leak of 4688 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590acd78bf  (/usr/lib/libX11.so.6+0x308bf)
    #2 0x5631814de807  (/path/to/vim/template-string/src/vim+0x50e807)
    #3 0x5631814af9ae  (/path/to/vim/template-string/src/vim+0x4df9ae)
    #4 0x563181718296  (/path/to/vim/template-string/src/vim+0x748296)
    #5 0x563181714ff6  (/path/to/vim/template-string/src/vim+0x744ff6)
    #6 0x7f590a8db152  (/usr/lib/libc.so.6+0x27152)

Indirect leak of 2372 byte(s) in 1 object(s) allocated from:
    #0 0x563181203612  (/path/to/vim/template-string/src/vim+0x233612)
    #1 0x7f590a88d47c  (/usr/lib/libxcb.so.1+0xc47c)

Indirect leak of 628 byte(s) in 1 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590acd83f1  (/usr/lib/libX11.so.6+0x313f1)

Indirect leak of 168 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590acd81a0  (/usr/lib/libX11.so.6+0x311a0)

Indirect leak of 160 byte(s) in 1 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590acc67cc  (/usr/lib/libX11.so.6+0x1f7cc)

Indirect leak of 152 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590ad3db8f  (/usr/lib/libX11.so.6+0x96b8f)

Indirect leak of 132 byte(s) in 6 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590adfa2f5  (/usr/lib/libXt.so.6+0x132f5)

Indirect leak of 128 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590acd7e2c  (/usr/lib/libX11.so.6+0x30e2c)

Indirect leak of 128 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590acd180c  (/usr/lib/libX11.so.6+0x2a80c)

Indirect leak of 112 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590acd7efd  (/usr/lib/libX11.so.6+0x30efd)

Indirect leak of 104 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590ace6f3f  (/usr/lib/libX11.so.6+0x3ff3f)

Indirect leak of 72 byte(s) in 1 object(s) allocated from:
    #0 0x563181203441  (/path/to/vim/template-string/src/vim+0x233441)
    #1 0x7f590acd7c76  (/usr/lib/libX11.so.6+0x30c76)

Indirect leak of 48 byte(s) in 1 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590ace7055  (/usr/lib/libX11.so.6+0x40055)

Indirect leak of 48 byte(s) in 1 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590ace703e  (/usr/lib/libX11.so.6+0x4003e)

Indirect leak of 40 byte(s) in 1 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590ace914e  (/usr/lib/libX11.so.6+0x4214e)

Indirect leak of 32 byte(s) in 1 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590a88faa7  (/usr/lib/libxcb.so.1+0xeaa7)

Indirect leak of 32 byte(s) in 1 object(s) allocated from:
    #0 0x563181203612  (/path/to/vim/template-string/src/vim+0x233612)
    #1 0x7f590a89056f  (/usr/lib/libxcb.so.1+0xf56f)

Indirect leak of 24 byte(s) in 1 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590ace7656  (/usr/lib/libX11.so.6+0x40656)

Indirect leak of 21 byte(s) in 1 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590acd7d95  (/usr/lib/libX11.so.6+0x30d95)

Indirect leak of 16 byte(s) in 1 object(s) allocated from:
    #0 0x563181203289  (/path/to/vim/template-string/src/vim+0x233289)
    #1 0x7f590a89092e  (/usr/lib/libxcb.so.1+0xf92e)

Indirect leak of 10 byte(s) in 1 object(s) allocated from:
    #0 0x563181180e99  (/path/to/vim/template-string/src/vim+0x1b0e99)
    #1 0x7f590acd181d  (/usr/lib/libX11.so.6+0x2a81d)

Indirect leak of 3 byte(s) in 1 object(s) allocated from:
    #0 0x563181180e99  (/path/to/vim/template-string/src/vim+0x1b0e99)
    #1 0x7f590acd78d4  (/usr/lib/libX11.so.6+0x308d4)

SUMMARY: AddressSanitizer: 52214 byte(s) leaked in 32 allocation(s).
```

<!-- }}} -->

</details>

- - - - -

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

## 正しく検出できない？

　結果が下記のように、明らかにVimへのチェックができていない感じになることがありました。

```
=================================================================
==12870==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 12 byte(s) in 1 object(s) allocated from:
    #0 0x7f9b5fc79ada in __interceptor_malloc /build/gcc/src/gcc/libsanitizer/asan/asan_malloc_linux.cc:144
    #1 0x55fccd45ddde in xmalloc (/usr/bin/bash+0x80dde)

SUMMARY: AddressSanitizer: 12 byte(s) leaked in 1 allocation(s).
```

僕の場合、gccではなくclangを使うようにしたら、うまくいきました。

```shell-session
$ export CC=${CC:-clang}
$ export CC_FOR_BUILD=${CC_FOR_BUILD:-clang}
$ make -j4 -e CFLAGS='-Wall'
$ cd src/testdir
$ make test_template_string
```

あるいは下記のissueのいずれかが参考になるかもしれません。

- [Workarounds for #837 (Shadow memory range interleaves with an existing memory mapping. ASan cannot proceed correctly. ABORTING.) - Issue #856 - google/sanitizers - GitHub](https://github.com/google/sanitizers/issues/856)
- [-fsanitize=address doesn't link libasan on Arch Linux - Issue #2488 - ldc-developers/ldc - GitHub](https://github.com/ldc-developers/ldc/issues/2488)

## 参考

- [＼(・ω・＼)SAN値!(/・ω・)/ピンチ! (さんちぴんち)とは【ピクシブ百科事典】](https://dic.pixiv.net/a/%EF%BC%BC%28%E3%83%BB%CF%89%E3%83%BB%EF%BC%BC%29SAN%E5%80%A4%21%28%2F%E3%83%BB%CF%89%E3%83%BB%29%2F%E3%83%94%E3%83%B3%E3%83%81%21)
