---
title: Data.CharのisAlphaはマルチバイト文字を正しく扱えない
tags: Haskell
---
　isAlphaNumも同様。  
まじ注意。
```haskell
Prelude> import Data.Char
Prelude Data.Char> isAlpha 'あ'
True
Prelude Data.Char> isAlphaNum 'あ'
True
```

これを定義しておけばいいんだけど、他にどっかData.Text以下あたりでexportしてないかなー。
```haskell
isAlpha' :: Char -> Bool
isAlpha' c = c `elem` ['A'..'Z']
          || c `elem` ['a'..'z']

isAlphaNum' :: Char -> Bool
isAlphaNum' c = c `elem` ['A'..'Z']
             || c `elem` ['a'..'z']
             || c `elem` ['0'..'9']
```
