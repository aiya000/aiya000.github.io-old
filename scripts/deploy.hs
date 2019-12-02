#!/usr/bin/env stack
-- stack --resolver lts-14.15 --install-ghc runghc --package shelly --package text --package here --package safe-exceptions

{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

import Control.Exception.Safe (finally)
import Control.Monad (forM_, when)
import Data.Monoid ((<>))
import Data.String.Here (i)
import Data.Text (Text)
import qualified Data.Text as Text
import Shelly (Sh, shelly, verbosely, run, run_, (-|-), ls, toTextIgnore)

default (Text)

type FilePath' = Text

main :: IO ()
main = shelly . verbosely $ do
  currentBranch <- removeTrailLineBreak <$> run "git" ["branch"] -|- run "grep" ["^*"] -|- run "awk" ["{print $2}"]
  (prepare >> deploy) `finally` cleanUpTo currentBranch

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
  deleteOldFiles
  restoreContents
  deployToGit
  where
    deleteOldFiles = do
      backupDir <- ("/tmp/aiya000.github.io_" <>) . removeTrailLineBreak <$> run "date" ["+%Y-%m-%d_%H-%M-%S"]
      run_ "mkdir" [backupDir]
      files <- map toTextIgnore <$> ls "."
      forM_ files $ \file ->
        -- TODO: Normalize path of `file`
        when (file /= "./.git") $
          run_ "mv" ["-f", file, [i|${backupDir}/${file}|]]

    restoreContents = do
      contents <- map toTextIgnore <$> ls "/tmp/_site"
      forM_ contents $ \content ->
        run_ "mv" [content, "."]
      run_ "rm" ["-rf", "_cache"]

    deployToGit = do
      run_ "git" ["add", "--all"]
      now <- Text.strip <$> run "date" ["-R"]
      let message = "Build at [" <> now <> "]" <>
                    "\n\n" <>
                    "https://aiya000.github.io"
      run_ "git" ["commit", "-m", message]
      run_ "git" ["push", "-f", "origin", "master"]

removeTrailLineBreak :: Text -> Text
removeTrailLineBreak = Text.init
