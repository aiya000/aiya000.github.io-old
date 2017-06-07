These files are not shown as the url directly.  
But these are loaded by site.hs .

For example:

```haskell
match "profile.html" $ do
route idRoute
compile $ getResourceBody
  >>= loadAndApplyTemplate "templates/profile.html" defaultContext
  >>= loadAndApplyTemplate "templates/default.html" defaultContext
  >>= relativizeUrls
```
