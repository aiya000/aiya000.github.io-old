{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
import Control.Monad ( forM_ )
import Shelly
import Data.Text ( Text, strip, append )

default ( Text )

main :: IO ()
main = shelly . verbosely $
  deploy `finally_sh` run_ "git" ["checkout", "develop"]

deploy :: Sh ()
deploy = do
  run_ "stack" ["exec", "site", "build"]
  run_ "cp"    ["-r", "./_site", "/tmp/_site"]
  run_ "git"   ["checkout", "master"]

  -- Remove all file
  existFiles <- ls "."
  forM_ existFiles $ \file -> do
    if toTextIgnore file == "./.git"
       then liftIO $ putStrLn ".git directory was found, it didn't deleted"
       else run_ "rm"  ["-rf", toTextIgnore file]

  -- Copy backed up files
  newFiles   <- ls "/tmp/_site"
  forM_ newFiles $ \file -> do
    run_ "mv"  [toTextIgnore file, "."]

  -- Clean temporary directory
  run_ "rm"  ["-rf", "/tmp/_site"]

  -- Deploy to repository
  run_ "git" ["add", "--all"]
  now <- run "date" ["-R"]
  let now'    = strip now
      message = "Build at [" `append` now' `append` "]"
  run_ "git" ["commit", "-m", message]
  run_ "git" ["push", "origin", "master"]
