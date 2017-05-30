---
title: tasty-discoverを使ってみた
tags: Haskell
---
# 参考ページ

- [lwm/tasty-discover: Test discovery for the tasty framework - Github](https://github.com/lwm/tasty-discover)
- [OverloadedStringsとANNプラグマが干渉する場合の回避方法 - Qiita](http://qiita.com/VoQn/items/fe7953aec010d8f68a59)

# 何それ？
　Haskellプロジェクトのtest-suiteのmain-isなるソースを書かずに、test-suiteプロジェクトのディレクトリを再帰的に見て、テスト項目を自動抽出してくれるやつ。


# 良かったところ
　完全にいいのですが、裏技があって、(unit|prop|scprop|spec|test)\_**function\_name**となるfunction\_nameをsneak\_caseにしておくと、テスト実行時に項目名にしてくれます。


# 例
Step1Test.hs
```haskell
test_parser_and_printer_converts_left_to_right :: [TestTree]
test_parser_and_printer_converts_left_to_right =
  [ testCase "'123' -> '123'" $ "123" `isConvertedTo` "123"
  , testCase "'abc' -> 'abc'" $ "abc" `isConvertedTo` "abc"
  , testCase "'(123 456)' -> '(123 456)'" $ "(123 456)" `isConvertedTo` "(123 456)"
  , testCase "'( 123 456 789 )' -> '(123 456 789)'" $ "( 123 456 789 )" `isConvertedTo` "(123 456 789)"
  , testCase "'( + 2 (* 3 4) )' -> '(+ 2 (* 3 4))'" $ "( + 2 (* 3 4) )" `isConvertedTo` "(+ 2 (* 3 4))"
  ]
  where
    isConvertedTo :: Text -> Text -> Assertion
    isConvertedTo code expected =
      case Parser.parse code of
        Left  e     -> assertFailure $ "The parse is failed: " ++ Parser.parseErrorPretty e
        Right sexpr -> MT.toSyntax sexpr @?= expected
```

出力
```console
Progress: 1/2tasty-discover
  parser and printer converts left to right
    '123' -> '123':                       OK
    'abc' -> 'abc':                       OK
    '(123 456)' -> '(123 456)':           OK
    '( 123 456 789 )' -> '(123 456 789)': OK
    '( + 2 (* 3 4) )' -> '(+ 2 (* 3 4))': OK

All 5 tests passed (0.00s)

Completed 2 action(s).
```
