---
title: sbt-doctestはテストプロジェクトのdoctestを見ない
tags: Scala
---
　doctestは最高ですから（Scalaだけに）Scalaにも存在します。

- [GitHub - tkawachi/sbt-doctest: Doctest for scala](https://github.com/tkawachi/sbt-doctest)

ここでこれを導入したプロジェクトのうちテストプロジェクト
`./src/test/poi/yudachi/sugar` があるとして、この
`./src/test/poi/yudachi/sugar/PoiTest.scala` にdoctestを記述しておいても実行されませんでした。

っぽい！
