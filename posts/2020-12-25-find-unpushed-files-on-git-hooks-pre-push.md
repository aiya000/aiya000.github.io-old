---
title: gitでまだpushしていないファイルを検出する
tags: git
---

重要なやつ :point_down:

project/scripts/get-root-branch.sh

```shell-session
#!/bin/bash

# 今いるブランチのリモートブランチ名、もしくは分岐元のブランチ名を取得する。
# （今いるブランチから直近の、push済みのブランチ名を取得する。）

# NOTE:
# remoteが複数ある場合の動作は実装していないので、
# `remote=upstream`のように直接代入するか、適切に実装してね！

if [[ $(git remote | wc -l) -gt 1 ]] ; then
    echo "Specifying for a remote is not implemented yet. A head remote name will be used instead." > /dev/stderr
fi
remote=$(git remote | head -1)

git log --decorate --all --oneline | grep "$remote" | head -1 | sed -r 's/\w+ \(([^\)]+)\) .*/\1/'
```

実際に、pushされていないファイルを検出するやつ :point_down:

```bash
#!/bin/bash

root_dir=$(git rev-parse --show-toplevel)

remote_latest_branch=$(bash -c "$root_dir/scripts/get-root-branch.sh")
current_branch=$(git branch --show-current)
unpushed_files=$(git diff --stat "$remote_latest_branch..$current_branch" --name-only)

# Use $unpushed_files
```

## 使用例

~/.git/hooks/pre-push :point_down:

```bash
# textlint for markdown

unpushed_markdown_files=$(echo "$unpushed_files" | grep '\.md$')

if ! npx textlint --config "$root_dir/.textlintrc" "$unpushed_markdown_files" ; then
    exit 1
fi
```

実行される様子 :point_down:

```shell-session
$ git branch
main

$ npx textlint pushed.md  # push済み、かつtextlintにひっかかるファイル
（textlintにひっかかる）

$ git switch -c foo
$ echo 'GitHubおおおおおん' > new.md  # 未pushの、textlintにひっかかるファイル（ja-space-between-half-and-full-width）

$ git add new.md
$ git commit -m poi

$ git push -u origin/foo

ここでpushed.mdはpre-pushのtextlintにひっかからず、new.mdだけひっかかる。
```
