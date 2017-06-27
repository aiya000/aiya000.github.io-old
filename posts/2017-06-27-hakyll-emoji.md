---
title: HakyllのCompilerでemoji（：dogs：）をコンパイルする
tags: Haskell
---
:diamond_shape_with_a_dot_inside: :dog2: :diamond_shape_with_a_dot_inside:
（`:diamond_shape_with_a_dot_inside:` `:dog2:` `:diamond_shape_with_a_dot_inside:`）


# :dog:
　僕のこのブログのposts/\*.mdは、以下のようにhtmlへ、site.hsによってコンパイルされます :+1:

```haskell
main :: IO ()
main = hakyll $ do
    -- 前略
    match "posts/*" $ do
    route $ setExtension "html"
    compile $ pandocCompiler
        >>= loadAndApplyTemplate "templates/post.html" postCtx
        >>= loadAndApplyTemplate "templates/default.html" postCtx
        >>= relativizeUrls
    -- 後略
```

`pandocCompiler`はhakyllによって以下のように定義されてます :smile:

```haskell
-- Hakyll.Web.Pandoc
pandocCompiler :: Compiler (Item String)
pandocCompiler = pandocCompilerWith defaultHakyllReaderOptions defaultHakyllWriterOptions
--pandocCompilerWith :: ReaderOptions -> WriterOptions -> Compiler (Item String)
```

`:smile:`のような絵文字をHakyllで使うには、`pandocCompilerWith`の`defaultHakyllReaderOptions`の`readerExtensions`に
`Text.Pandoc.Options.Extension`の`Ext_emoji`を追加してあげます。

```haskell
pandocCompilerWithEmoji :: Compiler (Item String)
pandocCompilerWithEmoji =
  let readerExtensions' = readerExtensions defaultHakyllReaderOptions
  in pandocCompilerWith
    defaultHakyllReaderOptions { readerExtensions = Set.insert Ext_emoji readerExtensions' }
    defaultHakyllWriterOptions

main :: IO ()
main = hakyll $ do
    -- 前略
    match "posts/*" $ do
    route $ setExtension "html"
    compile $ pandocCompilerWithEmoji -- !!
        >>= loadAndApplyTemplate "templates/post.html" postCtx
        >>= loadAndApplyTemplate "templates/default.html" postCtx
        >>= relativizeUrls
    -- 後略
```

:+1: :smiley:
