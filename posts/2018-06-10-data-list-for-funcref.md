---
title: vital.vimのData.Listにラムダ式が渡せるようになりました！
tags: Vim, NeoVim
---
# まとめ
　[このPR](https://github.com/vim-jp/vital.vim/pull/511)により、
Vim scriptの準標準ライブラリであるvital.vimのData.Listモジュールで、
Funcref（ラムダ式や関数参照）が使用可能になりました！
:tada: :tada: :tada:

- [Add the supports to use Funcref and Data.Closure's {callable} in Data.List by aiya000 - Pull Request #511 - vim-jp/vital.vim - GitHub](https://github.com/vim-jp/vital.vim/pull/511)

Vim scriptでFunctional Programmingを楽しもう！ :dog2:

```vim
let s:L = vital#vital#new().import('Data.List')

let xs = range(0, 50)
let xs = s:L.map(xs, { x ->
    \   (x % 5 == 0) && (x % 3 == 0) ? 'FizzBuzz'
    \ : (x % 5 == 0) ? 'Fizz'
    \ : (x % 3 == 0) ? 'Buzz'
    \                : string(x)
\ })

function! s:p(x) abort
    return a:x ==# 'Fizz'
endfunction

let xs = s:L.filter(xs, function('s:p'))
echo s:L.all(function('s:p'), xs)
" 1
```

# 背景
　Vim8.0でラムダ式がサポートされましたので、
Data.ListがFuncrefに対応する必要がありました。

このPR以前では下記のような、
式を表す文字列を渡すことしかできませんでした。
これはVim scriptの伝統的な方法です。

```vim
let s:L = vital#vital#new().import('Data.List')
echo s:L.map(range(0, 9), 'v:val + 1')
" [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

# 今回の追加で
　下記のように、
Funcref（ラムダ式、関数参照）を使用することができるようになりました！

```vim
let s:L = vital#vital#new().import('Data.List')

function! s:succ(x) abort
    return a:x + 1
endfunction

" ラムダ式
let Succ = { x -> x + 1 }

" 関数参照
let Succ_ = function('s:succ')

let xs = range(0, 9)
echo s:L.map(xs, Succ) == s:L.map(xs, Succ_)
" 1
```

Vim scriptの古き伝統ともおさらば :confetti_ball:

# おまけ
## Data.List.Closure
　vital.vimには、
Vim8.0より前のVimでも関数の部分適用を行うためのData.Closureモジュールが存在します。

今回のPRでは、
Data.ClosureのオブジェクトでData.Listの各関数を使用するためのData.List.Closureモジュールも追加されました。

```vim
let s:V  = vital#vital#new()
let s:C  = s:V.import('Data.Closure')
let s:CL = s:V.import('Data.List.Closure')

function! s:plus(x, y) abort
    return a:x + a:y
endfunction
let plus = s:C.from_funcref(function('s:plus'), [10])

let xs = range(0, 9)
echo s:CL.map(xs, plus)
" [10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
```

　Data.List.Closureはパフォーマンスに難があるため、
Data.List内の直接対応は見送られました。

ですので基本的には、
Vim8.0で追加されたclosure付き関数（ラムダ式）
またはfunction関数による部分適用
との組み合わせでData.Listを使用した方がよいでしょう。


# 以上
　Vim scriptでFunctional Programmingを楽しもう！
Data.OptionalとData.Eitherもあるよ！

# @Milly
　実は本PRは途中で「Vim 7.4のみでVim scriptのパースエラーが起きる」という問題に出くわしていて、
遥かなるだるみによって放置してしまっていました。

そこでその対応をしてくださったのがMillyさんでした。
ありがとうございました！

# 便利なページ

- [vim-jp/vital.vim: A comprehensive Vim utility functions for Vim plugins](https://github.com/vim-jp/vital.vim)
- ドキュメント
    - [Data.List](https://github.com/vim-jp/vital.vim/blob/master/doc/vital/Data/List.txt)
    - [Data.List.Closure](https://github.com/vim-jp/vital.vim/blob/master/doc/vital/Data/List/Closure.txt)
    - [Data.Closure](https://github.com/vim-jp/vital.vim/blob/master/doc/vital/Data/Closure.txt)
    - [Data.Optional](https://github.com/vim-jp/vital.vim/blob/master/doc/vital/Data/Optional.txt)
    - [Data.Either](https://github.com/vim-jp/vital.vim/blob/master/doc/vital/Data/Either.txt)
