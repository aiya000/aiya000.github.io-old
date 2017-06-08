---
title: vital.vim開発者会言ぎに行ってきた
tags: イベント, Vim
---
　どーも、vital.vim開発者会議に行ってきました。

- [vital.vim開発者会議2017-06](https://connpass.com/event/57862/)

　これにはvital.vimのコア開発者がなんか面倒なIssueとかを、実地に集まることによる密なコミュニケーションにより
消費していくというアレです。

　僕もこの前[Data.Either](https://github.com/vim-jp/vital.vim/blob/master/doc/vital/Data/Either.txt)をPull Requestして
vital.vimミッター入りとvim-jp入りしましたので、権利を得てました :D

　今日の主な議題はこちら！

- - -

1. [module import() behavior where the module only supports specific environments](https://github.com/vim-jp/vital.vim/issues/515)
2. [Test for helptags](https://github.com/vim-jp/vital.vim/pull/440)

- - -

# 1
　vital.vimの対象モジュールをimportしたときに、そのモジュールが（Vim7.4, Vim8.0, NeoVimなどの）ユーザの環境に対応していなかった場合どうするか？
例外を投げるか？
というアレです。

　結論として、import時には例外を投げずに`check_health`的な関数を設けて、『モジュールがサポートしているか否か』
『サポートしていなかった場合の理由』を辞書にして返すということになりました。


# 2
　これは「実装されているのにヘルプが書かれてない関数があるから、ヘルプ書いていくぞ」というやつです。
λlisueさんとthincaさんがめっちゃやってました。
僕もData.List.zip()とかのやつ書いてたよ。

- - -

はい。
