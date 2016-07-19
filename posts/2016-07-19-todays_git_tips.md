---
title: 今日のgit-tips (簡単で便利なrebaseによるcommit編集)
tags: プログラミング
---
# 今日のgit-tips (簡単で便利なrebaseによるcommit編集)
　今日は未pushのいくつかのcommitの内容を`git rebase`で編集する方法を紹介します。  
push済みのcommitは編集…できますが、`git push --force`をする必要があります。

　`git push --force`が何かというと、複数人で共同作業をしているリポジトリの場合に、他の作業者を混乱させるコマンドです。  
1人用リポジトリでも、--forceする癖をつけるのは危ないので非推奨とします。


## Step 1 (準備)
　まずこんな感じにリポジトリを作成、初期化します。

```console
$ mkdir git-repo
$ cd git-repo
$ git init
$ echo "first commit"  > a && git add -A && git commit -m "Create 'a'"
$ echo "second commit" > b && git add -A && git commit -m "Create 'b'"
$ echo "third commit"  > c && git add -A && git commit -m "Create 'c'"
$ git log --oneline
```

出力結果
```git-log--oneline
acd21a4 Create 'c'
0368ccb Create 'b'
2c1f07a Create 'a'
```


## Step 2 (1つ前のcommitを編集する - rebase -i)
　本題ですねー。  
ここで僕は、1つ前のコミット(`HEAD~` または `0368ccb`)時点で、ファイル'aho'があったことにしたくなりました。  
`git rebase -i HEAD~~`を使います。 ( `HEAD~` ではなく `HEAD~~`)

```console
$ git rebase -i HEAD~~
```

($EDITORへの)出力結果
```git-rebase
pick 0368ccb Create 'b'
pick acd21a4 Create 'c'
```

編集したいcommitは`0368ccb`なので、以下のように編集します。

```git-rebase
edit 0368ccb Create 'b'
pick acd21a4 Create 'c'
```

　エディタを終了すると、諸メッセージが表示されます。  
今からその諸メッセージに表示されたそれを使って、コミットを編集していきます。
```
Stopped at 0368ccb... Create 'b'
You can amend the commit now, with

    git commit --amend

Once you are satisfied with your changes, run

    git rebase --continue
```


## Step 3 (1つ前のcommitを編集する - rebase --continue)

* すること
    1. ファイル'aho'を作成する
    2. 現在のcommitの修正を実行する
    3. 修正が終わったことを`git rebase -i`に報告する

```console
$ echo "I'm exists" > aho
$ git add -A
$ git commit --amend -m "Create 'b' and 'aho'"
$ git rebase --continue
```

出力結果
```
Successfully rebased and updated refs/heads/{ブランチ名}.
```


## Step 4 (最終確認)
　`git log --oneline`を確認すると、`HEAD~`の編集が確定されていることを確認できます。
```git-log--oneline
d98cb68 Create 'c'
4e07930 Create 'b' and 'aho'
2c1f07a Create 'a'
```

`Create 'b' and 'aho'`のcommitのidが変わっているのも、commitの修正ができた証ですねー。  
(枠がさらに広がっちゃうので詳しくは語りませんが、これは「新しいcommitに`rebase`できた」ということです)

以上！


## おまけ
　実は、Step 3ではファイルの作成以外にもあらゆる様々なことが行なえます。

- git add -p
- git stash pop
- git mv
- git rm
- ファイルの編集

などなど。  
しかし、歴史に矛盾が発生するレベルで操作できたり…それ以後のcommitの辻褄合わせを行わなければいけなくなったりするので、
自分が理解している範疇で使用することをオススメします。
