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
  files <- ls "/tmp/_site"
  forM_ files $ \file -> do
    run_ "mv"  [toTextIgnore file, "."]
  run_ "rm"  ["-rf", "/tmp/_site"]
