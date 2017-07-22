---
title: Effモナドの効果のうち1つだけをrunする
tags: Haskell
---
　例えばこのような`partialContext`関数と`totalContext`関数があるとき

~~partialContext :: forall s. (Member (Reader Logs) s, SetMember Lift (Lift IO) s) => Eff s ()~~

```haskell
partialContext :: Eff (Reader Logs :> Lift IO :> Void) ()
totalContext :: Eff (Writer Logs :> Reader Logs :> Lift IO :> Void) ()
```

`partialContext`内で`totalContext`を走らせることができる。
（今回の試みでは`partialContext`を  
`partialContext :: (Member (Reader Logs) s, SetMember Lift (Lift IO) s) => Eff s ()`  
のように多相化することには失敗していて、ただし`totalContext`は以下のように多相化してもよい  
`totalContext :: (Member (Writer Logs) r, Member (Reader Logs) r, SetMember Lift (Lift IO) r) => Eff r ()`  
）


# コード（実例）

output
```
["nozomi","eli"] was added
(["nozomi","eli","nico","maki"],())
()
```

実例

```haskell
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}

import Control.Eff (Eff, Member, run, (:>), SetMember)
import Control.Eff.Lift (Lift, lift, runLift)
import Control.Eff.Reader.Lazy (Reader, ask, runReader)
import Control.Eff.State.Lazy (State, get, put, runState)
import Control.Eff.Writer.Lazy (Writer, tell, runWriter, runMonoidWriter)
import Data.Void (Void)

type Logs = [String]

-- Writer Logs, Reader Logs, Lift IOを使う文脈があるじゃろ
totalContext :: (Member (Writer Logs) r, Member (Reader Logs) r, SetMember Lift (Lift IO) r) => Eff r ()
totalContext = do
  logs <- ask
  tell (logs :: Logs)
  lift . putStrLn $ show logs ++ " was added"

-- そのうちReader Logs, Lift IOのみを使う文脈がある
--partialContext :: forall s. (Member (Reader Logs) s, SetMember Lift (Lift IO) s) => Eff s ()
partialContext :: Eff (Reader Logs :> Lift IO :> Void) ()
partialContext = do
  x <- runWriter' totalContext
  lift $ print x
  where
    -- そうすると、なんとWriter Logs効果だけを消費することができるのじゃ！
    --TODO: totalContextを単相化する必要があるので、それを含むpartialContextを多相化できない。どうすればいい？
    runWriter' :: Eff (Writer Logs :> s) () -> Eff s (Logs, ())
    runWriter' = runWriter (++) ["nico", "maki"]

main :: IO ()
main = do
  x <- runLift $ runReader partialContext ["nozomi", "eli"]
  print x
```


# 解説
　まずここでは`Eff`型コンストラクタの第一引数に指定される型を効果と呼んでいる:dog2:  
（Monad……と呼称するのが一番しっくりくると思うけど、残念ながら現時点でextensible-effectsの`Writer`や`Reader`はMonadインスタンスになってないので！）

で、`partialContext`は効果の数が少ないという意味で`totalContext`よりも小さい。  
なので`totalContext`の効果のうち`partialContext`の持っていない`Write Logs`効果を引いてしまえば、
`partialContext`の効果と`totalContext`の持つ効果が等しくなるので、同じ文脈として（同じ`Eff a`モナドとして）使えるのではないかと思った。
そして、やったらできた。

　件の、効果の引き算になっているのはこれ

```haskell
runWriter' :: Eff (Writer Logs :> s) () -> Eff s (Logs, ())
runWriter' = runWriter (++) ["nico", "maki"]
```

引き算の性質は型に表れていて、`Writer Logs :> s`から`Writer Logs`を引いている。
なので`runWriter' totalContext`は

```haskell
runWriter' totalContext :: (Member (Reader Logs) s', SetMember Lift (Lift IO) s') => Eff s' (Logs, ())
```
という型になって、単相化するとこれは`partialContext`の文脈（`Eff a`モナドの形）と等しいので、

```haskell
runWriter' totalContext :: Eff (Reader Logs :> Lift IO :> Void) (Logs, ())
--                         ^==================================v
partialContext          :: Eff (Reader Logs :> Lift IO :> Void) ()
```

`runWriter' totalContext`は`partialContext`の中で`<-`できる！
（`partialContext`が単相的なので、`runWriter' totalContext`は型推論により単相化される）


# 何に使えるの？

```haskell
base :: (Member (State Foo) r, SetMember Lift (Lift IO) r) => Eff r ()
```

という文脈がある中で、局所的に失敗する文脈を扱える。
（以下は、局所的に失敗する文脈`child`）

```haskell
child :: (Member (Exc String) r, Member (State Foo) r, SetMember Lift (Lift IO) r) => Eff r ()
```

（と言いたいんだけど実際は、実用するには`base`を単相化する必要があって……誰か`base`……
実例における`partialContext`……を多相的なままにしておける方法知らない？）
