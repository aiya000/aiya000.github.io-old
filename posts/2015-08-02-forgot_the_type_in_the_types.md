---
title: C#の拡張メソッドやScalaのimplicit convertionで広域な型を指定してはいけない
tags: プログラミング
---
# 静的型付けの中で型を忘れた話

　数日前、社内でこんな事件があった。

テスターさん「あいやさん、このチケット#XXXのテストをしようと思ったら、そもそも画面Aに飛べないんですけど…」  
僕「ゑ？」

( 今うちではRedmineチケットでテストしてもらいたい項目を投げたりして管理してます。  
  他にいい方法あったら教えてください )


　その画面は、今回の仕様変更で実装した部分には直接的に関係ない部分だった。  
しかし調べてみると、仕様変更に伴って修正したライブラリ部分に依存する処理がそこにはあった。

例外のスタックトレース曰く、原因はこんな感じのC#のコード。
```
public static class FooHelper {
  public static int IntValue(this object o) {
    int.Parse(o.ToString());
  }
}
```
( コードの内容にツッコミは入れないものとする )

そして利用側のコードはこんなん。
```
...
var row = fooDataGridView.Rows[n];
var o   = row.Cells["hoge"].IntValue();
// InvalidCastException
```

そういえばこのコードは以前、FooHelperクラスと別の名前空間のメソッド
``HogeHelper.IntValue(DataGridViewCell)``
を使用していた。

で、今回の仕様変更でそれを消していたので、オーバーロード解決がFooHelper.IntValue(object)に入ってしまってたみたい。

## 結論

+ 拡張メソッドはobjectでオーバーロードしない
+ 最低限のテストは自動化したい
