---
title: PatternSynonymsを用いて利用側コードを変更せずにある値構築子を削除する
tags: Haskell
---

- [Define Symbol as the intermediate representation - aiya000/hs-zuramaru@2a9ff48 - GitHub]()

　こういう型がありましたが

```haskell
data SExpr = Cons SExpr SExpr -- ^ Appending list and list
           | Nil              -- ^ A representation of empty list
           | Quote SExpr      -- ^ For lazy evaluation
           | AtomInt Int      -- ^ A pattern of the atom for @Int@ (primitive)
           | AtomSymbol Text  -- ^ A pattern of the atom for @Text@ (primitive)
```

（Lispの）シンボルを独立した表現として定義する必要が出てきました。
そうなるとこういうの

```haskell
newtype Symbol = Symbol { unSymbol :: Text }
  deriving (IsString, Show, Eq)
```

を定義するのが普通だと思いますが、これだとシンボルの表現がS式としてのもの、Haskellの型としてのもの
……と、2つの表現が混在してしまいます。

```haskell
-- その1
AtomSymbol Text
-- その2
newtype Symbol = Symbol { unSymbol :: Text }
```


# 解決策
　`PatternSynonyms`でpatternを定義してあげる。

```haskell
data SExpr = Cons SExpr SExpr
           | Nil
           | Quote SExpr
           | AtomInt Int
           | AtomSymbol' Symbol -- Symbolを仲介させる
  deriving (Show, Eq)

-- シンボルを表す唯一の表現
newtype Symbol = Symbol { unSymbol :: Text }
  deriving (IsString, Show, Eq)

-- 無くなったAtomSymbolを付け足す
pattern AtomSymbol :: Text -> SExpr
pattern AtomSymbol x = AtomSymbol' (Symbol x)
```

　このコミット

- [Define Symbol as the intermediate representation - aiya000/hs-zuramaru@2a9ff48 - GitHub]()

でわかる通り、利用側コードは変更されてません :dog2:  
（もちろんpatternをimportする必要はある）
