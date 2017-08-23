---
title: ネストした分岐を消す方法（タプルを使う）
tags: Haskell
---
　まずはこのコードを見て欲しい。

```haskell
import Numeric.Extra (intToDouble)

main :: IO ()
main = do
  n <- (readLn :: IO Int)
  xs <- sequence $ replicate n (readLn :: IO Int)
  if n == 3
     then case divTotal xs of
               Just result -> putStrLn $ "succeed: " ++ show result
               Nothing     -> putStrLn "The caluculation is failed"
     else putStrLn "x("

divTotal :: [Int] -> Maybe Int
divTotal [] = Nothing
divTotal xs =
  let (x':xs') = map intToDouble xs
  in truncate <$> foldr (flip (/?)) (Just x') xs'
  where
    -- Safe (/)
    (/?) :: Maybe Double -> Double -> Maybe Double
    Nothing /? _  = Nothing
    Just 0  /? _  = Nothing
    Just x  /? y  = Just $ x / y
```

これは最初にユーザから整数値nの入力を受け取ってから、n個の整数値の入力を受け取った後に、
nが3であれば3つの整数値を左から右に割り算するプログラムだ。

nが3でなければエラーメッセージAを、
割り算で0除算が起こったらエラーメッセージBを、
全て正しく成功したら結果を表示する。

　しかし見て欲しい。
ifとcaseが醜くネストしている。

```haskell
if n == 3
  then case divTotal xs of
            Just result -> putStrLn $ "succeed: " ++ show result
            Nothing     -> putStrLn "The caluculation is failed"
  else putStrLn "x("
```

　皆もこんなネストは見たくないよね？
まあこのレベルならともかく、もっとネストしていたら冗談でなく見たくなくなる。

　このようなパターンなら、タプルを使ってネストを減らすことができる。

```haskell
case (n == 3, divTotal xs) of
  (False, _) -> putStrLn "x("
  (True, Nothing)     -> putStrLn "The caluculation is failed"
  (True, Just result) -> putStrLn $ "succeed: " ++ show result
```

　もしdivTotal xsでerrorが返される場合でも、Haskellの評価戦略ならこの例をうまくやってくれるはずだ。
