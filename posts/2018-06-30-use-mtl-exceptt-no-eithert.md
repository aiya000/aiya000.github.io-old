---
title: mtlのExceptTを使うべき。EitherTでもtransformersのExceptTでもなく。
tags: Haskell
---
　EitherのMonadTrans相当のものを使いたいときに、何を使うべきか毎回忘れてしまうので、メモしておきます。

下記の理由により現在は、eitherのEitherTまたはtransformersのExceptTではなく、mtlのExceptTを使うべきです。

- eitherのEitherTはDeprecated
- transformersのExceptTは`MonadExcept e m | m -> s`相当のものがないので
  `GenralizedNewtypeDeriving`すると効力を無くす（`deriving MonadExcept E`できない）
- mtlのExceptTには`MonadError e m | m -> e`がある
