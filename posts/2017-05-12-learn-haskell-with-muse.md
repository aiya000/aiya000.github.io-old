---
title: ことり、穂乃果と一緒に学ぶHaskell（入門）その3「代数的データ型の定義2」
tags: ラブライブ！で学ぶ, ことり、穂乃果と一緒に学ぶHaskell, Haskell
---

- [前回 - ことり、穂乃果と一緒に学ぶHaskell（入門）その2「関数とデータ型」](./2017-05-11-learn-haskell-with-muse.html)
- [記事一覧 - ことり、穂乃果と一緒に学ぶHaskell（入門）](/tags/ことり、穂乃果と一緒に学ぶHaskell.html)
- [更新履歴 - μ'sと一緒に学ぶHaskell](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)

# 前回
ことり「穂乃果ちゃん、関数の定義方法は授業では習った？」  
穂乃果「い…いちおう……。　えーと、こういうのだっけ」  

```haskell
add1 :: Int -> Int
add1 x = x + 1
```

ことり「`:: Int -> Int`っていうのは、`add1`っていう関数に`Int -> Int`っていう型を付けているんだ　Javaに直すとこうかな！」  

```java
int add1(int x) { return x + 1; }
```

- - -

ことり「`Show`は、`Show`を実装したデータ型である`Member`に対して`show :: Show a => a -> String`なる関数の実装を与えるよ♪」  

```haskell
data Member = Member String Int
  deriving (Show)
```

穂乃果「`show :: Show a => a -> String`っていうのは……Showを実装する型aを受け取って、文字列（`String`）を返す関数`show`？」  
ことり「そのとおりです！」  


# 束の間
ーー ほの邸（お風呂） ーー

穂乃果「ふぅ、一番風呂〜〜！　……んんん〜〜」

湯船バシャーンー

穂乃果「今日はライブ練習に加えて、ことりちゃんのHaskell講座。　楽しかったぁ〜」  

穂乃果「なんだっけなー、`Show`は`show :: Show a => a -> String`を提供する。」  
穂乃果「`Member`とかのデータ型が`Show`を`deriving`すると、`show`を使って値を文字列化できる」  
穂乃果「型クラスを実装したデータ型をインスタンスって言って、例えば`Member`は`Show`インスタンスって言うんだったよね……」  

穂乃果「ふぅ〜〜……」  

………

ことり「合ってるよ、穂乃果ちゃん！」  
穂乃果「うわぁことりちゃん、なんで窓から出てくるの！！」  
ことり「覗いちゃったぁ☆」  
穂乃果「覗いちゃったぁ☆　じゃないよ〜！！」  

- - -

ーー ほの自室 ーー

ことり「あの後、なんだかんだで穂乃果ちゃんとの2人お風呂をしてきた後のことりだよ☆」  
穂乃果「も～、なんで窓から覗いてたのー。  言ってくれれば海未ちゃんも呼んでお泊まり会したり、みんなでお風呂入ったりできたのに」  
ことり「えっ……♡♡」

穂乃果（みんなでお風呂はさすがに狭いかなぁ……？）  
ことり（穂乃果ちゃんと海未ちゃんとお風呂……♡）ﾊﾅｼﾞﾌﾞｰ  

穂乃果「うわっ、鼻血鼻血！  大丈夫！？  …ことりちゃん、また変なこと考えてたりしたの……？」ｲﾌﾞｶｼｹﾞｰ  
ことり「えっ、あっ、あえーと、えへへ」  

ことり「よーし、今夜は型クラスの定義方法までをやっていくよ！」  
穂乃果「オッ！？」  


# 代数的データ型の直積型と列挙型、直和型について
ことり「穂乃果ちゃん、前に『代数的データ型の定義』についてやったよね。　実はあれ、まだ途中なんだ」  

- [ことり、穂乃果と一緒に学ぶHaskell（入門）その1「代数的データ型の定義」](./2017-05-06-learn-haskell-with-muse.html#datatype-definition)

穂乃果「えっ、あれの他にまだあるの？」  
ことり「うん！　この前作った`Member`……**Cの構造体みたいなデータ型、あれは直積型って言うよ！**」  

ことり「その他に**列挙型**、**直和型**っていうのがあるから、合わせてそれをやっていくよ♪」  
穂乃果「わあ、お願いしまーすっ！」  


# 直積型
## レコード構文
ことり「まずは直積型のおさらい + αからです」  
ことり「前のときに穂乃果ちゃんが『`name`とか、`age`とかっていう名前は書かないでいいの？』って言ってたよね」  

- - -

（Haskellでのコード）

```haskell
data Member = Member String Int
```

（Javaでのコード）

```java
class Member {
	public String name;
	public int age;
	public Member(String name, int age) {
		this.name = name;
		this.age = age;
	}
}
```

穂乃果「`name`とか、`age`っていう名前は書かないでいいの？」  
ことり「名前をつけることもできるんだけど、今はまだ置いておいてね」  

- - -

ことり「Haskellでは名前が必要なときに、**レコード構文**を使うよ！」  

```haskell
data Member = Member
  { name :: String
  , age :: Int
  }
```

ことり「値の定義では従来と同じ方法の他に、レコードに直接代入したように見えるような構文が使えるよ」  

```haskell
honoka :: Member
honoka = Member "honoka" 16
```

```haskell
honoka :: Member
honoka = Member
  { name = "honoka"
  , age = 16
  }
```

穂乃果「すごーい！　"honoka"とか16が何の値なのかわかりやすくなったー！」  
ことり「えへへ。　そして定義したレコードは、データ値からデータ値を取り出す関数として自動実装されるの！」  

```haskell
main :: IO ()
main = do
  putStrLn ("name: " ++ name honoka)
  putStrLn ("age: " ++ show (age honoka))

-- vvv 出力 vvv
-- name: honoka
-- age: 16
```

ことり「`++`は、文字列同士を結合する演算子だよ！」  

- `(++) :: String -> String -> String`
- `("ほの" ++ "こと") == "ほのこと"`

ことり「`Int`は`Show`インスタンスだから、Int値である`age honoka`は`show`されることができるよ」  

- `instance Show Int`
- `show 10 == "10"`

穂乃果「うんーと、`name (Member "honoka" 16) == "honoka"`ってことかな？」  
ことり「うん、その通りです♪」  

穂乃果「レコード。　この場合は……`name`と`age`が関数になるんだ。　えーと……こう表すことができる？」  

- `name :: Member -> String`
- `age :: Member -> Int`

ことり「さすが穂乃果ちゃん！　そう書くことができるよ！」  
穂乃果「えへっ！　流石私！」  

ことり「でも代数的データ型の面白いところはまだまだこれからだよっー」  
穂乃果「おー！」  

## 関数でのパターンマッチ
ことり「代数的データ型の最高最大、一番の武器と言ってもいい。　**パターンマッチ**だよ」  

```haskell
honoka :: Member
honoka = Member
  { name = "honoka"
  , age = 16
  }

main :: IO ()
main = do
  prettyPrintMember honoka

prettyPrintMember :: Member -> IO ()
prettyPrintMember (Member herName herAge) = do
  putStrLn ("name: " ++ herName)
  putStrLn ("age: " ++ show herAge)
```

穂乃果「`prettyPrintMember`は`Member`を受け取って、それを表示する関数……だよね。　あれ、仮引数ってどこにいっちゃったの？」  
ことり「仮引数はちゃんとここにあるよ♪」  

```haskell
--                vvvvvvvv ここ vvvvvvvvv
prettyPrintMember (Member herName herAge) = ...
```

ことり「これこそがパターンマッチだよ！」  
ことり「`main`の`prettyPrintMember (Member "honoka" 16)`っていう呼び出しを」  
ことり「`prettyPrintMember (Member "honoka" 16)`っていう風に分解してくれるんだ。
　自動的に`herName`に`"honoka"`、`herAge`に`16`っていう値が束縛してくれます」  
穂乃果「束縛？」  
ことり「うん。　Haskellでは**名前（変数）に値を紐付けることを、束縛って言ったりするよ！**」  

穂乃果「『`prettyPrintMember`関数が実引数の受け取り時に、`"honoka"`と`16`を`herName`と`herAge`に束縛する』……こんな感じかな」  
ことり「そんな感じです♪」  

ことり「オブジェクト指向のクラスと比べた**代数的データ型の最大の利点は、その網羅性**って言われたりするくらいだしね」  
ことり「その裏付けをするのがパターンマッチだよ」  

穂乃果「も……もうら……せい？」  
ことり「えーと、そんなに難しく考える必要はなくって、『データ型からフィールドを簡単に束縛できる』ってくらいでいいよ！」  


# 列挙型
ことり「次は列挙型について」  

穂乃果「あれ、Javaにも列挙型ってあったよね。　何か関係があったりするの？」  
ことり「関係があるも何も、ほとんど同じものなんだ。　わたしたちμ'ｓは、こうやって書けるよ」  

```haskell
data Muse = Hanayo | Rin | Maki | Umi | Kotori | Honoka | Eli | Nico | Nozomi
```

穂乃果「あーっ！　私たちだー！」  
ことり「ふふ、あとは適当にShowをderivingして」  

```haskell
data Muse = Hanayo | Rin | Maki | Umi | Kotori | Honoka | Eli | Nico | Nozomi
  deriving (Show)
```

ことり「簡単に出力できます」  

```haskell
main :: IO ()
main = do
  print Umi
  print Honoka
  print Kotori

-- vvv 出力 vvv
-- Umi
-- Honoka
-- Kotori
```

ことり「`print`は、引数を`show`してから`putStrLn`する関数です」  

- `print x = putStrLn (show x)`

穂乃果「本当だ。　Javaとおんなじだね」  

```java
enum Muse { Hanayo, Rin, Maki, Umi, Kotori, Honoka, Eli, Nico, Nozomi }

public class Program {
	public static void main(String[] args) {
		Muse eli = Muse.Eli;
		System.out.println(eli);
	}
}

// vvv 出力 vvv
// Eli
```

ことり「これもパターンマッチすることができるよ」  

```haskell
helloTo :: Muse -> IO ()
helloTo Umi    = putStrLn "ｳﾐﾁｬﾝ♡"
helloTo Honoka = putStrLn "ﾎﾉｶﾁｬﾝ!"
helloTo Kotori = putStrLn "わたしだね"
helloTo x      = putStrLn ("おはようっ♪ > " ++ show x)

main :: IO ()
main = do
  helloTo Umi
  helloTo Honoka
  helloTo Kotori
  helloTo Hanayo
  helloTo Nico
  helloTo Nozomi

-- vvv 出力 vvv
-- ｳﾐﾁｬﾝ♡
-- ﾎﾉｶﾁｬﾝ!
-- わたしだね
-- おはようっ♪ > Hanayo
-- おはようっ♪ > Nico
-- おはようっ♪ > Nozomi
```

穂乃果「えっ、`helloTo`関数の定義がいっぱいあるよ？？？」  
ことり「ふっふっふっ、これもパターンマッチの恩恵なのです」  

ことり「Haskellでは具体型の名称、値構築子、代数的データ型の値、型クラスの名称の頭文字は、必ず英字大文字なの」  

ことり「値構築子、または値コンストラクタっていうのは、`Member`型の`Member String Int`の`Member`
……`honoka`みたいな値を作るときに`String`と`Int`の値を受け取る部分ことだよ」  

```haskell
data Member        -- 具体型の名称
         = Member  -- 値構築子
              String Int

show ::
    a  -- 具体的でない（抽象的な）型の仮名称は頭文字が英字大文字でない
    -> String

data Muse = Hanayo  -- 代数的データ型の値
          | Rin | Maki | Umi | Kotori | Honoka | Eli | Nico | Nozomi

```

- `Show` -- 型クラス名

ことり「そしてこれらを関数の仮引数部に与えたときに、関数でのパターンマッチが起こるんだ」  

```haskell
helloTo :: Muse -> IO ()
helloTo Umi  -- 仮引数部に値が書かれているので、パターンマッチが起こる
    = putStrLn "ｳﾐﾁｬﾝ♡"
helloTo x  -- 仮引数部に名前（変数、具体的な値でないもの）が書かれているので、パターンマッチでない束縛が起こる
    = putStrLn ("おはようっ♪ > " ++ show x)
```

ことり「直積型でのパターンマッチが起こるのも、同じ理屈だよ♪」  

穂乃果「これって……すごいね。　switchじゃないのに、switchみたいに分岐ができてる……」  
ことり「でしょ！　Haskellはifなどの分岐を極力使わないで書ける言語なんだ！」  


# 直和型
ことり「最後に直和型。　今回はこれで最後だから頑張って☆」  
穂乃果「うん！　ファイトだよっ！」  

ことり「直和型は、列挙型と直積型が合わさったようなもので、列挙子がフィールドを持ちます！」  

```haskell
data Student = OtonokiStudent String Int
             | UranohoshiStudent String Int Bool
  deriving (Show)
```

ことり「もちろんレコードも使えるよ」  

```haskell
-- 直和型
data Student = OtonokiStudent { otonokiName :: String, otonokiAge :: Int }
             | UranohoshiStudent { uranohoshiName :: String, uranohoshiAge :: Int, likeMikan :: Bool }
  deriving (Show)
```

ことり「今回のコード例はこちら」  
ことり「名前空間がバッティングするので、`OtonokiStudent`と`UranohoshiStudent`のレコード名は固有のものにしてあるよ」  

```haskell
prettyPrintStudent :: Student -> IO ()
prettyPrintStudent (OtonokiStudent herName herAge) = do
  putStrLn "音ノ木坂学院生徒"
  putStrLn ("name: " ++ herName)
  putStrLn ("age: " ++ show herAge)
prettyPrintStudent (UranohoshiStudent herName herAge sheLikesMikan) = do
  putStrLn "浦の星女学院生徒"
  putStrLn ("name: " ++ herName)
  putStrLn ("age: " ++ show herAge)
  putStrLn ("みかんのこと好き？: " ++ show sheLikesMikan)

main :: IO ()
main = do
  let umi     = OtonokiStudent "園田海未" 16         --
      yoshiko = UranohoshiStudent "ヨハネ" 15 False  -- do式内のletブロックは、複数の名前を定義できるよ
  prettyPrintStudent umi
  prettyPrintStudent yoshiko

-- vvv 出力 vvv
-- 音ノ木坂学院生徒
-- name: 園田海未
-- age: 16
-- 浦の星女学院生徒
-- name: ヨハネ
-- age: 15
-- みかんのこと好き？: False
```

穂乃果「えーっ！　これは……Javaで書くとどうなるんだろう……」  
ことり「これはね、ScalaとかKotlinでも使う書き方があって、それで表現できるんだけど……ちょっとJavaだと可読性が悪くなるんだぁ」  
ことり「ちょっとコードが長くなるよ……注意してね」  

```java
interface Student {}
class OtonokiStudent implements Student {
	public String name;
	public int age;
	public OtonokiStudent(String name, int age) {
		this.name = name;
		this.age = age;
	}
}
class UranohoshiStudent implements Student {
	public String name;
	public int age;
	public boolean likeMikan;
	public UranohoshiStudent(String name, int age, boolean likeMikan) {
		this.name = name;
		this.age = age;
		this.likeMikan = likeMikan;
	}
}

class StudentFunctions {
	public static void prettyPrintStudent(Student she) {
		if (she instanceof OtonokiStudent) {
			OtonokiStudent otonokiGirl = (OtonokiStudent)she;
			System.out.println("音ノ木坂学院生徒");
			System.out.println("name: " + otonokiGirl.name);
			System.out.println("age: " + otonokiGirl.age);
		} else if(she instanceof UranohoshiStudent) {
			UranohoshiStudent uranohoshiGirl = (UranohoshiStudent)she;
			System.out.println("浦の星女学院生徒");
			System.out.println("name: " + uranohoshiGirl.name);
			System.out.println("age: " + uranohoshiGirl.age);
			System.out.println("みかんのこと好き？: " + uranohoshiGirl.likeMikan);
		} else {
			throw new RuntimeException("undefined behavior is detected");
		}
	}
}

public class Program {
	public static void main(String[] args) {
		Student umi = new OtonokiStudent("園田海未", 16);
		Student yoshiko = new UranohoshiStudent("ヨハネ", 15, false);
		StudentFunctions.prettyPrintStudent(umi);
		StudentFunctions.prettyPrintStudent(yoshiko);
	}
}

// vvv 出力 vvv
// 音ノ木坂学院生徒
// name: 園田海未
// age: 16
// 浦の星女学院生徒
// name: ヨハネ
// age: 15
// みかんのこと好き？: false
```

ことり「表現はHaskellに準拠してるよ」  

穂乃果「なるほど……`Student`クラスを継承することで、その子としての属性を与えるんだね……」  
ことり「うん。　共通フィールドである`name`と`age`を`Student`に与えてあげてもよあったんだけど、Haskellに合わせて書いてみると、だいたい誰が書いてもこうなるかな」  

穂乃果「よしこ……ヨハネ？　って誰知り合い？」  
ことり「うんん、全然違うよ♪」  


# おやすみなさい
ーー 就寝（ベッドの中） ーー

穂乃果「代数的データ型ってすごいなあ……そういえば、代数的データ型って何で代数的データ型って言うの？」  
ことり「それはことりもわからないの……圏論由来で[F代数](http://www.weblio.jp/content/F%E4%BB%A3%E6%95%B0)らしいって聞いたことはあるんだけど……」  
穂乃果「圏論？」  
ことり「すごい楽しい、数学の学問だよ♪　でも穂乃果ちゃんが当面Haskellをやるに当たって、別に圏論の知識は必要ないから大丈夫だよ！　圏論の知識があったらあったで役に立つけど、なくても大丈夫」  

穂乃果「そっかー…………なんかすごそうだね。　パターンマッチもすごかったなぁ……書くのが楽になりそう……」  
ことり「パターンマッチは実は関数の仮引数部以外でも、色んなところで使えてね。　それについてはおいおいかな」  

穂乃果（Zzz）ｽﾋﾟｰ  
ことり（ふふ、おやすみなさい）  

…………

（次回に続く）

- [次回（ことり、穂乃果と一緒に学ぶHaskell（入門）その4「型クラスの定義と実装」）](./2017-05-27-learn-haskell-with-muse.html)


# 参考にしたページ
- [アニメ/ラブライブ/呼称表](http://www.palantir-k.net/palawiki/index.php?%E3%82%A2%E3%83%8B%E3%83%A1%2F%E3%83%A9%E3%83%96%E3%83%A9%E3%82%A4%E3%83%96%2F%E5%91%BC%E7%A7%B0%E8%A1%A8)
- [Aquors - Wikipedia](https://ja.wikipedia.org/wiki/Aqours)
- [F代数 - Weblio辞書](http://www.weblio.jp/content/F%E4%BB%A3%E6%95%B0)

- - -

　疑問点があれば、Twitterでリプライくれれば（そのリプライを見逃してなければ）返すよ！  
[\@public_ai000ya - Twitter](https://twitter.com/public_ai000ya)
