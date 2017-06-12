{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}

import Control.Monad (forM_, when)
import Data.Monoid ((<>))
import Data.Text (Text, strip)
import Shelly

default (Text)


main :: IO ()
main = shelly . verbosely $ do
  (prepare >> deploy) `finally_sh` cleanUp


prepare :: Sh ()
prepare = do
  run_ "stack" ["exec", "site", "build"]
  run_ "cp" ["-r", ".stack-work", "/tmp/.stack-work"]
  run_ "cp" ["-r", "_site", "/tmp/_site"]
  run_ "git" ["checkout", "master"]

cleanUp :: Sh ()
cleanUp = do
  run_ "git" ["checkout", "develop"]
  run_ "mv" ["/tmp/.stack-work", "."]
  run_ "rm" ["-rf", "/tmp/_site"]


deploy :: Sh ()
deploy = do
  -- Delete the all file in the master branch
  existFiles <- ls "."
  forM_ existFiles $ \file -> do
    --TODO: Normalize path of `file`
    when (toTextIgnore file /= "./.git") $
      run_ "rm" ["-rf", toTextIgnore file]

  -- Move the backed up contents to here
  newFiles <- ls "/tmp/_site"
  forM_ newFiles $ \file -> do
    run_ "mv" [toTextIgnore file, "."]
  -- _cache is unneeded by the site
  run_ "rm" ["-rf", "_cache"]

  -- Deploy to the repository
  run_ "git" ["add", "--all"]
  now <- strip <$> run "date" ["-R"]
  let message = "Build at [" <> now <> "]"
  run_ "git" ["commit", "-m", message]
  run_ "git" ["push", "-uf", "origin", "master"]
