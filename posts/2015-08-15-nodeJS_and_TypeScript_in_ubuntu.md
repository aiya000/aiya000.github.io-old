---
title: Ubuntu15.04にnodejsとtypescriptを入れた
tags: 環境, Node.js
---
# Ubuntu15.04にnodejsとtypescriptを入れた

## 目的 : TypeScript実行環境を整える

### 1. どのパッケージをインストールすればいい？

参考ページ  
[http://y-anz-m.blogspot.jp/2012/11/ubuntu-typescript.html](http://y-anz-m.blogspot.jp/2012/11/ubuntu-typescript.html)  

ただし**リポジトリを追加する必要はなかった**。  
実際に行った作業は以下の通り。  
これを実行するとnpm及びnodejsの実行環境が入る。
```
$ sudo apt-get install npm nodejs
```

次にTypeScriptをインストールする。
```
$ sudo npm install -g typescript
```

これでTypeScriptの実行環境が整った。  
…が、実際にTypeScriptを実行するにはもうひとつだけ作業が必要だ。

だって、TypeScriptのコンパイラであるtscコマンドを叩くとこんなん言われるもん。
```
$ tsc -v
/usr/bin/env: node: そのようなファイルやディレクトリはありません
```


### 2. tscコマンドを実行できるようにする

参考ページ  
[http://improve.hatenablog.com/entry/2015/03/05/190251](http://improve.hatenablog.com/entry/2015/03/05/190251)  

ただし**tsc自体を修正するのは嫌だったので**、update-alternativesコマンドを使って  
nodejsパッケージによりインストールされたnodejsコマンドをnodeコマンドに仕立て上げた。  
( nodejsパッケージでnodeコマンドが入らない理由は上記サイト参照 )

作業は以下。
```
$ sudo update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
update-alternatives: /usr/bin/node (node) を提供するために自動モードで /usr/bin/nodejs を使います
```

これで/usr/bin/nodeに/usr/bin/nodejsへのリンクが貼られる。  
alternativesが何かわからない、もしくは管理が面倒、という方は以下でいいと思う。 ( 非推奨 )
```
$ sudo ln -s /usr/bin/node /usr/bin/nodejs
```


### 結果

tcsコマンドで.tsファイルを.jsファイルにコンパイルできた。
