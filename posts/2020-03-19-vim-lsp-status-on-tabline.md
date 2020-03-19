---
title: Vimのtablineに、vim-lspのrunningなserversを表示する
tags: Vim
---

![example](/images/posts/2020-03-19-vim-lsp-status-on-tabline/example.png)

- [僕の.vimrcでの対応コミット](https://github.com/aiya000/dotfiles/commit/335e5227b04295ad97d011b0cb985a94e6afcac1)

- - - - -

以下を設定すると、できる。

.vimrc

```vim
set tabline=%!vimrc#tabline#make()
```

autoload/vimrc/tabline.vim

```vim
" 大事なところ！
function vimrc#tabline#make() abort
  let running_lsp_servers = execute(':LspStatus')
    \ ->split('\n')
    \ ->filter({ _, x ->
      \ x !~# 'not running$'
    \ })
    \ ->map({ _, x -> x->split(':')[0] })
    \ ->join(', ')

  return '%1*[%{tabpagenr("$")}]%* '
    \. s:tabs() . ' => '
    \. printf('%6*[${%s}]%*', running_lsp_servers)
endfunction

" 以下、その他設定

" NOTE: http://d.hatena.ne.jp/thinca/20111204/1322932585
function s:tabs()
  let titles = map(range(1, tabpagenr('$')), { _, tabnr ->
    \ vimrc#tabline#tabpage_label(tabnr)
  \ })
  return join(titles) . '%#TabLineFill#%T'
endfunction

function vimrc#tabline#tabpage_label(tabnr)
  let title = gettabvar(a:tabnr, 'title')
  if title !=# ''
    return title
  endif
  let focused_winnr = tabpagewinnr(a:tabnr)
  let curbufnr = tabpagebuflist(a:tabnr)[focused_winnr - 1]
  let file_name = fnamemodify(bufname(curbufnr), ':t')
  let file_name =
    \ (file_name == '')
      \ ? '[NoName]' :
    \ (len(file_name) > 20)
      \ ? (file_name[0:7] . '...' . file_name[-10:-1]) :
    \ file_name

  " Please see `:h TabLineSel` and `:h TabLine`
  let window_num = '[' . len(tabpagebuflist(a:tabnr)) . ']'
  let label_of_a_buf = s:is_stayed_tab(a:tabnr)
    \ ? ('%#TabLineSel#[* ' . s:get_mod_mark_for_window(focused_winnr) . window_num . file_name . ' *]')
    \ : ('%#TabLine#[' . s:get_mod_mark_for_tab(a:tabnr) . window_num . file_name . ']')

  return '%' . a:tabnr . 'T' . label_of_a_buf . '%T%#TabLineFill#'
endfunction

" Do you staying the specified tab?
function s:is_stayed_tab(tabnr) abort
  return a:tabnr is tabpagenr()
endfunction

" Return '+' if the buffer of the specified window is modified
function s:get_mod_mark_for_window(winnr) abort
  return getbufvar(winbufnr(a:winnr), '&modified') ? '+' : ''
endfunction

" Return '+' if one or more a modified non terminal buffer is existent in the taken tab
function s:get_mod_mark_for_tab(tabnr) abort
  let term_buffers = term_list()
  let modified_buffer = s:List.find(tabpagebuflist(a:tabnr), v:null, { bufnr_at_tab ->
    \ !s:List.has(term_buffers, bufnr_at_tab) &&
    \ getbufvar(bufnr_at_tab, '&modified')
  \ })
  return (modified_buffer is v:null) ? '' : '+'
endfunction
```
