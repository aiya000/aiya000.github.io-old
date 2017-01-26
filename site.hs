--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid ( mappend )
import Hakyll
import qualified Text.Highlighting.Kate as HKate

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  tags <- buildTags "posts/*" (fromCapture "tags/*.html")

  tagsRules tags $ \tag pattern -> do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll pattern
      let tagCtx =
            constField "title" ("Posts tagged " ++ tag)      `mappend`
            listField  "posts" (postCtx tags) (return posts) `mappend`
            defaultContext
      makeItem ""
        >>= loadAndApplyTemplate "templates/tag.html"     tagCtx
        >>= loadAndApplyTemplate "templates/default.html" tagCtx
        >>= relativizeUrls

  match "images/**" $ do
    route   idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler

  match "js/*" $ do
    route   idRoute
    compile copyFileCompiler

  match "about.md" $ do
    route   $ setExtension "html"
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
    route   $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/post.html"    (postCtx tags)
      >>= loadAndApplyTemplate "templates/default.html" (postCtx tags)
      >>= relativizeUrls

  create ["archive.html"] $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll "posts/*"
      let archiveCtx =
            listField "posts" (postCtx tags) (return posts) `mappend`
            constField "title" "Archives"                   `mappend`
            defaultContext
      makeItem ""
        >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
        >>= loadAndApplyTemplate "templates/default.html" archiveCtx
        >>= relativizeUrls

  match "index.html" $ do
    route idRoute
    compile $ do
      posts    <- fmap (take 30) . recentFirst =<< loadAll "posts/*"
      tagCloud <- renderTagCloud 80.0 200.0 tags
      let indexCtx =
            listField  "posts"   (postCtx tags) (return posts) `mappend`
            constField "title"   "Home"                        `mappend`
            constField "tagcloud" tagCloud                     `mappend`
            defaultContext
      getResourceBody
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/index.html"   indexCtx
        >>= loadAndApplyTemplate "templates/default.html" indexCtx
        >>= relativizeUrls

  match "templates/*" $ compile templateCompiler

  create ["css/highlight.css"] $ do
    route idRoute
    compile $ makeItem (compressCss . HKate.styleToCss $ HKate.pygments)

  match "products.html" $ do
    route idRoute
    compile $ getResourceBody
      >>= loadAndApplyTemplate "templates/products.html"   defaultContext
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "pickup-post.html" $ do
    route idRoute
    compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Tags -> Context String
postCtx tags =
  dateField   "date"   "%Y/%m/%d" `mappend`
  teaserField "teaser" "content"  `mappend`
  tagsField   "tags"   tags       `mappend`
  defaultContext
