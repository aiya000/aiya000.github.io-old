---
title: Haskellの例外、今はコレ！ EitherT型
tags: プログラミング, Haskell
---
# Haskellの例外、今はコレ！ EitherT型
　Twitterで、Haskellのいい感じの型の使い方を聞きまくって、例外についての知見を得たので記事書きます :)

[こちら](https://github.com/Kinokkory/wiwinwlh-jp/wiki/%E3%82%A8%E3%83%A9%E3%83%BC%E5%87%A6%E7%90%86#error-handling)を参考にしたけど、
hackageバージョンの差異か そのままじゃ動かなかったので 調べて書き直した :D


## イケてるソース
```haskell
import Control.Error
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Either

data StringFail = StringEmpty deriving (Show)


main :: IO ()
main = do
  e <- runEitherT getLineNotEmpty
  reportResult e

getLineNotEmpty :: EitherT StringFail IO String
getLineNotEmpty = do
  s <- liftIO getLine
  if (null s)
     then left StringEmpty
     else return s

reportResult :: Either StringFail String -> IO ()
reportResult (Right r) = putStrLn $ "input: " ++ r
reportResult (Left  l) = putStrLn $ "bad input (" ++ (show l) ++ ")"
```

### もっとイケてるソース！ (2016-07-22追記)
　イマドキのHaskellでは、`EitherT`を隠蔽するのがいいらしい！  
また、`catch`もしてみました :P
```haskell
{-# LANGUAGE ScopedTypeVariables #-}

import Control.Monad.Catch
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Either

data StringFail = StringEmpty deriving (Show)
instance Exception StringFail


main :: IO ()
main = do
  Right x <- runEitherT $ getLineNotEmpty `catch` \(e :: SomeException) -> return "alternative string"
  putStr "x value is always right: "
  print x

getLineNotEmpty :: (MonadCatch m, MonadIO m) => m String
getLineNotEmpty = do
  s <- liftIO getLine
  if (null s)
     then throwM StringEmpty
     else return s
```

- `catch`することで、常にRight値を得られます
- `EitherT`を隠蔽することで、(`MonadCatch`及び)`MonadIO`の文脈であることが強調されます
- `left`は`MonadThrow`の`throwM`によって隠蔽されます


## なんなの？
　か…カッケー！！！！！  
leftはEitherT版のthrow関数っぽいもの。

　所謂例外からIOを乖離させたもの、つまり純粋計算で例外を用いることができる。  
また、`EitherT`はモナド変換子なので、従来通り不純な計算でも扱える。  
例外(`Monad m => EitherT e m a`)は`Monad m => m (Either e a)`で受け取れる。

砕いて言うと、従来の例外を扱える + ある例外に注視させることができる(型レベル)。

「従来」のコードの想定例(擬似コード)
```haskell
{-# LANGUAGE ScopedTypeVariables #-}

main :: IO ()
main = do
  errorContainedFunction "message" `catch` \(e :: SomeException) ->
    putStrLn "Caught an error:"
    print e

errorContainedFunction :: a -> IO ()
errorContainedFunction x = do
  ...
  if hoge
    then fail "bad"
    else return good
```

純粋計算での例外
```haskell
{-# LANGUAGE ScopedTypeVariables #-}
import Control.Error
import Control.Monad
import Control.Monad.Identity
import Control.Monad.Trans.Either

type CalcError  = String
type CalcResult = EitherT CalcError Identity Int


main :: IO ()
main = do
  let result1 = runIdentity . runEitherT $ 10 `safeDiv` 0
  let result2 = runIdentity . runEitherT $ 10 `safeDiv` 5
  report result1
  report result2

report :: Either CalcError Int -> IO ()
report result =
  case result of
       (Left  e) -> putStr "Caught an error: " >> print e
       (Right a) -> putStr "Good: " >> print a

safeDiv :: Int -> Int -> CalcResult
safeDiv x y = do
  if y == 0
     then left "Div by zero exception"
     else return $ x `div` y

--
-- Caught an error: "Div by zero exception"
-- Good: 2
--
```

純粋計算でdoが使えてるのはおまけ (Eitherモナド)。
