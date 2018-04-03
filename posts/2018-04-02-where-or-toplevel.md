---
title: 関数、where句に書くか トップレベルに書くか
tags: Haskell
---
# 概要
　下記のようにsugar以外がswordを参照していない場合は、
swordをトップレベルに定義するか、where句に定義するかが選べるかと思います。

```haskell
sugar :: Int -> Char
sugar = chr . sword

sword :: Bool -> Int
sword True  = 1
sword False = 0
```

or

```haskell
sugar :: Int -> Char
sugar = chr . sword
  where
    sword :: Bool -> Int
    sword True  = 1
    sword False = 0
```

どっちのが好き？

# 前置き
## let/where句の書き分け

　僕の以下のようにlet/where句を書き分けています。

- where
    - 本体への変数を参照せずに、独立したスコープを持つもの
- let
    - 本体への変数を参照しているもの

まあごくたまに崩してる気がしますが！ :joy:

### ここでは正しくない例

```haskell
foo :: Int -> Int
foo x =
  let f :: Int -> Int
      f = (+10)
  in f y
  where
    y = x + 1
```

　この`f`程度ならいいものの、ときどき
「なんで関数本体（let句）に含んだ？ なんで関数本体を肥大化させた？」
と思うものがあります。

　この`y`程度ならいいものの、ときどき
「コードを上から下に見る人の気持ちを考えたことある？ ねえどんな気持ちでwhere句に書いたの？」
と思うものがあります。

### ここでは正しい例

```haskell
foo :: Int -> Int
foo x =
  let y = x + 1
  in f y
  where
    f :: Int -> Int
    f = (+10)
```

人間の思考法に優しい感じがする。

# 本題
　ghciでは、module句で公開していないけれどトップレベルに定義してあるというものは
`:load`コマンドで読み込めるらしいのです。  
（Thanks @igrep, @Mizunashi\_Mana)

　なので僕はデバッグ上での利便性を鑑みて、
ghciで読み込み可能にしておきたいものはトップレベルに、
特に読み込みたいと思うことはないだろうものはwhere句に定義することにしました。

　以下の例の`lambdaParser`と`applicationParser`が、
特にmodule外には出したくないけどghciの`:load`では読み込みたいものに当たります。  
（[hs-sonoda](https://github.com/aiya000/hs-sonoda)での実例の抜粋。
詳しくは[このcommit](https://github.com/aiya000/hs-sonoda/commit/9efd7a547ed89ce46ebb6cc2124385a716ccd15b)と
src/Sonoda/Parser.hsを参照のことお願いします）

```haskell
module Sonoda.Parser
  ( exprParser
  ) where

-- | A parser of expressions
exprParser :: CodeParsing m => m Expr
exprParser = ExprAtomic <$> atomicValParser
        <<|> lambdaParser
        <<|> ExprSyntax <$> syntaxParser
        <<|> P.parens exprParser
        <<|> applicationParser

-- | A parser for lambda abstractions
lambdaParser :: CodeParsing m => m Expr
lambdaParser = do
  P.symbolic '\\'
  n <- identifierParser
  P.colon
  t <- typeParser
  P.dot
  x <- exprParser
  pure $ ExprLambda n t x

-- | A parser for function applications
applicationParser :: CodeParsing m => m Expr
applicationParser = do
  applyerOrLonlyIdentifier <- terminatorParser
  maybeApplyee <- const Nothing <$> P.eof <|> Just <$> exprParser
  case maybeApplyee of
    Nothing      -> pure applyerOrLonlyIdentifier
    Just applyee -> pure $ ExprApply applyerOrLonlyIdentifier applyee
  where
    -- A parser for terms that is not an application
    terminatorParser :: CodeParsing m => m Expr
    terminatorParser = ExprAtomic <$> atomicValParser
                  <<|> lambdaParser
                  <<|> ExprSyntax <$> syntaxParser
                  <<|> ExprParens <$> P.parens exprParser
                  <<|> ExprIdent  <$> identifierParser
```
