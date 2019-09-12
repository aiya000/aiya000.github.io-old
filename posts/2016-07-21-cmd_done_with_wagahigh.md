---
title: コマンドラインの作業が終わると、突如としてワガハイ1話が流れ出すalias作った
tags: 環境, 日記
---
# コマンドラインの作業が終わると、突如としてワガハイ1話が流れ出すalias作った
```zsh
#/usr/bin/env zsh
alias mnotify="mplayer 'path/to/ワガハイ1話のファイル' > /dev/null 2>&1"
```

こうやって使う。
```console
$ stack build ; mnotify
```

## すごい
　mplayerコマンドを実行してるだけなので、突如として音声が発生し、画面トップにも現れるので最高。  
便利。
