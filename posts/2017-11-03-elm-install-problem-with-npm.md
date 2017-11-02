---
title: elmのインストールがnpmで失敗したからyarnでやったらできた
tags: elm
---
　公式に書いてあるLinuxのインストール方法であるこいつ、なんぞ失敗しよる。

- [Install - An Introduction to Elm](https://guide.elm-lang.org/install.html)

```console
$ sudo npm install -g elm
npm WARN deprecated node-uuid@1.4.8: Use uuid module instead
/usr/bin/elm -> /usr/lib/node_modules/elm/binwrappers/elm
/usr/bin/elm-make -> /usr/lib/node_modules/elm/binwrappers/elm-make
/usr/bin/elm-package -> /usr/lib/node_modules/elm/binwrappers/elm-package
/usr/bin/elm-reactor -> /usr/lib/node_modules/elm/binwrappers/elm-reactor
/usr/bin/elm-repl -> /usr/lib/node_modules/elm/binwrappers/elm-repl

> elm@0.18.0 install /usr/lib/node_modules/elm
> node install.js

Error extracting linux-x64.tar.gz - Error: EACCES: permission denied, mkdir '/usr/lib/node_modules/elm/Elm-Platform'
npm ERR! code ELIFECYCLE
npm ERR! errno 1
npm ERR! elm@0.18.0 install: `node install.js`
npm ERR! Exit status 1
npm ERR!
npm ERR! Failed at the elm@0.18.0 install script.
npm ERR! This is probably not a problem with npm. There is likely additional logging output above.

npm ERR! A complete log of this run can be found in:
npm ERR!     /root/.npm/_logs/2017-11-02T15_33_20_608Z-debug.log
```

npm　もういい！もどれ！

いけ、yarn！

```console
$ sudo yarn global add elm
```

こうすればうまくインストールできた。
