{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid ((<>))
import Hakyll
import Text.Highlighting.Kate (styleToCss, pygments)


postCtx :: Context String
postCtx =
  dateField "date" "%Y/%m/%d" <>
  constField "host" "aiya000.github.io" <>
  --NOTE: Why "name" can be got if I use titleField ?
  listContextWith (titleField "tagName") "tagNames" "tags" <>
  defaultContext


-- See http://mattwetmore.me/posts/hakyll-list-metadata.html
-- |
-- listContextWith looks up @targetFieldName@,
-- splits the looking up result by ",",
-- set the split result as the field of @thisFieldName@ .
-- And the final result is taken as 'Context a'.
listContextWith :: Context String -> String -> String -> Context a
listContextWith ctx thisFieldName targetFieldName = listField thisFieldName ctx $ do
  metadata <- getUnderlying >>= getMetadata
  let metas = maybe [] (map trim . splitAll ",") $ lookupString targetFieldName metadata
  return $ map (twice $ Item . fromFilePath) metas
  where
    twice :: (a -> a -> b) -> a -> b
    twice f x = f x x


main :: IO ()
main = hakyll $ do
  tags <- buildTags "posts/*" $ fromCapture "tags/*.html"
  let tagCtx   = tagsField "tags" tags
      postCtx' = postCtx <> tagCtx

  tagsRules tags $ \tag pattern -> do
    route idRoute
    compile $ do
      posts <- loadAll pattern >>= recentFirst
      let ctx = constField "title" ("Posts tagged " ++ tag) <>
                listField "posts" postCtx' (return posts) <>
                defaultContext
      makeItem ""
        >>= loadAndApplyTemplate "templates/tag.html" ctx
        >>= loadAndApplyTemplate "templates/default.html" ctx
        >>= relativizeUrls

  match "images/**" $ do
    route idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match "js/*" $ do
    route idRoute
    compile copyFileCompiler

  match "about.md" $ do
    route $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "profile.html" $ do
    route idRoute
    compile $ getResourceBody
      >>= loadAndApplyTemplate "templates/profile.html" defaultContext
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "posts/*" $ do
    route $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/post.html" postCtx'
      >>= loadAndApplyTemplate "templates/default.html" postCtx'
      >>= relativizeUrls

  create ["archive.html"] $ do
    route idRoute
    compile $ do
      posts <- loadAll "posts/*" >>= recentFirst
      let archiveCtx = listField "posts" postCtx' (return posts) <>
                       constField "title" "Archives" <>
                       defaultContext
      makeItem ""
        >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
        >>= loadAndApplyTemplate "templates/default.html" archiveCtx
        >>= relativizeUrls

  match "index.html" $ do
    route idRoute
    compile $ do
      posts    <- loadAll "posts/*" >>= fmap (take 30) . recentFirst
      tagCloud <- renderTagCloud 80.0 200.0 tags
      let indexCtx = listField "posts" postCtx' (return posts) <>
                     constField "title" "Home" <>
                     constField "tagcloud" tagCloud <>
                     defaultContext
      getResourceBody
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/index.html"   indexCtx
        >>= loadAndApplyTemplate "templates/default.html" indexCtx
        >>= relativizeUrls

  match "templates/*" $ do
    compile templateCompiler

  create ["css/highlight.css"] $ do
    route idRoute
    compile $ makeItem (compressCss $ styleToCss pygments)

  match "products.html" $ do
    route idRoute
    compile $ getResourceBody
      >>= loadAndApplyTemplate "templates/products.html" defaultContext
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  -- These are the part of index.html
  match "pickup-post.html" $ do
    route idRoute
    compile templateCompiler
  match "affiliate.html" $ do
    route idRoute
    compile templateCompiler
