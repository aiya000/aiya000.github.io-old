---
title: ことり、穂乃果と一緒に学ぶHaskell（入門）その2「関数とデータ型」
tags: ラブライブ！で学ぶ, ことり、穂乃果と一緒に学ぶHaskell, Haskell
---

- [前回（ことり、穂乃果と一緒に学ぶHaskell（入門）その1「代数的データ型の定義」）](./2017-05-06-learn-haskell-with-muse.html)
- [記事一覧 - ことり、穂乃果と一緒に学ぶHaskell（入門）](/tags/ことり、穂乃果と一緒に学ぶHaskell.html)
- [更新履歴 - μ'sと一緒に学ぶHaskell](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)

# 前回
ことり「次は、`Member`データ型を`main`で表示してみるよ」  
ことり「これはこう書けるよ」  

```haskell
data Member = Member String Int
  deriving (Show)
```

ことり「`deriving (Show)`って行を追加したよ」  
ことり「**こういう単純なパターンを実装したい時には、derivingっていうのを使うよ！**」  

穂乃果「でもことりちゃん、この`Show`ってなに？」  
ことり「それはね穂乃果ちゃん、いわゆる型クラスって言って……」  


# Showってなあに？
ことり「実はね穂乃果ちゃん、型クラスは型に振る舞いを与えるんじゃなくて、**ある関数の実装を与えるんだよ**」  
穂乃果「『ある関数の実装』？」  
ことり「うん、例えば`Show`は、`Show`を実装したデータ型である`Member`に対して`show :: Show a => a -> String`なる関数の実装を与えるよ♪」  
ことり「`Show`（頭文字大文字）が型クラス名、`show`（頭文字小文字）は関数名だよ！」  

穂乃果「ちょちょっとまってことりちゃん、何か今、すごい勢いで知らない言葉が出てきたよ！？　`Show a => a -> String`って何！？」  
ことり「そこ気になっちゃう？　気になっちゃうよね！　ここすっごく大事なところだから、やっていこうか♪」  


# 関数
ことり「穂乃果ちゃん、関数の定義方法は授業では習った？」  
穂乃果「い…いちおう……。　えーと、こういうのだっけ」  

```haskell
add1 :: Int -> Int
add1 x = x + 1
```

穂乃果「この`add1`の後に書いてある`x`が`Int`の引数…」  

穂乃果「でも`::`とか`->`とか、よくわかんないな……」  
ことり「説明していくね」  

ことり「まず`:: Int -> Int`っていうのは、`add1`っていう関数に`Int -> Int`っていう型を付けているんだ」  
ことり「`::`っていうのを使うと、ある名前（変数）に型を付けてあげられるよ」  
ことり「『`add1`は`Int -> Int`という型を持つ名前』ってことを書いているの」  

ことり「別の例を挙げると……」  

```haskell
ten :: Int
ten = 10
```

ことり「Javaに直すと、こうかな」  

```java
int ten = 10;
```

穂乃果「なるほど、でもさっきの例と違って、これは数じゃなくて、変数じゃない？」  
ことり「ふふふ、そうなんです。　Haskellでは関数と変数もあまり区別がなくってね……こほん。　ちょっとこれについてはまたあとでね」  

ことり「Haskellでは`->`というのが、関数の型を作ります。　例えば」  
ことり「さっきの`Int -> Int`は『引数にIntを1つ受け取って、戻り値にIntを返す』ということを表す型だよ。　Javaに直すとこうかな！」  

```java
int add1(int x) { return x + 1; }
```

穂乃果「なるほど！　Javaの関数定義だと戻り値の型が前に来てるけど」  

<font color='blue'>**int**</font> add1(int x) { return x + 1; }  

穂乃果「Haskellだと戻り値の型が後に来るってことかな？」  

add1 :: Int -> <font color='blue'>**Int**</font>  
add1 x = x + 1

ことり「こんぐらっちゅれーしょんだよ〜　穂乃果ちゃん♡」ﾅﾃﾞﾅﾃﾞﾖｼﾖｼ  
穂乃果「えへへ！」ｴﾍﾍ  

ことり「例えばこんな多引数の関数も」  

<font color='blue'>int</font> constTen(<font color='orange'>char</font> x, <font color='purple'>boolean</font> y) { return 10; }

ことり「こういうふうに変換されます！」  

constTen :: <font color='orange'>Char</font> -> <font color='purple'>Bool</font> -> <font color='blue'>Int</font>  
constTen x y = 10

穂乃果「へー、引数の数が増えても、戻り値の型は最後に来るんだ」  
ことり「そういうことだね！」  


# 型制約
穂乃果「`Show`についてだけどことりちゃん、さっきことりちゃんはこう言ってたよね」  

- - -
ことり「うん、例えば`Show`は、`Show`を実装したデータ型である`Member`に対して`show :: Show a => a -> String`なる関数の実装を与えるよ♪」  

```haskell
data Member = Member String Int
  deriving (Show)
```
- - -

穂乃果「`show :: Show a => a -> String`これ……何かを受け取って`String`を返してるshow関数に見えるけど……`Show a => a`ってなんだろう……」  
ことり「そのとおりだよ穂乃果ちゃん！」  
穂乃果「ほへっ！？！？」  

ことり「`a -> String`っていうのは『何か`型a`を受け取って、`String`を返す』っていう型なんだ。
　だからさっき穂乃果ちゃんが言った『何かを受け取って`String`を返してる』っていうのは大正解なの♪」  
穂乃果「エーッ！？　えーと、自分が言ったことなんだけど、よくわからないや……`型a`って、『何か』って何？　どういうこと？」  

ことり「`型a`っていうのは、何の型でもいいの。　任意の型a。　具体例を示すと」  

```haskell
id :: a -> a
id x = x
```

ことり「こんな、xを受け取ってxをそのまま返す関数とか。　これって別に、`a`が`Int`でも`Char`でも`Member`でも、同じことができるよね！
　Haskellではそれをこうやって、簡単に書くことができるんだ」  
穂乃果「そっか、`a`の内容に言及する必要がないんだね。　だから……もしかしてこれって、ジェネリクス？」  
ことり「そのとおり！　Javaではこれをジェネリクスとして表現してるね」  

```java
public class Program {
	public static <T> T id(T x) {
		return x;
	}

	public static void main(String[] args) {
		System.out.println(id(10));
		System.out.println(id('x'));
		System.out.println(id("kotohono"));
	}
}
```

- - -

ことり「次に`Show a => a`っていう表現だね。　これは」  
ことり「さっきの`a`が『任意の型a（何でも）』だったのに比べて、『Showを実装する任意の型a（Showを実装するなら何でも）』って言えるかな」  

穂乃果「じゃあ`show :: Show a => a -> String`っていうのは……Showを実装する型aを受け取って、文字列（`String`）を返す関数`show`？」  
ことり「そのとおりです！」  

ことり「実はIntもCharもBoolもShowを実装するので、こんなことができるよ」  

```haskell
main :: IO ()
main = do
  putStrLn (show 10)
```


（文字列を受け取って、その文字列を標準出力に表示する関数putStrLn）

```haskell
putStrLn :: String -> IO ()
```

ことり「『型XがShowを実装する』ってことを、『型XはShowインスタンスである』って言ったりもするかな！
　『IntはShowインスタンスである』みたいにね。」  
ことり「Haskellでの『インスタンス』は、他のオブジェクト指向言語でのインスタンスとは趣が違うから注意だね。　値じゃなくて型に対する言葉なんだ」  

穂乃果「なるほど……こんな感じかな？」  

```java
class Member implements Show {
	public String name;
	public int age;
	public Member(String name, int age) {
		this.name = name;
		this.age = age;
	}

	@Override
	public String show() {
		return "Member " + this.name + " " + this.age;
	}
}

interface Show {
	public String show();
}

public class Test {
	public static <T> T id(T x) { return x; }
	public static void main(String[] args) {
		Member kotori = new Member("南ことり", 16);
		System.out.println(kotori.show());
	}
}
```

ことり「いいね穂乃果ちゃん！ 　型クラスはよく、interfaceと似てるって言われたりもするんだぁ
　今回の、`deriving`を利用した`Show`インスタンスの実装は、ちょうどそうなるね！」  
穂乃果「やったぁ♪　……『`deriving`を利用した`Show`インスタンスの実装は』……？」  

ことり「うん、`deriving`って実は全ての型クラスに対してできるわけじゃなくってね、`Show`や基本的な型クラスのみができるんだ」  
ことり「じゃあ`deriving`できない型クラスはどうやって使うのかって言うと……`instance`ってキーワードを使います。
　これを使って、`Show`インスタンスを自分で実装することもできるんだ」  
ことり「`deriving`はあくまで、自分で実装するところをコンパイラが機械的にやってくれてるだけ……ほらここ」  

```java
@Override
public String show() {
	return "Member " + this.name + " " + this.age;
}
```

ことり「returnする文字列を自分で構築してるよね。　これをHaskellはコンパイラが勝手にコードを書いてくれるんだ♪」  

穂乃果「ほえー……機械が勝手に書いてくれるんだぁ……」  

…………

（次回に続く）

- [次回 - ことり、穂乃果と一緒に学ぶHaskell（入門）その3「代数的データ型の定義2」](./2017-05-12-learn-haskell-with-muse.html)

- - -

　疑問点があれば、Twitterでリプライくれれば（そのリプライを見逃してなければ）返すよ！  
[\@public_ai000ya - Twitter](https://twitter.com/public_ai000ya)
