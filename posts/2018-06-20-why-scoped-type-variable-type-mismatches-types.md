---
title: ScopedTypeVariables下の1ランク多相で型が合わないとき
tags: Haskell
---
# まとめ
　forallを指定してあげると、一連の`a`, `b`が固定されてくれます。

```haskell
f :: forall a b. Eq b => (a -> b) -> (a -> b) -> a -> Bool
```

# 解説
　以下のようなコードを書くと

```haskell
{-# LANGUAGE ScopedTypeVariables #-}

f :: Eq b => (a -> b) -> (a -> b) -> a -> Bool
f g h x =
  let y = g x :: b
      z = h x :: b
  in y == z

main :: IO ()
main = pure ()
```

以下のようなエラーがでます。
「`g x`によって推論されたその型`b'`と、指定されたその型`b`が同一ではない」の意です。

意図として
「`g x :: b`の`b`は、`f`の型で指定された`b`そのものである」
ということを指定したつもりなのだけど…。

```
/tmp/nvimNLJJ6T/148.hs:5:11: error:
    • Couldn't match expected type ‘b2’ with actual type ‘b’
      ‘b’ is a rigid type variable bound by
        the type signature for:
          f :: forall b a. Eq b => (a -> b) -> (a -> b) -> a -> Bool
        at /tmp/nvimNLJJ6T/148.hs:3:6
      ‘b2’ is a rigid type variable bound by
        an expression type signature:
          forall b2. b2
        at /tmp/nvimNLJJ6T/148.hs:5:18
    • In the expression: g x :: b
      In an equation for ‘y’: y = g x :: b
      In the expression:
        let
          y = g x :: b
          z = h x :: b
        in y == z
    • Relevant bindings include
        h :: a -> b (bound at /tmp/nvimNLJJ6T/148.hs:4:5)
        g :: a -> b (bound at /tmp/nvimNLJJ6T/148.hs:4:3)
        f :: (a -> b) -> (a -> b) -> a -> Bool
          (bound at /tmp/nvimNLJJ6T/148.hs:4:1)

/tmp/nvimNLJJ6T/148.hs:6:11: error:
    • Couldn't match expected type ‘b2’ with actual type ‘b’
      ‘b’ is a rigid type variable bound by
        the type signature for:
          f :: forall b a. Eq b => (a -> b) -> (a -> b) -> a -> Bool
        at /tmp/nvimNLJJ6T/148.hs:3:6
      ‘b2’ is a rigid type variable bound by
        an expression type signature:
          forall b2. b2
        at /tmp/nvimNLJJ6T/148.hs:6:18
    • In the expression: h x :: b
      In an equation for ‘z’: z = h x :: b
      In the expression:
        let
          y = g x :: b
          z = h x :: b
        in y == z
    • Relevant bindings include
        h :: a -> b (bound at /tmp/nvimNLJJ6T/148.hs:4:5)
        g :: a -> b (bound at /tmp/nvimNLJJ6T/148.hs:4:3)
        f :: (a -> b) -> (a -> b) -> a -> Bool
          (bound at /tmp/nvimNLJJ6T/148.hs:4:1)

/tmp/nvimNLJJ6T/148.hs:7:6: error:
    • Could not deduce (Eq a0) arising from a use of ‘==’
      from the context: Eq b
        bound by the type signature for:
                   f :: Eq b => (a -> b) -> (a -> b) -> a -> Bool
        at /tmp/nvimNLJJ6T/148.hs:3:1-46
      The type variable ‘a0’ is ambiguous
      These potential instances exist:
        instance Eq Ordering -- Defined in ‘GHC.Classes’
        instance Eq Integer
          -- Defined in ‘integer-gmp-1.0.0.1:GHC.Integer.Type’
        instance Eq a => Eq (Maybe a) -- Defined in ‘GHC.Base’
        ...plus 22 others
        ...plus 7 instances involving out-of-scope types
        (use -fprint-potential-instances to see them all)
    • In the expression: y == z
      In the expression:
        let
          y = g x :: b
          z = h x :: b
        in y == z
      In an equation for ‘f’:
          f g h x
            = let
                y = ...
                z = ...
              in y == z
```

ということで、確かに
「`g x :: b`の`b`は、`f`の型で指定された`b`そのものである」
ということを型検査に伝えてあげます。

```haskell
{-# LANGUAGE ScopedTypeVariables #-}

f :: forall a b. Eq b => (a -> b) -> (a -> b) -> a -> Bool
f g h x =
  let y = g x :: b
      z = h x :: b
  in y == z

main :: IO ()
main = pure ()
```

OK :dog2:

　そりゃそうなんですけど、いつも忘れて「！？」ってなりますよね。
