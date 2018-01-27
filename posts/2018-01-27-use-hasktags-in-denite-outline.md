---
title: How to use 'hasktags' in ':Denite outline'
tags: Vim, NeoVim
---
Below lines sets to use `hasktags` in `:Denite outline` :smiley:
```vim
call denite#custom#var('outline', 'command', ['hasktags'])
call denite#custom#var('outline', 'options', ['--ignore-close-implementation', '--ctags', '-x'])
```

But it overwrites the default values, all command will be using `hasktags` :sob:

You should add the like below lines to your `.vimrc`

```vim
augroup VimrcDeniteOutline
    autocmd!
    autocmd BufEnter,BufWinEnter *
        \   call denite#custom#var('outline', 'command', ['ctags'])
        \|  call denite#custom#var('outline', 'options', [])
    autocmd BufEnter,BufWinEnter *.hs
        \   call denite#custom#var('outline', 'command', ['hasktags'])
        \|  call denite#custom#var('outline', 'options', ['--ignore-close-implementation', '--ctags', '-x'])
augroup END
```
