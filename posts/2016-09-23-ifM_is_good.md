---
title: HaskellにはifMという関数がある
tags: Haskell
---
最近Haskellコードのcaseを多用するようになってたので、インデントレベルが3以上になってしまいそうで悩んでた X(

こんなん
```haskell
main :: IO ()
main = do
    x <- getFooMaybe  -- indent 1
    case x of
        Nothing -> ...
        Just x' -> do  -- indent 2
            ...  -- indent 3
            ...
```

インデントレベル3はギリギリとして、4以上になるとコードの醜さが顕著に…ね？

```haskell
main :: IO ()
main = do
    x <- getFooMaybe
    case x of
        Nothing -> ...
        Just x' -> do
            y <- getBarEither
            case y of
                Left  e -> fail e
                Right a -> do
                    putStrLn "succeed"
                    print a
```


# ifM
強い。

before
```haskell
import Control.Monad.Extra (ifM)

-- Read Twitter OAuth from serialized data file
readOAuth :: (MonadThrow m, MonadIO m) => m OAuth
readOAuth = do
maybeOAuth <- liftIO $ fmap read <$> getEnv "GORIRA_OAUTH"
case maybeOAuth of
    Just oauth -> return oauth
    Nothing    -> do
        x <- liftIO $ doesFileExist "resource/twitter_oauth"
        if x then liftIO $ read <$> readFile "resource/twitter_oauth"
             else throwM $ IOException' "'resource/twitter_oauth' is not exists"
```

after
```haskell
import Control.Monad.Extra (ifM)

-- Read Twitter OAuth from serialized data file
readOAuth :: (MonadThrow m, MonadIO m) => m OAuth
readOAuth = do
maybeOAuth <- liftIO $ fmap read <$> getEnv "GORIRA_OAUTH"
case maybeOAuth of
    Just oauth -> return oauth
    Nothing    -> ifM (liftIO $ doesFileExist "resource/twitter_oauth")
                    (liftIO $ read <$> readFile "resource/twitter_oauth")
                    (throwM $ IOException' "'resource/twitter_oauth' is not exists")
```
