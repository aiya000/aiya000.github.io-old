---
title: gitでまだpushしていないファイルを検出する
tags: git
---

重要なやつ :point_down:

project/scripts/get-root-branch.sh

```bash
#!/bin/bash

# もし現在のgitブランチ（ここでfooとします。）がpushされていれば、{remote_name}/fooを返します。
# そうでなければこのブランチのルートとなるブランチ（分岐元）を取得し、それを返します。
#
# このプログラムはまず、リモート名を取得します。
# remoteが複数登録されている場合の適切な処理は未定義です。
# 現在は1番目のリモートを使用するようになっています。

# Returns tags and branches names of the root revision of current.
function root_names () {
  local remote=$1 rev char_not_delim names

  # Parser items
  rev='\w+'
  char_not_delim='[^\)]'
  names="($char_not_delim+)" # 'names' means tags and branches names

  git log --decorate --all --oneline | grep "$remote" | head -1 | sed -r "s/$rev \(($names)\) .*/\1/"
}

# NOTE: Please use nameref feature `local -n result=$1` instead of this global variable if you can use that feature.
names_array=()

# Put given names of glob $2 into $names_array1.
function make_array_of_names() {
  local names=$1 ifs xs i

  # Convert names what are split by ',' to an array.
  ifs=$IFS
  IFS=,
  # shellcheck disable=SC2206
  xs=($names)
  IFS=$ifs

  # Trim heading and trailing spaces
  for (( i=0; i < ${#xs[@]}; i++ )) ; do
    x=$(echo "${xs[$i]}" | sed 's/^ *\| *$//')
    names_array+=("$x")
  done
}

if [[ $(git remote | wc -l) -gt 1 ]] ; then
  echo "Specifying for a remote is not implemented yet. A head remote name will be used instead." > /dev/stderr
fi
remote=$(git remote | head -1)

names=$(root_names "$remote")
make_array_of_names "$names"

for (( i=0; i < ${#names_array[@]}; i++ )) ; do
  name=${names_array[$i]}

  if echo "$name" | grep "^$remote/" > /dev/null ; then
    echo "$name"
    exit 0
  fi
done

exit 1
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
