---
title: VimのQuickFixでelm-makeの結果を表示する設定を書いた
tags: Vim, NeoVim
---
　ソースはこちらに上げました :point_down:

- [dotfiles/elm.vim at 4d64e1a45ff2f34b03f8094bcee40fc7dddf9470 - aiya000/dotfiles - GitHub](https://github.com/aiya000/dotfiles/blob/4d64e1a45ff2f34b03f8094bcee40fc7dddf9470/.vim/after/ftplugin/elm.vim)

　:point_up:

　elm-makeはエラー情報をjson形式で出力するという最高の機能があるので、逆に`'errroformat'`の行単位でエラーを解析するVimのQuickFixではうまく解析できません。  
（elm-makeはjson形式だけでなく、human readableな形式でもエラーを出力することができますが、こちらも行単位の報告ではないのです :dog2:）

そのような場合はvital.vimのWeb.JSONモジュールを使うと最高です。
vital.vimはvim-jpの提供するVim script向け準標準ライブラリです。

- [GitHub - vim-jp/vital.vim: A comprehensive Vim utility functions for Vim plugins](https://github.com/vim-jp/vital.vim)

VimとNeoVimのどちらでも非同期に処理を行うために、vital-Whisky（vital.vimの追加ライブラリ）のSystem.Jobも使っています。

- [GitHub - lambdalisue/vital-Whisky: vital.vim external module collection](https://github.com/lambdalisue/vital-Whisky)
