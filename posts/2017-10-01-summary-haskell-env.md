---
title: 僕ののHaskell開発環境を紹介する
tags: Haskell
---
# 趣旨
　僕は僕のHaskell開発環境を使っているのだけど（それはそう）、常々これはなかなか便利だと思っている。

加え、Haskellの開発環境の導入方法がよくわからないという声をとても多く聞く。

　幸い、前提となるHaskell開発ツールキットの導入については、こちらにわかりやすい記事がある。

- [Haskellらしさって？「型」と「関数」の基本を解説！【第二言語としてのHaskell】 - エンジニアHub｜若手Webエンジニアのキャリアを考える！](https://employment.en-japan.com/engineerhub/entry/2017/08/25/110000) 
　ここでは、これらのツールキットをどのようにうまく使うか
……例えば、TDDに適したテキストエディタは？
今表示しているこの関数の型ってどうやったらわかる？
というのを、**「僕はこうしているよ」という様に**まとめておく。

　また、「こっちの方がいいんじゃ？」というのがあれば、教えてもらいたい。
あと、皆も自分のやつを晒すといいと思う。

　そういえばこういうのも開催されているらしい。

- [hacktoberfest.digitalocean.com](https://hacktoberfest.digitalocean.com/)
    - 10月中にGitHubでPull-Requestを4つ送るとTシャツが貰えるやつ。


# 本的な構成

- CLI
    - シェル（bashでもzshでもなんでも）
        - and commands
    - Vim or NeoVim
        - and plugins


# テキストエディタ
　まず開発者が一番気になるのがテキストエディタだと思う。
また、IDEを使うかどうか、という話にもなる。

　僕はVimを常用していて、全ての言語をVimで書いているので
（Javaも、Kotlinも、そしてC#も）、
やはりVimを使う。

　この前までNeoVimを使っていたので、NeoVimでも行けると思う。


# hasktags + haskdogsを使う

- [hasktags: Produces ctags &quot;tags&quot; and etags &quot;TAGS&quot; files for Haskell programs](https://hackage.haskell.org/package/hasktags)
    - かのTsuru Capitalがコントリビューターの一片になっている
- [haskdogs: Generate tags file for Haskell project and its nearest deps](https://hackage.haskell.org/package/haskdogs)


## Vimでの設定
　Vimにはctagsという、
関数や型の情報を集収したファイルを参照し、
関数や型が記述されている実際のファイル位置に飛ぶことができる
機能がある。

　tagファイルは通常`ctags`コマンドで生成できる。

　僕はそれを読み込むために、`.vimrc`で`'tags'`を以下のように設定している。

```vim
let &tags = join([
\    'tags',
\    '.git/tags',
\    '../.git/tags',
\    '../../.git/tags',
\    '../../../.git/tags',
\    '../../../../.git/tags'
\], ',')
```

　これは`./tags`か、もしくは`.git/tags`, `../.git/tags`, ...にあるそのtagsを読み込む。


## hasktags
　Haskellに特化した`ctags`コマンド亜種として、
`hasktags`コマンドがある。

　これは、今我々が作っているプロジェクトにある各.hsファイルに記述された
全ての関数を扱うことができる。

![hasktags-image](/images/posts/2017-10-01-summary-haskell-env/hasktags-image.png)

　以下のシェルコマンドでインストールできる。

```console
$ stack install hasktags
```

　僕はこんなaliasをシェルに定義して使っている。

```sh
alias hasktags-casual='hasktags . --ignore-close-implementation --tags-absolute --ctags -f'
```

```console
$ haskdogs .git/tags
（.git/tagsに、各.hsファイルの関数の羅列が出力される）
```


## haskdogs
　上で`hasktags`の使い方を紹介したものの、まあ普通はこれだけ使っていればいい。

　`haskdogs`は……`hasktags`を使って、
自プロジェクトの依存しているパッケージのtagsも出力してしまおう、というもの。

　例えば、自プロジェクトが`easy-file`パッケージの`doesFileExist`関数を使っている時に
`haskdogs`を実行すると、`haskdogs`はghc-pkgコマンドを使って
`easy-file`のソースを`$HOME/.haskdogs`以下に落としてきて、
そこを参照するtagsを生成する。

　また、生成されたtagsには自プロジェクトの各関数も含まれるので、
プロジェクトに関係する、
ほぼ全ての関数と型をエディタに表示できる！

![haskdogs-image](/images/posts/2017-10-01-summary-haskell-env/haskdogs-image.png)

　以下のシェルコマンドでインストールできる。

```console
$ stack install haskdogs
```


## unite-tag

- [GitHub - tsukkee/unite-tag: tags soruce for unite.vim](https://github.com/tsukkee/unite-tag)

　tagsファイルをUniteで開くのに使用する。
関数名、型名でtagsファイル内を検索することができる。

　例えば、現在開いているバッファに引きたい関数名がなくとも、
これで検索することができる。
（普段は名前の上にカーソルを載せて、`<C-]>`キーでtagsの先にジャンプできる）


## aref-web.vimで関数名や型を調べる
　`haskdogs`とVimのtagジャンプ機能そしてunite-tagで、
自プロジェクトに関係するほぼ全ての関数と型を引くことができた。

　これの唯一できないことは、自プロジェクトに関係ないものを引くことだ。
これはVimで、Web上のStackage検索を使うことで実現する。

　Web辞書（例えばWeblio）をVimで引くためのプラグインとして、aref-web.vimがある。

- [GitHub - aiya000/aref-web.vim: Web dictionaries on the vim with async.](https://github.com/aiya000/aref-web.vim)

　これは僕が作ったものなのだけど、
これのデバッグはずっとStackageを用いて行っていたこともあり、
Stackageについては十分に実用できるレベルになっていると思う。

![aref-image](/images/posts/2017-10-01-summary-haskell-env/aref-image.png)

（まあ……
誰も注目してくれていないみたいだし、
僕もStackage検索を行うために作ったものなので、
他のサイトについてはまだβという感じ）

StackageのWebサイトは、
Haskellの関数とライブラリの検索に対応しており

- [Stackage](https://www.stackage.org/)

例えば

- `a -> a`の型を持つあの関数の名前ってなんだっけ？
- `id`関数の型ってなんだっけ？
- `doesFileExist`関数ってどのライブラリが提供してるんだっけ？
- `m a -> a`みたいな型を持つ関数ってないかな？

というシチュエーションに対して対応することができる。

　余談だけど、僕はこれで英和辞書を使ってたりもするので便利（ステマ）。


# snowtify
