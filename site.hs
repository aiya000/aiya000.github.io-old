{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE ViewPatterns #-}

import Control.Lens ((<&>))
import Data.List (delete)
import Data.Monoid ((<>))
import GHC.IO.Encoding (setLocaleEncoding, utf8)
import Hakyll
import Text.Highlighting.Kate (styleToCss, pygments)
import Text.HTML.TagSoup (Tag(..), isTagOpenName, Attribute)
import Text.Pandoc.Options (ReaderOptions(readerExtensions), Extension(Ext_emoji), extensionsFromList)

-- See http://mattwetmore.me/posts/hakyll-list-metadata.html
--
-- |
-- listContextWith looks up @targetFieldName@,
-- splits the looking up result by ",",
-- set the split result as the field of @thisFieldName@ .
-- And the final result is taken as 'Context a'.
listContextWith :: Context String -> String -> String -> Context a
listContextWith context thisFieldName targetFieldName = listField thisFieldName context $ do
  metadata <- getUnderlying >>= getMetadata
  let metas = maybe [] (map trim . splitAll ",") $ lookupString targetFieldName metadata
  pure $ map (twice $ Item . fromFilePath) metas
  where
    twice :: (a -> a -> b) -> a -> b
    twice f x = f x x

main :: IO ()
main = do
  setLocaleEncoding utf8
  hakyllWith conf $ do
    tags <- buildTags "posts/*" $ fromCapture "tags/*.html"
    tagsRules tags $ \tag pat -> do
      route idRoute
      compile $ do
        let posts   = loadAll pat >>= recentFirst
        let context = constField "tag" tag <>
                      constField "title" ("Posts tagged " ++ tag) <>
                      listField "posts" post posts <>
                      defaultContext
        makeItem ""
          >>= loadAndApplyTemplate "templates/tag.html" context
          >>= loadAndApplyTemplate "templates/basic.html" context
          >>= loadAndApplyTemplate "templates/default.html" context
          >>= relativizeUrls

    match "images/**" $ do
      route idRoute
      compile copyFileCompiler

    match "css/**" $ do
      route idRoute
      compile compressCssCompiler

    match "js/*" $ do
      route idRoute
      compile copyFileCompiler

    match "node_modules/**/*" $ do
      route idRoute
      compile copyFileCompiler

    match "about.md" $ do
      route $ setExtension "html"
      compile $ modernPandocCompiler
        >>= loadAndApplyTemplate "templates/basic.html" defaultContext
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

    match "licenses.md" $ do
      route $ setExtension "html"
      compile $ modernPandocCompiler
        >>= loadAndApplyTemplate "templates/basic.html" defaultContext
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

    match "profile.html" $ do
      route idRoute
      compile $ getResourceBody
        >>= loadAndApplyTemplate "templates/basic.html" defaultContext
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls

    match "posts/*" $ do
      route $ setExtension "html"
      compile $ modernPandocCompiler
        >>= loadAndApplyTemplate "templates/post.html" post
        >>= loadAndApplyTemplate "templates/default.html" post
        >>= relativizeUrls

    -- To deploy ./node_modules
    create [".nojekyll"] $ do
      route idRoute
      compile $ makeItem @String ""

    create ["archive.html"] $ do
      route idRoute
      compile $ do
        let posts   = loadAll "posts/*" >>= recentFirst
        let context = listField "posts" post posts <>
                      constField "title" "Archives" <>
                      defaultContext
        makeItem ""
          >>= loadAndApplyTemplate "templates/archive.html" context
          >>= loadAndApplyTemplate "templates/basic.html" context
          >>= loadAndApplyTemplate "templates/default.html" context
          >>= relativizeUrls

    match "index.html" $ do
      route idRoute
      compile $ do
        tagCloud <- renderTagCloud 80.0 200.0 tags
        let posts   = loadAll "posts/*" >>= fmap (take 30) . recentFirst
        let context = listField "posts" post posts <>
                      constField "title" "Home" <>
                      constField "tagcloud" tagCloud <>
                      defaultContext
        getResourceBody
          >>= applyAsTemplate context
          >>= loadAndApplyTemplate "templates/basic.html" context
          >>= loadAndApplyTemplate "templates/default.html" context
          >>= relativizeUrls

    match "templates/*" $
      compile templateCompiler

    match "products.md" $ do
      route $ setExtension "html"
      compile $ modernPandocCompiler
        >>= loadAndApplyTemplate "templates/products.html" defaultContext
        >>= loadAndApplyTemplate "templates/default.html" defaultContext
        >>= relativizeUrls
  where
    -- See /posts/*.md and templates/post.html
    post :: Context String
    post =
      dateField "date" "%Y/%m/%d" <>
      constField "host" "aiya000.github.io" <>
      -- NOTE: Why "name" can be got if I use titleField ?
      listContextWith (titleField "tagName") "tagNames" "tags" <>
      defaultContext


-- | A `pandocCompiler` with emojis
modernPandocCompiler :: Compiler (Item String)
modernPandocCompiler =
  let readerExtensions' = readerExtensions defaultHakyllReaderOptions <>
                          extensionsFromList [Ext_emoji]
      readerOptions = defaultHakyllReaderOptions { readerExtensions = readerExtensions' }
  in fmap (withTags processTags) <$> pandocCompilerWith readerOptions defaultHakyllWriterOptions
  where
      processTags :: Tag String -> Tag String
      processTags tag@(isTagOpenName "table" -> True) = appendAttr tag ("class", "table table-bordered")
      processTags tag = tag

      appendAttr :: Tag String -> Attribute String -> Tag String
      appendAttr (TagOpen tagName attrs) newAttr@(attrName, attrValue) = TagOpen tagName $
        case lookup attrName attrs of
          Nothing     -> newAttr : attrs
          Just oldVal -> (attrName, oldVal ++ ' ' : attrValue) : delete (attrName, oldVal) attrs


conf :: Configuration
conf = defaultConfiguration { previewPort = 25252 }
