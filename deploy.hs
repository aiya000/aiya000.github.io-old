{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
import Control.Monad ( forM_ )
import Shelly
import qualified Data.Text as Text

default ( Text.Text )

main :: IO ()
main = shelly . verbosely $ do
  run_ "mv"  ["_site", "/tmp/_site"]
  run_ "git" ["checkout", "master"]
  existFiles <- ls "."
  forM_ existFiles $ \file -> do
    if toTextIgnore file == "./.git"
       then liftIO $ putStrLn ".git directory was found, it didn't deleted"
       else run_ "rm"  ["-rf", toTextIgnore file]
  newFiles   <- ls "/tmp/_site"
  forM_ newFiles $ \file -> do
    run_ "mv"  [toTextIgnore file, "."]
  run_ "rm"  ["-rf", "/tmp/_site"]
