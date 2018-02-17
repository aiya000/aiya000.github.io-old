---
title: IdrisでEffectモジュールなどを使おうとしたときに出るCan't find import Effect/Barの対処
tags: Idris
---
# 問題

Main.idr
```idris
import Effect.Default

main : IO ()
main = do
  printLn $ the Int default
  printLn $ the Char default
  printLn $ the Bool default
  printLn $ the String default
  printLn $ the (List String) default
```

```shell-session
$ idris -o Main Main.idr
Can't find import Effect/Default
```


# 解決
　`-p`で`effects`を指定してあげる。

```shell-session
$ idris -o Main Main.idr -p effects
$ ./Main
0
'\NUL'
False
""
[]
```

　もちろん`Effect.Bar`モジュール以外の時もこれを念頭に置いておくと便利。


# 参考ページ

- [Can't find import Effect/StdIO - Issue #1524 - idris-lang/Idris-dev - GitHub](https://github.com/idris-lang/Idris-dev/issues/1524)
