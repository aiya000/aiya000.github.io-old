---
title: 【結論】Textの中のStringにmap：String→StringするにはProfunctorが一番！
tags: Haskell
---
# 起
　ときどきTextにpack,unpackを介してString -> Stringしたくなるシチュエーションに出会う。
でも普通に関数合成すると、なんだか格好悪いんだよね。

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Data.Char (toUpper)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

-- Data.TextのtoUpperを使えとか言っちゃだめ！ そしたら別の適切な例を教えて！
upper :: String -> String
upper = map toUpper

x :: Text
x = "nico"

main :: IO ()
main = do
  let niconico = T.pack . upper $ T.unpack x -- 格好悪い
  TIO.putStrLn niconico
```


# 結
　`Profunctor`の`dimap`を使う。
`(->)`Profunctorを使えばdomainとcodomainの変更を一気にできるので、
`Text -> String`と`String -> String`と`String -> Text`を格好良くできる！（まあ中身は👆と全くおんなじなんだけどでも見栄えいい）

　これはその型と同型の型への操作に一般化できますので、`newtype`にも応用できます。

```haskell
{-# LANGUAGE OverloadedStrings #-}

import Data.Char (toUpper)
import Data.Profunctor (dimap)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

upper :: String -> String
upper = map toUpper

x :: Text
x = "nico"

main :: IO ()
main = do
  let niconico = dimap T.unpack T.pack upper x -- 平坦な構文に見えるので、見やすい
  TIO.putStrLn niconico
```

```haskell
-- newtype Identity a = Identity { runIdentity :: a }
dimap runIdentity Identity f x
```


# その他

- [Foundation.Collection InnerFunctor - Hackage](http://hackage.haskell.org/package/foundation-0.0.10/docs/Foundation-Collection.html#t:InnerFunctor)
    - 最初に考えたアプローチがちょうどこれで、でもTextのインスタンスがなかった
- [Data.MonoTraversable - MonoFunctor - Hackage](https://hackage.haskell.org/package/mono-traversable-1.0.2/docs/Data-MonoTraversable.html#t:MonoFunctor)
    - `InnerFunctor`と全く同じアプローチで`Text`インスタンスもある、けど`Element`が`Char`だった。 普通に考えればそうだよね
    - `Text`のnewtypeを作ってもいいけど、それならpack,unpackした方が早いと思ったのでやめた
