---
title: ことり、穂乃果と一緒に学ぶHaskell（入門）その4「型クラスの定義と実装」
tags: ラブライブ！で学ぶ, ことり、穂乃果と一緒に学ぶHaskell, Haskell
---

- [前回 - ことり、穂乃果と一緒に学ぶHaskell（入門）その3「代数的データ型の定義2」](./2017-05-12-learn-haskell-with-muse.html)
- [記事一覧 - ことり、穂乃果と一緒に学ぶHaskell（入門）](/tags/ことり、穂乃果と一緒に学ぶHaskell.html)
- [更新履歴 - μ'sと一緒に学ぶHaskell](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)

# 前回
ことり「穂乃果ちゃんとの2人お風呂をしてきた」  
穂乃果「言ってくれれば海未ちゃんも呼んで、みんなでお風呂入ったりできたのに」  
ことり「えっ……♡♡」

- - -

ことり「Cの構造体みたいなデータ型、あれは直積型って言うよ！」  

```haskell
data Member = Member
  { name :: String
  , age :: Int
  }
```

ことり「オブジェクト指向のクラスと比べた**代数的データ型の最大の利点は、その網羅性**って言われたりするくらいだしね」  
ことり「その裏付けをするのがパターンマッチだよ」  

- - -

ことり「列挙型について」  
ことり「わたしたちμ'ｓは、こうやって書けるよ」  

```haskell
data Muse = Hanayo | Rin | Maki | Umi | Kotori | Honoka | Eli | Nico | Nozomi
```

- - -

ことり「直和型は、列挙型と直積型が合わさったようなもので、列挙子がフィールドを持ちます！」  

```haskell
data Student = OtonokiStudent String Int
             | UranohoshiStudent String Int Bool
  deriving (Show)
```


# 型クラス
ことり「こんにちは〜」  
穂乃果「[日曜おひさま ほのHaskell](https://twitter.com/hashtag/%E6%97%A5%E6%9B%9C%E3%81%8A%E6%97%A5%E6%A7%98%E7%A9%82%E4%B9%83%E6%9E%9C%E3%81%A1%E3%82%83%E3%82%93)だよ！」  
ことり「今日は日曜日じゃないけどね♪」  

ことり「今日は型クラスについてやっていくよ！」  


## はい
ことり「型クラスは`class`キーワードで定義するよ♪」  
穂乃果「`class`？　Javaにも`class`キーワードがあったけど、Haskellでは型クラスに使うんだー！」  
ことり「うん！　Javaの`class`はわからないけど、Haskellの`class`は『classify（分類する）』から来てるって説があるね」  

```haskell
class GobiPersons a where
  -- 人を受け取って、その人の語尾を返す関数
  say :: a -> String
```

ことり「これは『[語尾](http://dic.pixiv.net/a/%E5%8D%97%E3%81%BF%E3%82%8C%E3%81%83)持ちとしての性質』を表す型クラスだよ！」  
穂乃果「うーん？？　凛ちゃんとかにこちゃんとか……希ちゃんもかな？……かな？」  
ことり「うん！　希ちゃんの『やん！』とか『やねっ！』が語尾かは微妙だけど……ちょうど希ちゃんとにこちゃんはサブグループやってたよね」  

[乙女式れんあい塾](http://books.rakuten.co.jp/rb/11612277/)  
[![乙女式れんあい塾](http://shop.r10s.jp/book/cabinet/9433/4540774409433.jpg)](http://books.rakuten.co.jp/rb/11612277/)

ことり「はいっ」  

```haskell
data NozoNico = Nozomi | Nico
```

ことり「そうしたら、`NozoNico`を`GobiPersons`インスタンスで定義するよ」  

```haskell
instance GobiPersons NozoNico where
  say Nozomi =  "やねっ！"
  say Nico =  "ニコッ！"
```

```haskell
main :: IO ()
main = do
  putStrLn (say Nozomi)
  putStrLn (say Nico)

-- vvv 出力 vvv
-- やねっ！
-- ニコッ！
```

ことり「たまに『型クラスはインターフェースに似ている』とか言われるんだ。　……賛否両論が多数あるけどね」  
穂乃果「あー、でも確かに少し似てるかも……？　こんな感じかな？」  

```java
interface GobiPersons {
	public String say();
}

enum NozoNico implements GobiPersons {
	Nozomi, Nico;

	@Override
	public String say() {
		if (this == Nozomi) {
			return "やねっ！";
		} else if (this == Nico) {
			return "ニコッ！";
		} else {
			throw new RuntimeException();
		}
	}
}

public class Program {
	public static void main(String[] args) {
		NozoNico nozomi = NozoNico.Nozomi;
		System.out.println(nozomi.say());

		NozoNico nico = NozoNico.Nico;
		System.out.println(nico.say());
	}
}

// vvv 出力 vvv
// やねっ！
// ニコッ！
```

ことり「Congratulation！」  
穂乃果「えへへ〜」  


# 型クラスとインターフェースって、何が違うの？
ことり「ここでひとつ、インターフェースと型クラスの拭えない相違点が浮かんできたよ」  
穂乃果「ぬぐえないそういてん？」  
ことり「うん。　型クラスはね、`deriving`を除いて、**具体データ型とインスタンス定義が明確に別れてるんだ**！」  
穂乃果「？？？　どういうこと？」  

ことり「例を見てみよう。　穂乃果ちゃん、ちょっと`NozoNico`データ型をもう1回書いてみてもらってもいい？」  
穂乃果「うん！　やってみるね！」  

```haskell
data NozoNico = Nozomi | Nico
```

ことり「じゃあ次は`GobiPersons`インスタンスももう1回書いてくれるかな」  
穂乃果「はーい」  

```haskell
instance GobiPersons NozoNico where
  say Nozomi =  "やねっ！"
  say Nico =  "ニコッ！"
```

ことり「ほら、具体データ型の定義とインスタンス定義。　2つの工程が明確に分割されてるんだ」  
ことり「対してJavaのインターフェース実装は、必ずクラス定義と同時に行わなくちゃいけない。　って感じかな」  

穂乃果「あ、確かに。　でもそれって、便利なの？」  
ことり「うん、とても便利だよ！　例えば……ある性質を持つ型クラスをここに定義しました」  

```haskell
-- aとaを足し合わせることができる性質
class Magma a where
  magAppend :: a -> a -> a
```

ことり「Intって足し算ができるよね？」  
穂乃果「うん。　足し算できる」  
ことり「でもIntは標準で定義されてるから、後から定義を変更すること……Intに`implements Magma`みたいなのを付け足すことができないんだ」  
穂乃果「……あっ！」  

ことり「そう、ここで『インスタンス定義が独立していること』が効いてくるよ」  

```haskell
instance Magma Int where  -- 任意の時点でIntのインスタンス定義ができる
  magAppend x y = x + y

main :: IO ()
main = do
  print (magAppend 10 20 :: Int)

-- vvv 出力 vvv
-- 30
```

穂乃果「ほんとうだ！　Haskellすごーい！　Haskellすごーい！！」  
ことり「でしょー！　えへへ」照れり  


# マグマってだれですか？
穂乃果「そういえば、ことりちゃんがさっき書いてた`Magma`って何？」  
ことり「ふふっ。　数学者さんでも専門外だと知りすらしない、ちょっと不遇な子かな♪」  


# 参考にしたページ

- [enum(列挙型)でinterfaceを使う - Javaと情熱のあいだ](http://odasusu.hatenablog.com/entry/20080216/1203168579)
- [マグマ（数学） - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%9E%E3%82%B0%E3%83%9E_(%E6%95%B0%E5%AD%A6))


# 💎  こんにちは 💎

　この続きはTwitterへの共有ツイート、はてなブックマークへのブックマーク登録、Facebookへのいいね及びシェア、Pocketへの登録  
そして僕のモチベーションによって書かれます。  
シェアして欲しいな〜〜（シェアはこのページの上部ボタンから！）

　疑問点があれば、Twitterでリプライくれれば（そのリプライを見逃してなければ）返すよ！  
[\@public_ai000ya - Twitter](https://twitter.com/public_ai000ya)
