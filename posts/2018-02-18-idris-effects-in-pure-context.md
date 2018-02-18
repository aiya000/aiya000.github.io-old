---
title: Run a program of Eff in pure contexts
tags: Idris
---
In a situation, I have a program (`Eff`) with a `STATE` effect,
and the program is pure.

It can be run in a pure context like below :joy:

```idris
import Control.Monad.Identity
import Effect.State
import Effects

main : IO ()
main = do
  let Id (_ ** [s]) = runEnv {m=Identity} [default] $ update (+1)
  printLn s
-- {output}
-- 1
```


# PS
I took a [Pull Request](https://github.com/idris-lang/Idris-dev/pull/4338),
Above code can be written as below (no `Identity` is needed),
if the PR is approved :dog2:

```idr
import Effect.State
import Effects

-- runPureEnv : (env : Env Basics.id xs) -> (prog : EffM Basics.id a xs xs') -> (x : a ** Env Basics.id (xs' x))
-- runPureEnv env prog = eff env prog (\r, env => (r ** env))

main : IO ()
main = do
  let (_ ** [s]) = runPureEnv [default] $ update (+1)
  printLn s
```
