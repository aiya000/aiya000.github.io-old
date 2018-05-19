#!/usr/bin/env stack
-- stack --resolver lts-8.11 --install-ghc runghc --package shelly --package text
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}

import Control.Monad (forM_, when)
import Data.Monoid ((<>))
import Data.Text (Text)
import qualified Data.Text as T
import Shelly

default (Text)

type FilePath' = Text

main :: IO ()
main = shelly . verbosely $ do
  currentBranch <- removeTrailLineBreak <$> run "git" ["branch"] -|- run "grep" ["^*"] -|- run "awk" ["{print $2}"]
  (prepare >> deploy) `finally_sh` cleanUpTo currentBranch
  where
    removeTrailLineBreak = T.init

prepare :: Sh ()
prepare = do
  run_ "stack" ["exec", "site", "build"]
  run_ "cp" ["-r", ".stack-work", "/tmp/.stack-work"]
  run_ "cp" ["-r", "_site", "/tmp/_site"]
  run_ "git" ["checkout", "master"]

cleanUpTo :: FilePath' -> Sh ()
cleanUpTo prevBranch = do
  run_ "git" ["checkout", prevBranch]
  run_ "rm" ["-rf", ".stack-work"]
  run_ "mv" ["/tmp/.stack-work", "."]
  run_ "rm" ["-rf", "/tmp/_site"]

deploy :: Sh ()
deploy = do
  -- Delete the all file in the master branch
  existFiles <- ls "."
  forM_ existFiles $ \file ->
    --TODO: Normalize path of `file`
    when (toTextIgnore file /= "./.git") $
      run_ "rm" ["-rf", toTextIgnore file]

  -- Move the backed up contents to here
  newFiles <- ls "/tmp/_site"
  forM_ newFiles $ \file ->
    run_ "mv" [toTextIgnore file, "."]
  -- _cache is unneeded by the site
  run_ "rm" ["-rf", "_cache"]

  -- Deploy to the repository
  run_ "git" ["add", "--all"]
  now <- T.strip <$> run "date" ["-R"]
  let message = "Build at [" <> now <> "]"
                <> "\n\n"
                <> "https://aiya000.github.io"
  run_ "git" ["commit", "-m", message]
  run_ "git" ["push", "-uf", "origin", "master"]
