---
title: 使いたいVimプラグインがNeoVimで対応してない？ NeoVimは環境、VimはVMだよ？
tags: Vim, NeoVim
---
　ドーモ、最近NeoVimを使い始めたyiコントリビューターのVimmerのあいやです。  
この記事はVim Advent Calendar 2016 - 17日目の記事**ではありません**！  
だってもう、既に枠が埋まってたんだもん。

# NeoVimで動かないVimプラグインを動かす
僕が開発してる[aref-web.vim](https://github.com/aiya000/aref-web.vim)っていうのがあるんですが

- - -

- [あいや☆ぱぶりっしゅぶろぐ！ - aref-web.vimの紹介 - Vimアドベントカレンダー2016 - 14日目](https://$host$/posts/2016-12-13-intro-vim-aref-web-vim_advent_calendar_2016.html)

- - -

VimとNeoVimの非同期APIが非互換なので、NeoVimに対応してません :(  
でもNeoVimは強いので、**NeoVimの上でVimが動かせます**。

ちゅーこってこんなコマンドを定義する。

```vim
command! -bar -nargs=* -complete=file VimRunDo terminal vim -c <q-args>
```

するとこんなんできます。

![sample-image](/images/posts/2016-12-17-vim_as_vm_on_neovim/vimdo.gif)

一瞬エラーが出てるって？  
うーん、なぜVim内でNeoVim関連のエラーが出るかは知らないのでNeoVimの中の人に原因を聞いてみてください…。

ちなみに↑で使用したキーマッピングはこんな感じ。

```vim
nnoremap <leader>K :<C-u>vsp \| VimRunDo Aref weblio <C-r>=expand('<cword>')<CR><CR>
nnoremap <leader>S :<C-u>vsp \| VimRunDo Aref stackage <C-r>=expand('<cword>')<CR><CR>
vnoremap <leader>K "zy:<C-u>vsp \| VimRunDo Aref weblio <C-r>z<CR>
vnoremap <leader>S "zy:<C-u>vsp \| VimRunDo Aref stackage <C-r>z<CR>
```

- - -

ということで実用性は限られますが、辞書を引いたりオセロをしたりっていうカレントバッファに作用する感じではない感じの、
NeoVimに対応してないVimプラグインもNeoVimで動かせ~~たかのように見せることができ~~ます :D

- - -

# 追記
　プラグイン化したよ！

[nvim-vim-runner / GitHub](https://github.com/aiya000/nvim-vim-runner)
