---
title: 単相化された存在型のランク2での謎
tags: Haskell, 備考録
---

- [ランク2多相をランク1多相として使おうとしたときの問題？](#%E3%83%A9%E3%83%B3%E3%82%AF2%E5%A4%9A%E7%9B%B8%E3%82%92%E3%83%A9%E3%83%B3%E3%82%AF1%E5%A4%9A%E7%9B%B8%E3%81%A8%E3%81%97%E3%81%A6%E4%BD%BF%E3%81%8A%E3%81%86%E3%81%A8%E3%81%97%E3%81%9F%E3%81%A8%E3%81%8D%E3%81%AE%E5%95%8F%E9%A1%8C)
- [回答](#%E5%9B%9E%E7%AD%94)


# ランク2多相をランク1多相として使おうとしたときの問題？
　これはできるのですが

```haskell
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}

import Control.Monad (void)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.String (IsString, fromString)
import System.Environment (getEnv)


type FilePath' = forall s. IsString s => s


inHomeDir :: MonadIO m => (FilePath' -> m a) -> m a
inHomeDir f = do
  homeDir <- liftIO $ getEnv "HOME"
  f $ fromString homeDir


printFooAppDir :: IO ()
printFooAppDir = inHomeDir body
  where  -- 型を明示するために関数分割してます
    body :: FilePath -> IO ()
    body homeDir = putStrLn $ homeDir ++ "/.config/foo"


main :: IO ()
main = printFooAppDir
```

これは

```haskell
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}

import Control.Monad (void)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Monoid ((<>))
import Data.String (IsString, fromString)
import Data.Text (Text)
import Data.Typeable (Typeable)
import Data.Typeable (cast)
import System.Environment (getEnv)
import qualified Data.Text.IO as TIO


type FilePath' = forall s. IsString s => s

newtype BakaFilePath = BakaFilePath { unBakaFilePath :: Text }
  deriving (IsString, Monoid, Typeable)

putBakaLn :: BakaFilePath -> IO ()
putBakaLn = TIO.putStrLn . unBakaFilePath


inHomeDir :: MonadIO m => (FilePath' -> m a) -> m a
inHomeDir f = do
  homeDir <- liftIO $ getEnv "HOME"
  f $ fromString homeDir


printFooAppDir :: IO ()
printFooAppDir = id' . inHomeDir $ body . cast'
  where
    -- MonadIO mからMonadIO nへの単相的な変換。 IO ()を期待する
    id' :: IO () -> IO ()
    id' = id

    cast' :: FilePath -> Maybe BakaFilePath
    cast' = cast

    body :: Maybe BakaFilePath -> IO ()
    body Nothing = error "baka"
    body (Just bakaHomeDir) = putBakaLn $ bakaHomeDir <> "/.config/foo"


main :: IO ()
main = printFooAppDir
```

こうなり

```
Test.hs|34 col 24| error:
     • Couldn't match type ‘FilePath’ with ‘FilePath'’
       Expected type: (FilePath -> IO ()) -> IO ()
         Actual type: (FilePath' -> IO ()) -> IO ()
     • In the second argument of ‘(.)’, namely ‘inHomeDir’
       In the expression: id' . inHomeDir
       In the expression: id' . inHomeDir $ body . cast'
```

コンパイルに失敗します。  
`(bakaHomeDir :: BakaFilePath) <> ("/.config/foo" :: BakaFilePath)`としてもだめ。


# 回答
　inHomeDirを単相化すればいいみたい。

```haskell
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types #-}

import Control.Monad (void)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Monoid ((<>))
import Data.String (IsString, fromString)
import Data.Text (Text)
import Data.Typeable (Typeable)
import Data.Typeable (cast)
import System.Environment (getEnv)
import qualified Data.Text.IO as TIO


type FilePath' = forall s. IsString s => s

newtype BakaFilePath = BakaFilePath { unBakaFilePath :: Text }
  deriving (IsString, Monoid, Typeable)

putBakaLn :: BakaFilePath -> IO ()
putBakaLn = TIO.putStrLn . unBakaFilePath


inHomeDir :: MonadIO m => (FilePath' -> m a) -> m a
inHomeDir f = do
  homeDir <- liftIO $ getEnv "HOME"
  f $ fromString homeDir


printFooAppDir :: IO ()
printFooAppDir = id' . (inHomeDir :: (FilePath -> IO ()) -> IO ()) $ body . cast'
  where
    id' :: IO () -> IO ()
    id' = id

    cast' :: FilePath -> Maybe BakaFilePath
    cast' = cast

    body :: Maybe BakaFilePath -> IO ()
    body Nothing = error "baka"
    body (Just bakaHomeDir) = putBakaLn $ bakaHomeDir <> "/.config/foo"


main :: IO ()
main = printFooAppDir
```

- - -

これcastに失敗してNothingしてerror呼ぶけど、問題ないね！  
コンパイル通れば、あとはどうとでもできる。

これは、xmonadとshellyを使う際に、
xmonadの関数がStringを期待するのに対して、
shellyがsystem-filepathのFilePathという独自のデータ型を扱っている故に遭遇したもの……
の簡略系となっています。

- - -

皆様どうか、楽しい多相ライフを！
