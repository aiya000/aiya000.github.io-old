---
title: extensibleのEffectでIOを使う
tags: Haskell
---
※ 本記事はextensible-effectsパッケージではなくextensibleパッケージの
`Data.Extensible.Effect`モジュールについての記事です


# 解答
　こんな感じにする。

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

import Data.Extensible

context :: Eff '["io" >: IO] ()
context = liftEff #io $ putStrLn "hi"

main :: IO ()
main = retractEff context
-- hi
```
