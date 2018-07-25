---
title: Happyの%tokenではより一般的な形式を下にしなきゃだめ
tags: Haskell
---
# 正誤
正しい

```haskell
%token
  ...
  ...
  natType  { (TokenAnIdent "Nat", _)   }
  boolType { (TokenAnIdent "Bool", _)  }
  ident    { (TokenAnIdent $$, _)      }
```

誤り

```haskell
%token
  ...
  ident    { (TokenAnIdent $$, _)      }
  ...
  natType  { (TokenAnIdent "Nat", _)   }
  boolType { (TokenAnIdent "Bool", _)  }
```

これはhappy製の単純型付きラムダ計算パーサーの、トークン宣言部です。

「正しい」のようにしないと、このような実行時エラーが起きます。

```
>>> parse "\\x:Nat.10"
got a token "Nat",
but [natType, boolType] are expected.
```

`"Nat" near_equal natType`ですが、先にidentの方にマッチするために、"Nat"がidentだと判断されています 🤘🙄🤘

# 実際の修正例

- [:bug: Fix a parse failure of XXX of `\x:XXX.x` - aiya000/hs-sonoda@4436382 - GitHub](https://github.com/aiya000/hs-sonoda/commit/443638210a2920139ca846cfa17c2e5546087436)
