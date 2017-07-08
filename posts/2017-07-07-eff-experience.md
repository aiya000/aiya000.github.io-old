---
title: extensible-effects入門者がextensible-effectsをやってみた軌跡
tags: haskell
---
今回の成果はこちらです :+1:

- [Use Eff - aiya000/hs-zuramaru@6219179 - GitHub](https://github.com/aiya000/hs-zuramaru/commit/62191798c0d305b5ad0bedf32a8dc3b9b63793f6)


# extensible-effectsって？
　`MonadTrans`のモナドスタックを代替するものです。
例えばこんな感じのMonad文脈を

```haskell
f :: StateT Foo (ReaderT Bar IO) Int
f = return 10
```

こんな感じに書けます。

```haskell
f :: (Member (State Foo) r, Member (Reader Bar) r, SetMember Lift (Lift IO))
     => Eff r Int
f = return 10
```


## 何が嬉しいの？
　`MonadTrans`の`lift`の繰り返し由来のパフォーマンスダウンや
`lift`の繰り返しがなくなるそうです。

……が、大体の（非決定的な）`MonadTrans`インスタンスがこんな感じになってくれているおかげで

```haskell
instance MonadState s m => MonadState s (MaybeT m)
instance MonadReader r m => MonadReader r (MaybeT m)
```

僕は全く`lift`の繰り返しをしなければいけない事態になったことがないのでした :dog2:

例えば上の`UndecidableInstances`は、以下を可能にするよ。（`liftIO`が1つ、くらいしかない）

```haskell
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

import Control.Applicative (Alternative)
import Control.Arrow ((>>>))
import Control.Monad (MonadPlus, mzero)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Reader (MonadReader, ReaderT, runReaderT, ask)
import Control.Monad.State.Lazy (MonadState, StateT, runStateT, get, put)
import Control.Monad.Trans.Maybe (MaybeT, runMaybeT)

data MyState = MyState
  { foo :: Int
  } deriving (Show)

initialMyState :: MyState
initialMyState = MyState 10

data MyROM = MyROM
  { bar :: Int
  } deriving (Show)

defaultMyROM = MyROM 20

newtype Mine a = Mine
  { _runMine :: MaybeT (StateT MyState (ReaderT MyROM IO)) a
  } deriving ( Functor, Applicative, Monad
             , Alternative, MonadPlus
             , MonadState MyState
             , MonadReader MyROM
             , MonadIO
             )

runMine :: Mine a -> IO (Maybe a, MyState)
runMine = _runMine
            >>> runMaybeT
            >>> flip runStateT initialMyState
            >>> flip runReaderT defaultMyROM

k :: Mine ()
k = do
  MyState foo' <- get
  MyROM bar'   <- ask
  let result = foo' + bar'
  put $ MyState result
  liftIO $ print result
  mzero -- Mine's mzero is MaybeT's Nothing

main :: IO ()
main = do
  (result, s) <- runMine k
  print s
  print result
--- vvv output vvv
-- 30
-- MyState {foo = 30}
-- Nothing
```

おっと、effの話だった :laughing:

- - -

はい、effはモナドスタックを使ったアプローチよりもパフォーマンスがいいらしい？
し、面白そうなのでやってみました。


# その1
　まず`FlexibleContexts`します。


# その2 - 型制約Member m rでmを文脈に引き込む
　Effを使う時は、**多分**基本的に関数の型はこんな感じの形をしてます。

```haskell
effContext :: (Member (State Foo) r, Member (Reader Bar) r) => Eff r a
```

この関数の型制約`(Member (State Foo) r, Member (Reader Bar) r)`は
`State Foo`と`Reader Bar`を`Eff r`で使えるようにします。

例えばこんな感じ

```haskell
effContext' :: (Member (State Int) r, Member (Reader Char) r) => Eff r Int
effContext' = do
  x <- ask
  y <- get
  let result = ord x + y
  put result
  return result
```

`lift`無しで`ask`も`get`も使えてます :exclamation: :exclamation:


# その3 - 具体型
　ところでさっきの`effContext'`、こうやっていたいんですが

```haskell
main :: IO ()
main = do
  let x = run . runState 10 $ runReader effContext' 'a'
  print x
```

eff独特のやばみのエラーが出るので、型付けしてあげます。

```haskell
main :: IO ()
main = do
  let x = run . runState 10
          $ flip runReader 'a' (effContext' :: Eff (Reader Char :> State Int :> Void) Int)
  print x
-- vvv output vvv
-- (107,107)
```

　`Eff (Reader Char :> State Int :> Void) Int`という型が見てとれると思いますが、これは`runReader`, `runState`, `run`と連動していて、

```haskell
runReader ::    Eff (Reader Char :> State Int :> Void) Int -> Char
             -> Eff (               State Int :> Void) Int
runState  :: Int -> Eff (State Int :> Void) Int
                 -> Eff (             Void) Int
run :: Eff Void Int -> Int
```

という感じで、runFooは`a :> b :> .. :> Void`の`a`（一番左）を引っぺがす役割りになっています :+1:  
まあ`Eff`の`a :> b :> .. :> v`って幽霊型らしいんですけどね。 すげええ。

そして`run :: Eff Void (Int, Int) -> (Int, Int)`が`Eff Void`を引っぺがして、通常の世界に戻ってきます。

- - -

　ここまでのまとめのコードです。

```haskell
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}

import Control.Eff (Member, Eff, (:>), run)
import Control.Eff.Reader.Lazy (Reader, ask, runReader)
import Control.Eff.State.Lazy (State, get, put, runState)
import Data.Char (ord)
import Data.Void (Void)

effContext' :: (Member (State Int) r, Member (Reader Char) r) => Eff r Int
effContext' = do
  x <- ask
  y <- get
  let result = ord x + y
  put result
  return result


main :: IO ()
main = do
  let x = run -- run :: Eff Void (Int, Int) -> (Int, Int)
          . runState 10
          $ flip runReader 'a' -- runReader :: Eff (Reader Char :> State Int :> Void) Int -> Char -> Eff (State Int :> Void) Int
              (effContext' :: Eff (Reader Char :> State Int :> Void) Int)
  print x
```


# その3.5 - めんどいWriter
　実はeffの`State`, `Reader` そして `Writer`は、effによって独自に定義されているんですよね。
そして`Writer`が`Monoid w => MonadWriter w (Writer w)`インスタンスになっていなくって、`Monoid`周りがすごくめんどくなってる。
（いつものように`runWriter`するだけじゃ足りない）


型を見るとすごくて、なんか関数と初期値を引数に要求されてる。

```haskell
-- (w -> b -> b)
-- b
runWriter :: Typeable w => (w -> b -> b) -> b -> Eff (Writer w :> r) a -> Eff r (b, a)
```

どうするかというと、こんな感じにやってあげるか

```haskell
effWriterContext :: Member (Writer [String]) r => Eff r ()
effWriterContext = do
  tell ["wakaba"]
  tell ["hinata"]
```

```haskell
main :: IO ()
main = do
  let x = run $ runWriter (++) [] (effWriterContext :: Eff (Writer [String] :> Void) ())
  print x
-- vvv output vvv
-- (["wakaba","hinata"],())
```

`runMonoidWriter`という補助関数を使ってあげます。

```haskell
main :: IO ()
main = do
  let x = run $ runMonoidWriter (effWriterContext :: Eff (Writer [String] :> Void) ())
  print x
```

まとめ。

```haskell
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}

import Control.Eff (Member, Eff, (:>), run)
import Control.Eff.Writer.Lazy (Writer, tell, runWriter, runMonoidWriter)
import Data.Void (Void)

effWriterContext :: Member (Writer [String]) r => Eff r ()
effWriterContext = do
  tell ["wakaba"]
  tell ["hinata"]

main :: IO ()
main = do
  --let x = run $ runWriter (++) [] (effWriterContext :: Eff (Writer [String] :> Void) ())
  let x = run $ runMonoidWriter (effWriterContext :: Eff (Writer [String] :> Void) ())
  print x
```


# その3.7 - チガウ
　もう気づかれたかもしれませんが、我々の知る`runState`とは引数の順序が違うんですよね。
ナンデ！？
「s -> (a, s)の抽象」という役割を離れたから！？


# その4 - IOとか
　ところで`Member t r`の`t`には、我々のよく親しんだ`IO`や`Maybe`は設定できません。
`runIO`や`runMaybe`がeffにないので :cry:

　そこで`SetMember`という、`(:>)`の連鎖の中の、唯一の`Lift m`を解凍できる型で、それを設定してあげます。
`Lift m`は`runLift`によって、`(:>)`の連鎖の中に1つだけ許されます。
（`Lift IO :> Lift Maybe :> Void`とかはだめで、`Lift IO :> Void`は良い）

こんな感じ。

```haskell
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}

import Control.Eff (Member, SetMember, Eff, (:>))
import Control.Eff.Lift (Lift, lift, runLift)
import Control.Eff.Reader.Lazy (Reader, ask, runReader)
import Control.Eff.State.Lazy (State, get, put, runState)
import Control.Eff.Writer.Lazy (Writer, tell, runWriter, runMonoidWriter)
import Data.Char (ord)
import Data.Void (Void)

effContext'' :: ( Member (Writer [String]) r
                , SetMember Lift (Lift IO) r
                ) => Eff r ()
effContext'' = do
  input <- lift getLine
  tell [input]
  return ()


main :: IO ()
main = do
  x <- runLift $ runMonoidWriter (effContext'' :: Eff (Writer [String] :> Lift IO :> Void) ())
  print x
-- vvv input vvv
-- aaa
-- vvv output vvv
-- (["aaa"],())
```

以上、進捗でした。


# ところで
　`MaybeT IO a`みたいなものを使いたいんだけど、どうすればいいんだろう。
もういっそ`SetMember Lift (Lift IO) r => MaybeT (Eff r) a`使っちゃう？？ :laughing:


# 参考ページ
- [Control.Eff](https://hackage.haskell.org/package/extensible-effects-1.11.0.4/docs/Control-Eff.html)
- [Control.Eff.Lift](https://hackage.haskell.org/package/extensible-effects-1.11.0.4/docs/Control-Eff-Lift.html)
- [extensible-effectsのReader, Writer, Stateを試してみる - Qiita](http://qiita.com/myuon_myon/items/a172ed5d765b4385d974)
- [EffのState上でLensのアクセサを利用する - Creatable a =&gt; a -&gt; IO b](http://tune.hateblo.jp/entry/2014/10/08/165935)
