---
title: Etaで表現されるデータ型としてのJavaクラスとその継承関係
tags: Eta, Haskell, AdventCalendar2017, AdventCalendar
---
　どうも、 :sunflower: 日曜日お日様Haskeller :sunflower: のあいやです。

　この記事は[Haskell Advent Calendar 2017](https://qiita.com/advent-calendar/2017/haskell)の
クリスマス当日（ :santa: 25日目 :santa: ）の記事です！

皆さん、アドベントカレンダーお疲れ様でした！ :tada: :tada: :tada:

# Outline

- [はじめに](#%E3%81%AF%E3%81%98%E3%82%81%E3%81%AB)
- [Javaのクラスを定義する](#java%E3%81%AE%E3%82%AF%E3%83%A9%E3%82%B9%E3%82%92%E5%AE%9A%E7%BE%A9%E3%81%99%E3%82%8B)
    - [データ型とコンストラクタ](#%E3%83%87%E3%83%BC%E3%82%BF%E5%9E%8B%E3%81%A8%E3%82%B3%E3%83%B3%E3%82%B9%E3%83%88%E3%83%A9%E3%82%AF%E3%82%BF)
        - [余談](#%E4%BD%99%E8%AB%87)
    - [メソッドとフィールド](#%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%81%A8%E3%83%95%E3%82%A3%E3%83%BC%E3%83%AB%E3%83%89)
        - [余談](#%E4%BD%99%E8%AB%87-1)
- [継承関係](#%E7%B6%99%E6%89%BF%E9%96%A2%E4%BF%82)
    - [余談](#%E4%BD%99%E8%AB%87-2)
    - [余談](#%E4%BD%99%E8%AB%87-3)
    - [余談](#%E4%BD%99%E8%AB%87-4)
- [おわりに](#%E3%81%8A%E3%82%8F%E3%82%8A%E3%81%AB)
- [参考ページ](#%E5%8F%82%E8%80%83%E3%83%9A%E3%83%BC%E3%82%B8)


# はじめに
　EtaはJVM上で扱える、GHC7.10.3互換のHaskellコンパイラです。

- [GitHub - typelead/eta: The Eta Programming Language, a dialect of Haskell on the JVM](https://github.com/typelead/eta)

この記事の内容はEtaのバージョン `0.0.9b6` に準拠します。

　本記事はEtaの入門のためというよりも、雰囲気の触りになればいいかなというレベルで書いていきます。

とはいえ、参考にされることを考慮して書いたつもりです。

完全な入門に際しては、公式ドキュメントがかなりわかりやすいです。

- [Eta Tutorials - Eta documentation](http://eta-lang.org/docs/html/eta-tutorials.html)


# Javaのクラスを定義する

- 公式ドキュメント
    - [Eta Tutorials &mdash; Eta 0.0.9b6 documentation](http://eta-lang.org/docs/html/eta-tutorials.html#defining-a-java-wrapper-type)

　各々について、以下のように定義できます。

## データ型とコンストラクタ
```haskell
data Exception = Exception @java.lang.Exception
  deriving (Class)
```

Exceptionを使うにはJava上と同じように、コンストラクタが必要です。
以下のように定義できます。

- [Exception (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/lang/Exception.html)

```haskell
-- Exception(String message)コンストラクタに対応
foreign import java unsafe "@new" newException ::
  String -> Java a Exception

-- Exception()コンストラクタに対応
foreign import java unsafe "@new" newException' ::
  Java a Exception
```

ジェネリクスを使ったデータ型は高階データ型として定義されます。

- [ArrayList (Java Platform SE 7)](https://docs.oracle.com/javase/jp/7/api/java/util/ArrayList.html)

```haskell
data ArrayList a = ArrayList (@java.util.ArrayList a)
  deriving (Class)

foreign import java unsafe "@new" newArrayList ::
  Java a (ArrayList c)
```

完全なコードはこれです。

```haskell
import Java

data Exception = Exception @java.lang.Exception
  deriving (Class)

foreign import java unsafe "@new" newException ::
  String -> Java a Exception

foreign import java unsafe "@new" newException' ::
  Java a Exception

data ArrayList a = ArrayList (@java.util.ArrayList a)
  deriving (Class)

foreign import java unsafe "@new" newArrayList ::
  Java a (ArrayList c)

-- java :: (forall c. Java c a) -> IO a
main :: IO ()
main = java $ do
  exception <- newException "pero"
  arrayList <- newArrayList
  return ()
```

### 余談
　もしかしたら`::`の後に改行を挟むスタイルに違和感を覚えたかもしれません。
例えば以下のように書きたいとか思ったかもしれません。

おめでとうございます、僕と同類です。

（こんな風に書きたかった :point_down: ）

```haskell
foreign import java unsafe "@new"
  newException :: String -> Java a Exception
```

しかし現状、これはhasktagsが`newException`を検知してくれなくなります。

- [GitHub - MarcWeber/hasktags: Produces ctags &quot;tags&quot; and etags &quot;TAGS&quot; files for Haskell programs](https://github.com/MarcWeber/hasktags)

もしくは一行で書ききってしまうこともできますが、一行が長くなることに注意。

（以下のどちらかの書式は、hasktagsに認識してもらえる :point_down: ）

```haskell
foreign import java unsafe "@new" newException ::
    String -> Java a Exception

foreign import java unsafe "@new" newException :: String -> Java a Exception
```

## メソッドとフィールド
```haskell
foreign import java unsafe "size" size ::
  Java (ArrayList a) Int
```

定義したメソッドはこのように実行できます。

```haskell
-- (<.>) :: Class c => c -> Java c a -> Java b a
do
  arrayList <- newArrayList
  n <- arrayList <.> size
  -- arrayList <.> size :: Java a Int
  -- n :: Int
  ...
```

フィールドはこのように……
チッ、`ArrayList`にpublicフィールドがねえな。

```haskell
data Point = Point @java.awt.Point
  deriving (Class)

foreign import java unsafe "@new" newPoint ::
  Int -> Int -> Java a Point

foreign import java safe "@field x" pointX ::
  Point -> Int
```

フィールドへのアクセスは副作用がないので、`safe`を指定して、純粋関数として宣言してもよいでしょう。

（そう、Etaは`{a-class} -> {field-type}`という型宣言も許容できるのです）

`safe`はノンブロッキングで実行されるので、パフォーマンスの向上が期待できます。

しかしその安全性はプログラマの責任なので、基本は`unsafe`、
外部から値が設定され得ないフィールドの取得については`safe`、
という感じでいいのではないでしょうか。

メソッドチェーンは`>-`によって行えます。

```haskell
-- (>-) :: Class b => Java a b -> Java b c -> Java a c
do
  n <- newArrayList >- size
  ...
```

staticメソッドとstaticフィールドに関しては、`""`の中のクラスパスをフルパスで記述する必要があります。

```haskell
foreign import java unsafe "@static @field java.lang.Math.E" logarithmBaseE ::
  Java a Double
```

完全なソースは以下です。

```haskell
import Java

data Exception = Exception @java.lang.Exception
  deriving (Class)

foreign import java unsafe "@new" newException ::
  String -> Java a Exception

foreign import java unsafe "@new" newException' ::
  Java a Exception

data Throwable = Throwable @java.lang.Throwable
  deriving (Class)

data ArrayList a = ArrayList (@java.util.ArrayList a)
  deriving (Class)

foreign import java unsafe "@new" newArrayList ::
  Java a (ArrayList c)

foreign import java unsafe "size" size ::
  Java (ArrayList a) Int

data Point = Point @java.awt.Point
  deriving (Class)

foreign import java unsafe "@new" newPoint ::
  Int -> Int -> Java a Point

foreign import java safe "@field x" pointX ::
  Point -> Int

foreign import java unsafe "@static @field java.lang.Math.E" logarithmBaseE ::
  Java a Double

main :: IO ()
main = java $ do
  exception <- newException "pero"
  arrayList <- newArrayList
  point <- newPoint 1 2
  print' $ pointX point
  print' =<< logarithmBaseE
  print' =<< arrayList <.> size
  print' =<< newArrayList >- size
  where
    -- Java aはIOと同等なので、以下のような関数でprintできる
    print' :: Show a => a -> Java c ()
    print' = io . print
```

### 余談
　このFFIで指定された`""`の中身は動的に解決されるので、この指定を謝ると、いとも容易くランタイムエラーを出します。

これは`size`メソッドにtypoで「ぼ」というサフィックスを付けてしまった例です。

```haskell
import Java

data ArrayList a = ArrayList (@java.util.ArrayList a)
  deriving (Class)

foreign import java unsafe "@new" newArrayList ::
  Java a (ArrayList c)

-- ArrayListに「sizeぼ」というインスタンスメソッドはない
foreign import java unsafe "sizeぼ" size ::
  Java (ArrayList a) Int

main :: IO ()
main = java $ do
  arrayList <- newArrayList
  n <- arrayList <.> size
  io $ print n
-- [1 of 1] Compiling Main             ( /home/aiya000/.tmp/Test.hs, /home/aiya000/.tmp/Test.jar )
-- Linking /home/aiya000/.tmp/RunTest.jar ...
-- Exception in thread "main" java.lang.NoSuchMethodError: java.util.ArrayList.sizeぼ()I
-- 	at main.Main$$Lr3B3a1.applyO(Test.hs)
-- 	...
-- 	at eta.main.main(Unknown Source)
```

そして`newException (10 :: Double)`というもののはFFIによって、
JVM上での`new Exception(10)`という値レベルの動作として成されるので、
これもランタイムエラーになります。

```haskell
import Java

data Exception = Exception @java.lang.Exception
  deriving (Class)

-- Exception(double x)というコンストラクタは存在しない
foreign import java unsafe "@new" newException ::
  Double -> Java a Exception

main :: IO ()
main = java $ do
  exception <- newException 10
  return ()
-- [1 of 1] Compiling Main             ( /home/aiya000/.tmp/Test.hs, /home/aiya000/.tmp/Test.jar )
-- Linking /home/aiya000/.tmp/RunTest.jar ...
-- Exception in thread "main" java.lang.NoSuchMethodError: java.lang.Exception.<init>(D)V
-- 	at main.Main$sat_s2L9.applyO(Test.hs)
-- 	...
-- 	at eta.main.main(Unknown Source)
```

　GHCにおけるFFIと同様、Haskell側の型宣言と、import先の実定義には乖離が生じるので、
Haskell側の型宣言についての注意が必要です。

（乖離: ここでは、実装と型定義が相違していても、コンパイルが通ること）


# 継承関係
　ところで例えば`Exception`クラスは`Throwable`クラスを継承しています。
Etaはそのような継承関係を型レベルで解決します。

（型レベルのvtableを定義させます）

具体的には`Inherits` type familyで、そのドメインをコドメインのクラス達のサブクラスとして登録します。

`type instance Inherits A = '[B]`は
インスタンス定義`instance (Class a, Class b, Extends' a b ~ Yes) => Extends a b`
により、`Extends A B`インスタンスになります。

```haskell
data Throwable = Throwable @java.lang.Throwable
  deriving (Class)

data Exception = Exception @java.lang.Exception
  deriving (Class)

type instance Inherits Exception = '[Throwable]
```

サブクラスは`superCast :: Extends a b => a -> b`によって、スーパークラスに型変換できます。

```haskell
main :: IO ()
main = java $ do
  exception <- newException "lala"
  return (superCast exception :: Throwable)
  return ()
```

唯一`Object`クラスに関しては例外です。

任意の`Class`インスタンス（Javaクラスデータ型）は、
`Inherits`に関わらず`Object`クラスのサブクラスです。

```haskell
data Exception = Exception @java.lang.Exception
  deriving (Class)

foreign import java unsafe "@new" newException ::
  String -> Java a Exception

data ArrayList a = ArrayList (@java.util.ArrayList a)
  deriving (Class)

foreign import java unsafe "@new" newArrayList ::
  Java a (ArrayList c)

main :: IO ()
main = java $ do
  exception <- newException "lala"
  arrayList <- newArrayList
  return (superCast exception :: Object)
  return (superCast arrayList :: Object)
  return ()
```

`ArrayList a`は`List a`インターフェースのサブクラスですが、インターフェースについても同様です。

（インターフェースもクラスと同様にはデータ型であって、つまりEta上ではどちらもあまり区別されていないと思います。
強いて言えばただ、コンストラクタになる関数がありません）

```haskell
data List a = List (@java.util.List a)
  deriving (Class)

data RandomAccess = RandomAccess @java.util.RandomAccess
  deriving (Class)

data ArrayList a = ArrayList (@java.util.ArrayList a)
  deriving (Class)

type instance Inherits (ArrayList a) = '[List a, RandomAccess]

foreign import java unsafe "@new" newArrayList ::
  Java a (ArrayList c)

foreign import java unsafe "size" size ::
  Java (ArrayList a) Int

main :: IO ()
main = java $ do
  arrayList <- newArrayList
  return (superCast arrayList :: List Int)
  return (superCast arrayList :: RandomAccess)
  return ()
```

親の親は親です。

```haskell
data Serializable = Serializable @java.lang.Serializable
  deriving (Class)

data Throwable = Throwable @java.lang.Throwable
  deriving (Class)

type instance Inherits Throwable = '[Serializable]

data Exception = Exception @java.lang.Exception
  deriving (Class)

type instance Inherits Exception = '[Throwable]

foreign import java unsafe "@new" newException ::
  String -> Java a Exception

main :: IO ()
main = java $ do
  exception <- newException "lala"
  return (superCast exception :: Throwable)
  return (superCast exception :: Serializable)
  return ()
```

以下が完全なコードです。

```haskell
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies #-}

import Java hiding (List)

data Serializable = Serializable @java.lang.Serializable
  deriving (Class)

data Throwable = Throwable @java.lang.Throwable
  deriving (Class)

type instance Inherits Throwable = '[Serializable]

data Exception = Exception @java.lang.Exception
  deriving (Class)

type instance Inherits Exception = '[Throwable]

foreign import java unsafe "@new" newException ::
  String -> Java a Exception

data List a = List (@java.util.List a)
  deriving (Class)

data RandomAccess = RandomAccess @java.util.RandomAccess
  deriving (Class)

data ArrayList a = ArrayList (@java.util.ArrayList a)
  deriving (Class)

type instance Inherits (ArrayList a) = '[List a, RandomAccess]

foreign import java unsafe "@new" newArrayList ::
  Java a (ArrayList c)

foreign import java unsafe "size" size ::
  Java (ArrayList a) Int

main :: IO ()
main = java $ do
  arrayList <- newArrayList
  return (superCast arrayList :: List Int)
  return (superCast arrayList :: RandomAccess)
  exception <- newException "lala"
  return (superCast exception :: Throwable)
  return (superCast exception :: Serializable)
  return ()
```

## 余談
　`unsafeCast :: Extends a b :: b -> a`という関数があります。
名前の通り、実行時エラーを引き起こす可能性があります。

既存の ライブラリ/フレームワーク をEtaで使おうとするとこれに頼ることになってしまうかと思いますが、
避けられる場合は避けた方がいいです。

## 余談
`Extends`の別名に`<:`という型演算子があったりします。

## 余談
任意の  インターフェースが`Object`の子になってる 🤔

```haskell
main :: IO ()
main = java $ do
  exception <- newException "lala"
  let x = superCast exception :: Serializable
  return (superCast x :: Object)
  return ()
```


# おわりに
　Etaは継承関係の解決に、型レベルプログラミングを実用しています。
もし貴方が「型レベルプログラミングって何の訳に立つの？」って聞かれた時は
「HaskellがJVMで使えるようになる」って答えてあげましょう。

（
定義`instance (Class a, Class b, Extends' a b ~ Yes) => Extends a b where`
など見てみると面白いと思います
）


# 参考ページ

- [Eta Tutorials - Eta documentation](http://eta-lang.org/docs/html/eta-tutorials.html)
- [GitHub - typelead/eta: The Eta Programming Language, a dialect of Haskell on the JVM](https://github.com/typelead/eta)
- [Exception (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/lang/Exception.html)
- [ArrayList (Java Platform SE 7)](https://docs.oracle.com/javase/jp/7/api/java/util/ArrayList.html)
- [GitHub - MarcWeber/hasktags: Produces ctags &quot;tags&quot; and etags &quot;TAGS&quot; files for Haskell programs](https://github.com/MarcWeber/hasktags)

「チッ」なんて言ってごめんね、`ArrayList`。
