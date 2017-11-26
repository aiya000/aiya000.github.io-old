---
title: ことり、穂乃果と一緒に学ぶHaskell（入門）その6「高階データ型」
tags: ラブライブ！で学ぶ, ことり、穂乃果と一緒に学ぶHaskell, Haskell, AdventCalendar2017, AdventCalendar
---
　この記事は[Haskell (その2) Advent Calendar 2017](https://qiita.com/advent-calendar/2017/haskell2)の
クリスマス・イブの日の記事です！

　この記事にはSS表現、ラブライブ、Javaが含まれます。
これらが苦手な方はブラウザバックを推奨します。

- - -

- [前回 - ことり、穂乃果と一緒に学ぶHaskell（入門）その5「様々な文字列型とIsStringそしてOverloadedStrings」](./2017-08-03-learn-haskell-with-muse-happy-birthday-honoka.html)
- [記事一覧 - ことり、穂乃果と一緒に学ぶHaskell（入門）](/tags/ことり、穂乃果と一緒に学ぶHaskell.html)
- [更新履歴 - μ'sと一緒に学ぶHaskell](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)

# 部室
こんこん

ことり「どうぞー」  
穂乃果「おじゃましまーす」  

ことり「今日はどうしたの？」  
穂乃果「えーと、今日のHaskellの授業でもわからないところが出てきて…」  

ことり「ふふ。　じゃあ、いつも通り教えてあげる！」  
穂乃果「おねがい！」  


# 引数を取る型
穂乃果「今日は`Maybe`, `Identity`, `Either`っていう型が出てきたんだけど、
これは`Maybe Int`, `Maybe Char`, `Identity Int`, `Either Int Char`…
みたいに使うって教わったんだ」  
穂乃果「普通の型は`Int`, `Char`, `Foo`みたいな書き方だったよね。
　でもこれの`Maybe Int`とかは、なんだか関数適用みたいだな……って」  
穂乃果「しかも`Maybe Int`だったり`Maybe Char`だったり、
はたまた`Either Int Bool`みたいに引数？
　が複数あったりで……」  

穂乃果「これってなんなんだろう？
　って思って、ここに来たんだ」  


## それはジェネリクス
ことり「`Maybe`, `Identity`, `Either`のそれぞれの使い方…
ってよりも、`Foo Int`, `Bar Char`みたいな形の型がどのようなものなのか
がわからない？」  

穂乃果「使い方もわからないんだけど、うん。
　それぞれの使い方の前に、そういう型がなんなのかが、わからないかな」  

ことり「なるほど〜」  

ことり「そうだね。
　さっき上がった`Maybe`, `Identity`, `Either`の中だと`Identity`が簡単だから、それを使おっか。
　`Identity`がどんなものかは教わった？」  

穂乃果「うん教わったよ！
　ちょっと使い道がわからなかったけど……
こんな感じのやつだよね」  

```haskell
import Data.Functor.Identity (Identity(..))

x :: Identity Int
x = Identity 10

main :: IO ()
main = do
  print x
  print (runIdentity x)
-- {output}
-- Identity 10
-- 10
```

ことり「そうそう。
　`Identity`は『指定された値をそのまま格納する』
って感じのデータ型」  
ことり「`Identity`の使い道については、今回は省略するね」  

ことり「`Identity`の定義はこんな感じだよ」  

```haskell
data Identity a = Identity { runIdentity :: a }
  deriving (Show)
```

ことり（実際の定義は、もうちょっと色んな型クラスを`deriving`してたりするよ）  

穂乃果「`runIdentity`はレコード？」  
ことり「そう、レコード。
　レコードは[以前](http://aiya000.github.io/posts/2017-05-12-learn-haskell-with-muse.html#直積型)にやったよね」  

- [ことり、穂乃果と一緒に学ぶHaskell（入門）その3「代数的データ型の定義2」](./2017-05-12-learn-haskell-with-muse.html#直積型)

ことり「今回は単一の引数を持つデータ型`Identity`に、単一のレコードがついてる形になるよ」  

穂乃果「うーん…なんか定義に違和感があるなあ…」  
穂乃果「あー、`data Identity`…
の後に、`a`っていう見慣れないモノがあるんだ！
　これって…なに？」  

ことり「それはね、『型引数』っていうんだ」  

ことり「穂乃果ちゃんはJavaを知ってるから、またこれをJavaに例えようかな」  
ことり「これは簡単で、まさにジェネリクスで表現できる」  

ことり「Javaのジェネリクスにもおんなじ『型引数』っていう単語があったよね。
　同じ意味合いを持つよ」  

```java
class Identity<T> {
    public T val;
    public Identity(T val) {
        this.val = val;
    }

    @Override
    public String toString() {
        return "Identity " + this.val;
    }
}

public class Test {
    public static void main(String[] args) {
        Identity<Integer> x = new Identity<>(10);
        System.out.println(x);
        System.out.println(x.val);
    }
}
// {output}
// Identity 10
// 10
```

ことり「これは`Identity`を独自定義しているところを除いて、
上のHaskellコードと同じ内容のJavaコードだよ」  

穂乃果「おおっ」  

ことり「`Identity a`の`a`を`Int`に指定することによって、
`runIdentity`レコードに`Int`を入れることができるようになるよ」  

```haskell
x :: Identity Int
x = Identity { runIdentity = 10 }
```

穂乃果「ここ」  

x :: Identity <font color='blue'>Int</font>
x = Identity { runIdentity = <font color='blue'>10</font> }

穂乃果「が対応してる？」  
ことり「その通り♪」  

ことり「誤解を恐れずに、すごく大雑把に言っちゃうと…
`Identity a`の`a`も、
`Identity<T>`の`T`も、
同じ…型引数なんだ」  

ことり（実際はカリー化されてるか否かといった、大きな差異があるけど……それでも）  
ことり「どちらも『`Identity`に何かしらの型引数を1つ与えると具体的な型になる』
ってことを表している」  

ことり「例えば`Identity<T>`, `Identity a`って書くだけじゃ…
`T`が、`a`が何なのかわからなくて具体的じゃないけど」  
ことり「`Identity<Integer>`, `Identity Int`って書くことによって、具体的な型になるから」  

```java
Identity<Integer> x = new Identity<>(10);
```

```haskell
x :: Identity Int
x = Identity 10
```

ことり「このように、その値を定義できるようになるよ！」  

穂乃果「具体的じゃない型は、`x`のような値を定義できない？」  
ことり「うん！」  

```java
// コンパイルエラー！
Identity<T> x = new Identity<>(10);
```

```haskell
-- コンパイルエラー！
x :: Identity a
x = Identity 10
```

ことり「`10 :: a`じゃないからね。
　`Identity 10 :: Identity Int`、`10 :: Int`みたいな感じにしないといけない」  
穂乃果「`runIdentity`の型の問題だー」  

ことり「あとは……それぞれの型の使い方についてはまた別の機会に説明するけど……」  

ことり「`Maybe`……`Maybe a`……も同じ」  
穂乃果「`Maybe Int`, `Maybe Char`みたいに、`Maybe`に`Int`や`Char`を渡すことによって、
具体的な型になって、値が定義できる？」  
ことり「そうそう」  

ことり「そして`Either`……`Either a b`……は、引数の数が増えるだけだよ」  
穂乃果「`Either Int Int`とか`Either Int Char`みたいな感じ？」  
ことり「そうそう♪」  


## 単相型, 多相型（高階型）
ことり「さっき『`Identity`に何かしらの型引数を1つ与えると具体的な型になる』って言ったけど」  
ことり「『何かしら型引数をn個与えると具体的な型になる（n >= 1）』っていう型を、Haskellでは『多相型』とか『高階型』とか言ったりするよ」  
ことり「逆にここの『具体的な型』は『単相型』とか言ったり。」  

穂乃果「`Maybe`, `Identity`, `Either`とかが多相型で、`Int`, `Char`, `Bool`とかが単相型？」  
ことり「そう！」  
ことり「そして`Either Int`みたいな型も多相型で、`Maybe Int`や`Identity Char`なども単相型になるよ」  

穂乃果「n個の型引数を適用しきった多相型は、単相型になる感じかな…？」  
ことり「そうそう。
　そしてそれは、ghciの:kindコマンドで確認することができるよ！」  

```haskell
>>> :kind Maybe
Maybe :: * -> *
>>> :kind Identity
Identity :: * -> *
>>> :kind Either
Either :: * -> * -> *

>>> :kind Int
Int :: *
>>> :kind Char
Char :: *
>>> :kind Bool
Bool :: *

>>> :kind Either Int
Either Int :: * -> *

>>> :kind Maybe Int
Maybe Int :: *
>>> :kind Identity Char
Identity Char :: *
```

ことり「`:: *`になっている型は単相型。
　そして`:: * -> *`や`:: * -> * -> *`が多相型だよ」  

ことり「例えば`*`というのは単相型そのものを表していて、
`* -> *`っていうのは『単相型1つを型引数として適用すると単相型になる』
って意味なんだ」  

穂乃果「なんだか関数の型に似てるね。
　`Int -> Char`とかに似てる！」  

ことり「そうなんだよー。
　:kindで見られる`* -> *`のようなものは『カインド』または『種』っていって、
関数の型と同じように読めるんだ」  
ことり「例えば…
`Int -> Char`は『`Int`を受け取って、`Char`を返す』って言えるように、
`* -> *`は『単相型 を受け取って、単相型を返す』（『`*`を受け取って、`*`を返す』）
って言えるよ♪」  

ことり「`* -> * -> *`は『`*`を2つ受け取って`*`を返す』みたいな感じだね」  

穂乃果「関数の型と同じように、カインドも、受け取る引数（型引数）が最後の`-> *`以外なんだ！」  

```haskell
-- 受け取る*の個数

Maybe :: * -> *
--       ^
--       1つ

Either :: * -> * -> *
--        ^^^^^^
--        2つ
```

ことり「うん。
　`*`っていうのが常に単相型を表すだけで、
関数の型と全く同じ読み方ができるよ♪」  


# 夕暮れ
カー カー

ことり「そろそろ日も暮れてきたね、
今日はこれくらいにしようか。」  
穂乃果「ふあー…。
　今日もありがとうございました、ことり先生！」  

穂乃果「そういえばさ、
ことりちゃんは今年のクリスマスを一緒に過ごす男の人とかいるの？」  
ことり「残念ながら、い…いないかな…」 ///  

穂乃果「じゃあさ！
　今年の明るいうちもまた、海未ちゃんも呼んでさ、
クリスマスミニパーティーしようよ！」  
穂乃果「今年はμ'sのみんなも呼んじゃったりしたら面白いかも！」  

ことり「ふふ、そうだね。
　今年もいいクリスマスになりそうだね♪」  
