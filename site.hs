{-# LANGUAGE OverloadedStrings #-}

import Data.Monoid ((<>))
import Hakyll
import Text.Highlighting.Kate (styleToCss, pygments)


postCtx :: Tags -> Context String
postCtx tags =
  dateField "date" "%Y/%m/%d" <>
  tagsField "tags" tags <>
  defaultContext


main :: IO ()
main = hakyll $ do

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
      posts <- loadAll "posts/*" >>= recentFirst
      let archiveCtx = listField "posts" (postCtx tags) (return posts) <>
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
      let indexCtx = listField "posts" (postCtx tags) (return posts) <>
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
    compile $ makeItem (compressCss . styleToCss $ pygments)

  match "products.html" $ do
    route idRoute
    compile $ getResourceBody
      >>= loadAndApplyTemplate "templates/products.html" defaultContext
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  -- This is the part of index.html
  match "pickup-post.html" $ do
    route idRoute
    compile templateCompiler

  -- This is the part of index.html
  match "affiliate.html" $ do
    route idRoute
    compile templateCompiler
