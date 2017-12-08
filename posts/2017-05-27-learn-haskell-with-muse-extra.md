---
title: にこ、希と一緒に学ぶHaskell（番外）「型クラスの定義と実装（Extra）」
tags: ラブライブ！で学ぶ, にこ、希と一緒に学ぶHaskell, Haskell
---

- [本編その1（ことり、穂乃果と一緒に学ぶHaskell（入門）その1「代数的データ型の定義」）](./2017-05-06-learn-haskell-with-muse.html)
- [記事一覧 - にこ、希と一緒に学ぶHaskell（番外）](/tags/にこ、希と一緒に学ぶHaskell.html)
- [更新履歴 - μ'sと一緒に学ぶHaskell](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)

# にこ、希と一緒に学ぶHaskell（番外）について
希 & にこ「どうもこんにちは〜」  

にこ「毎度おなじみ、Haskellerとして名の通ってる、みんなのニコニーです！」  
希「東條希やで〜」  

にこ「あなたのハートににこにこにー♪」  
希「はーいぷしゅっ☆」  

にこ「このコーナーですが、本編の補足、Haskellの面白い機能の紹介、などなどを進めていくニコ！」  
希「ちょうど本編を読んでくれてるHaskell入門中の子には悪いんやけど、この企画のレベルは……そうやね、たまにだいたい中級くらいになります」  
希「String, Text (Lazy/Strict), ByteString (Lazy/Strict)の関係がわかるとか、少しだけ言語拡張がわかるとかの人なら、Extra全部の記事を余裕で理解できると思うで♪」  
にこ「ごめんねぇ♡　でもその分にこが笑顔をサービスしちゃうニコッ！　にっこにっこにー♡」  
希「**もしわからない内容があっても、『へー、こんなことができるんだー』くらいで楽に読んでもらって構わへんで！**」  


# 型クラスとインターフェースって、何が違うの？ Extra
希「ということで、この記事は本編の補足記事、もとい余談になります」  

- [本編 - ことり、穂乃果と一緒に学ぶHaskell（入門）その4「型クラスの定義と実装」](./2017-05-27-learn-haskell-with-muse.html)

希「本編で、ことりちゃんがこんなこと言ってたね」  

- - -

ことり「たまに『型クラスはインターフェースに似ている』とか言われるんだ。　……賛否両論が多数あるけどね」  

- - -

にこ「正直にこは、型クラスとインターフェースって、**抽象を表す**ってことくらいしか似てないと思うけど」  
希「まあまあそれの議論は置いておいてや。　引っ込みがつかなくなっちゃうからね」  

希「もうひとつの、インターフェースと型クラスの大きな相違点として、**型クラスはthisに依存しない**っていうのがあるよ」  

希「以下に`SingletonInt`データ型の定義と、その`Monoid`型クラスのインスタンス定義を示すで」  

```haskell
import Data.Monoid (Monoid(..))

data SingletonInt = Zero
  deriving (Show)

-- class Monoid a where
--   mempty :: a
--   mappend :: a -> a -> a

instance Monoid SingletonInt where
  mempty = Zero
  Zero `mappend` Zero = Zero

main :: IO ()
main = do
  print $ Zero `mappend` Zero `mappend` mempty

-- vvv 出力 vvv
-- Zero
```

希「いくらか、まだ解説してない書き方をしちゃったね。　まあ後でことりちゃんが解説してくれるやろ」  
にこ「……てきとうね」  

- - -

- 解説してないやつ
    - `import`
    - `x ｀mappend｀ y`（関数の中置記法）
    - `$`（関数適用演算子）
        - `($) :: (a -> b) -> a -> b`

...

にこ「希がてきとうすぎるから、少しだけ解説しておくわ」  
にこ「`import`は別の言語とほとんど同じだし、察してちょうだい」  
にこ「関数の中置記法っていうのは、2引数を持つ関数に対して与えられる糖衣構文よ。　**通常の2引数関数呼び出しから、以下のように書き換えできるわ**」  

```haskell
-- 足し算
plus :: Int -> Int -> Int
plus x y = x + y

plus 10 20
    ↓
10 `plus` 20
```

にこ「最後に、`$`ね。　これは単なる1つの演算子にして、Haskellにとってすっっっっっっごい重要なものなの〜！」  
にこ「ネストした可読性の悪い悪しき括弧から、`$`に書き換えることができるわ！」  

```haskell
print (show 10)
    ↓
print $ show 10
```

にこ「ネストがもう1つ深い例を見てみましょう」  

```haskell
print (show (20 - 10))
    ↓
print $ show $ 20 - 10
```

にこ「少しステップを踏んでみましょう」  

```
   print (show (20 - 10))
=> print (show $ 20 - 10)  -- 深い括弧を書き換え。　(-)が演算されてから($)が演算される
=> print $ show $ 20 - 10  -- 一番右から処理される
=> print $ show 10
=> print "10"
```

にこ「こんな感じね」  

...

- - -

```haskell
import Data.Monoid (Monoid(..))

data SingletonInt = Zero
  deriving (Show)

-- class Monoid a where
--   mempty :: a
--   mappend :: a -> a -> a

instance Monoid SingletonInt where
  mempty = Zero
  Zero `mappend` Zero = Zero

main :: IO ()
main = do
  print $ Zero `mappend` Zero `mappend` mempty

-- vvv 出力 vvv
-- Zero
```

にこ「`SingletonInt`……0のみからなる集合なのね。　かなり自明なモノイドね」  
希「モノイド……`Monoid`ってゆーのは簡単に言うと、本編に出てきた`Magma`に、ある数学的（代数的）な法則と`mempty`を追加した抽象なんやけど」  
希「今は別にモノイドについてわからなくってもええよ。　`mempty`に注目して欲しいな」  

希「`mempty`って、関数じゃなくて値なんよ。　それを型クラスで要求するようにしてる」  
希「対してJavaのインターフェースって、staticフィールドの実装を要求できないやん？　だから少し歪になってしまうん。　……ほらニコっち、Javaで書いてみて♪」  

にこ「しょうがないわねえ。　にこってオシャレさんだからあんまりJavaみたいな言語って書かないんだけど〜、こんな感じかなぁ♪」  
希「こら！　敵を作るような発言するんやないの！」  

```java
interface Monoid<T> {
	public T mempty();
	public T mappend(T x);
}

abstract class SingletonInt implements Monoid<SingletonInt> {
	@Override
	public SingletonInt mempty() {
		return new Zero();
	}

	@Override
	public SingletonInt mappend(SingletonInt x) {
		return new Zero();
	}
}

class Zero extends SingletonInt {
	@Override
	public String toString() {
		return "Zero";
	}
}

public class Test {
	public static void main(String[] args) {
		SingletonInt x = new Zero();
		SingletonInt y = new Zero();
		SingletonInt result = x.mappend(y).mappend(x.mempty());
		System.out.println(result);
	}
}

// vvv 出力 vvv
// Zero
```

希「うん、いいね。　さすがニコっちやね」  
にこ「まあこんなもんよ」  
希「ほな、解説お願い」  
にこ「はいはい。　ほら、ここを見て」  

```java
//                                         vv
SingletonInt result = x.mappend(y).mappend(x.mempty());
```

にこ「`mempty`が`this`オブジェクトに紐付いちゃってるのよ。　これはさっき希が言ってた通り、インターフェースがstaticフィールドを要求できないことから来る歪みよ」  
にこ「例えばもしこんなことができるなら、解決できるわね」  

```java
interface Monoid<T> {
	public static T mempty;
	public T mappend(T x);
}

abstract class SingletonInt implements Monoid<SingletonInt> {
	@Override
	public static SingletonInt mempty = new Zero();

	@Override
	public SingletonInt mappend(SingletonInt x) {
		return new Zero();
	}
}

//                                         vvvvvvvvvvvvv
SingletonInt result = x.mappend(y).mappend(SingletonInt.mempty);
```

にこ「まあ、正直それはインターフェースの範疇じゃないし、Javaは間違ってないと思うけど。　それでもモノイドはインターフェースではうまく表現できないことの1つだと思うわ」  


# のぞにこ
希「よしよし、上出来や♪」ﾅﾃﾞﾅﾃﾞ  
にこ「ちょっと！　頭なでなでするのやめなさいよ！　アイドルの髪は命なんだからね！」  

希「よーし、スイーツ食べて帰るやでー」  
にこ「あらいいわね、さんせー！」ﾆｺｯ  


# 参考にしたページ

- [矢澤にこ - ピクシブ百科事典](http://dic.pixiv.net/a/%E7%9F%A2%E6%BE%A4%E3%81%AB%E3%81%93)
