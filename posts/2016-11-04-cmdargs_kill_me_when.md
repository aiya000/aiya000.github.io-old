---
title: cmdargsはargsと同時にhelpを設定するとシぬ
tags: Haskell
---

```haskell
clOptions :: CommandLineOptions
clOptions = CommandLineOptions
  { frontend    = "vty"   &= help "The frontend to use"
  , startOnLine = Nothing &= help "Open the (last) file on line NUM"
  , files       = []      &= help "FILES..." &= args  -- ここ
  }
```

デフォルトの引数をfilesで受けとりたくば、helpを消せ。  
さもなくば我々をcmdargsがコロす。

```haskell
clOptions :: CommandLineOptions
clOptions = CommandLineOptions
  { frontend    = "vty"   &= help "The frontend to use"
  , startOnLine = Nothing &= help "Open the (last) file on line NUM"
  , files       = []      &= args  -- ここ
  }
```

忘れるなよ。
