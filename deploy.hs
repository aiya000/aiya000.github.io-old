{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
import Control.Monad ( forM_ )
import Shelly
import System.Directory ( getTemporaryDirectory )
import System.IO.Temp ( withTempDirectory )
import qualified Data.Text as Text
import qualified Data.Text.IO as TIO

default ( Text.Text )

main :: IO ()
main = shelly . verbosely $ do
  run_ "mv"  ["_site", "/tmp/_site"]
  run_ "git" ["checkout", "master"]
  files <- ls "/tmp/_site"
  forM_ files $ \file -> do
    run_ "mv"  [toTextIgnore file, "."]
  run_ "rm"  ["-rf", "/tmp/_site"]
