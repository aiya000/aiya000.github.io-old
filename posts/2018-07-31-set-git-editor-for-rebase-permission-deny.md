---
title: gitの「Could not execute editor」が出たときは$GIT_EDITORを設定する
tags: git
---
# 結
```shell-session
$ GIT_EDITOR=nvim git rebase --interact
```

# 起承結
```shell-session
$ git rebase --interact
/usr/local/Cellar/git/2.16.1/libexec/git-core/git-rebase--interactive: line 267: /Users/aiya000/poi/.git/rebase-merge/git-rebase-todo: Permission denied
Could not execute editor
```

って言われて`rebase -i`できない。
なんかちょっと前もこれで困って`rm -rf git-repo && git clone https://foo.bar/git-repo.git`とかした気がする。

皆さんけっこう`git config core.editor /path/to/your_editor`のようにyour_editorへのフルパス指定で解決してるみたいでしたが、
僕は解決できず。

```shell-session
$ GIT_EDITOR=nvim git rebase --interact
```

で解決できました。

最後に`echo 'export GIT_EDITOR=nvim' >> .zprofile`みたいな感じで完全になりました。
最強。
