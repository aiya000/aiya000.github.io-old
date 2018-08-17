---
title: sbt-doctestはテストプロジェクトのdoctestを見てくれない
tags: Scala
---
　doctestは最高ですから（Scalaだけに）Scalaにも存在します。

- [GitHub - tkawachi/sbt-doctest: Doctest for scala](https://github.com/tkawachi/sbt-doctest)

ここでこれを導入したプロジェクトのうちテストプロジェクト
`./src/test/poi/yudachi/sugar` があるとして、この
`./src/test/poi/yudachi/sugar/PoiTest.scala` にdoctestを記述しておいても実行されませんでした。

テストのテストができないということは「証明せよ」という司令だと受け取ってよろしいか？
