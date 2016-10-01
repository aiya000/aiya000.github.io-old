---
title: Haskellのmplusってもしかしてすごい便利じゃない？
tags: Haskell
---
束縛(<-)とcaseでインデントが多くネストしてしまいそうな式でも、少ないインデントで済ませられる。

# Maybeで使う
```haskell
import Control.Monad (liftM2)
import Control.Monad (MonadPlus(..))

main :: IO ()
main = do
  print $ Nothing  `mplus` return 1
  print $ return 1 `mplus` (return 2 :: Maybe Int)
  print $ Nothing  `mplus` (Nothing  :: Maybe Int)
  let x = return (return 1) :: IO (Maybe Int)
  let y = return Nothing    :: IO (Maybe Int)
  print =<< liftM2 mplus x y
```

```
Just 1
Just 1
Nothing
Just 1
```


# (IO Maybe)で使う
```haskell
fooDBFile :: (MonadIO m, MonadThrow m) => m (Maybe FilePath)
fooDBFile = do
  let maybeDir = liftM2 mplus (getEnv "XDG_DATA_DIR") (getEnv "HOME")
  case maybeDir of
    dir     -> dir ++ "/foo.db"
    Nothing -> error
```


ベンリ。
