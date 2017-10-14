---
title: ことり、穂乃果と一緒に学ぶHaskell（入門）その1「代数的データ型の定義」
tags: ラブライブ！で学ぶ, ことり、穂乃果と一緒に学ぶHaskell, Haskell
---

- [記事一覧 - ことり、穂乃果と一緒に学ぶHaskell（入門）](/tags/ことり、穂乃果と一緒に学ぶHaskell.html)
- [更新履歴 - μ'sと一緒に学ぶHaskell](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)

# 前置き（海未ちゃん）

海未「この度は『ことり、穂乃果と一緒に学ぶHaskell（入門）』にお越しいただき、ありがとうございます」  
海未「本企画はこちらの偉大なブログ様に触発されたものです。　是非こちらもご覧ください」  

- [ラブライブ！で学ぶソフトウェア開発入門](http://learn-with-muse.sato-t.net/)

海未「キャラ崩壊を含む可能性があります。　ご容赦くださいますよう」  
海未「それでは、よろしくお願いします 」  

- - -

- [更新履歴 - ことり、穂乃果と一緒に学ぶHaskell（入門）](https://github.com/aiya000/aiya000.github.io/search?utf8=%E2%9C%93&q=%22Haskell%2FMuse%3A%22&type=Commits)

- - -


# ことり、穂乃果と一緒に学ぶHaskell（入門）その1「代数的データ型の定義」

ーー ライブ練習終わり着替え後（部室） ーー

ことり「ふう〜、練習つかれたぁ」  
ことり「ん……？」  

ドタドタドタ

穂乃果「ことりちゃん〜〜、たすけてー！！」  
ことり「わっ、ﾎﾉｶﾁｬﾝ！！　ど、どうしたの〜〜？」  
穂乃果「この前、選択授業を選んだじゃん？　私はHaskellを選んで、1回目の授業を受けたんだけど、全然わからなくって……」  

- - -

+ 音ノ木坂 2年時の選択科目
    1. Haskell
    2. Rust
    3. C++


- - -

穂乃果「前にJavaは習ったんだけど、HaskellってJavaとは全然違うみたいで、頭が追いつかなくて」  
ことり「音ノ木坂は、必修の授業でJavaをやるもんね！　うーん」  

穂乃果「ことりちゃんって、たしかHaskell……やってたよね！　だから教えて欲しくって。　ダメ……？」ｳﾙｳﾙ  

ことり（ううっ、穂乃果ちゃんにそんな顔されたら……ことりだって断れないよぅ）  

ことり「わ、わかったよ！　大丈夫だよ、わたしにまかせて☆」  
穂乃果「わぁ、ありがとうことりちゃん〜！」  

ことり「穂乃果ちゃん、PCって今、持ってる？」  
穂乃果「もちろん！　音ノ木坂の生徒はみんな学校から、ノートPCを貸し受けてるからね！　よいしょっと」  

ことり「うんうん。　じゃあちょっと見せてね。　……よし、OSはArchLinux。　`stack`とテキストエディタは入ってるみたいだね」  

- - -

+ この記事で使用する環境 及び 前提、既知とする環境
    - [stack](https://docs.haskellstack.org/en/stable/README/)
    - なんらかのテキストエディタ
    - コマンドライン
    - stackの実行方法
        - 基本的に`stack runghc -- {ファイル名}`
    - Javaの基本知識
        - 構文を知っている程度を仮定します

- - -

ことり「じゃあ、やっていこうか☆」  
穂乃果「よーし、私！　ファイトだよっ！」  


## 代数的データ型の定義 <a name='datatype-definition'></a>
穂乃果「この前は『代数的データ型』っていうのについて習ったんだけど……今日はここを教えて欲しいなあ」  
ことり「代数的データ型はHaskellの最もたる優れた要素だね！」  

ことり「じゃあ、まずは代数的データ型の定義方法について説明するね」  
ことり「穂乃果ちゃん、Javaで`class`ってあったよね。　こんな感じの`class`をJavaで書いてみてくれる？」  

1. クラス名: Member
1. コンストラクタで以下の値を受け取る
    1. String name
    2. int age
2. その値を、コンストラクタで以下のpublicプロパティに代入する
    1. name > this.name
    2. age > this.age

穂乃果「はーい！　これくらい簡単だよ！」  

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

ことり「よくできました☆」ﾅﾃﾞﾅﾃﾞ  
穂乃果「わーい！　わーい！」ｴﾍﾍﾍﾍ  

ことり「このコードをHaskellに直していくね」  
ことり「Haskellでは、代数的データ型を`data`というキーワードを使って、作っていきます」  

```haskell
data Member = Member String Int
```

穂乃果「すごーい！　1行で書けちゃうんだー！」  
ことり「うん、**Haskellはよく、記述量が少ないって言われるんだー。**　って穂乃果ちゃん、これくらいは授業でも見たはずじゃ……」  
穂乃果「えへへ、実は`data`がこういうのを作るものだってことも、まだわかってなくて……」  

穂乃果「あれ、でも`name`とか、`age`っていう名前は書かないでいいの？」  
ことり「うん、Haskellではプロパティ名みたいなものが必要ないことが多くって、そういう場合はつけないかなぁ」  
ことり「名前をつけることもできるんだけど、今はまだ置いておいてね」  
穂乃果「はい。　ことり先生！」  
ことり「ことり先生なんて……ｴﾍﾍ」  

ことり「これを実際に使うには……そうだ穂乃果ちゃん。　`main`ってもう習ったかなあ？」  
穂乃果「習った！　穂乃果、`main`ならわかるよ！」  

```haskell
main :: IO ()
main = do
  print 10
```

穂乃果「こういうやつ！」  
ことり「さすが穂乃果ちゃん♪」  
穂乃果「あっでもね……`:: IO ()`とか、`do`とかもよくわかってなくって……」  
ことり「大丈夫だよ、そこらへんもおいおいやっていくからね！」  
穂乃果「お願いしますことり先生ー！！」ﾄﾞｹﾞｻﾞｰ  

ことり「じゃあこれ`DataType.hs`っていうファイル名で保存して、実行……っと」  

```console
$ stack runghc -- DataType.hs
10
```

穂乃果「10が表示されたね！　これくらいなら穂乃果もわかるよっ！」  
ことり「さすがさすが♪」  

ことり「じゃあちょっと前の内容に戻って……Javaで、Memberクラスのインスタンスを生成するコードを書いてみてくれるかな」  

```java
public class Test {
	public static void main(String[] args) {
		Member kotori = new Member("南ことり", 16);
	}
}
```

穂乃果「こんな感じ？」  
ことり「そんな感じだね、ありがとう♪　これをHaskellに直すとこうなるよ」  

```haskell
main :: IO ()
main = do
  let kotori = Member "南ことり" 16
  return ()
```

穂乃果「`let`？　`return ()`？」  
ことり「`let`は変数の定義に使うキーワードだよ！　Haskellだと、変数名の前に型名を書かなくてもいいの！」  
ことり「`return ()`は……今は単なるno operationだと思っておいて欲しいな☆」  
穂乃果「no operationは、何もしない命令だったよね。　わかりましたっ！」  


## 型クラスの自動導出
ことり「次は、Memberデータ型を`main`で表示してみるよ」  

ことり「Javaでは、`toString()`っていうメソッドをオーバーライドすることがあったよね」  
穂乃果「クラスインスタンスをprintするときに、いい感じにするあれ……だよね？」  

```java
class Member {
	public String name;
	public int age;
	public Member(String name, int age) {
		this.name = name;
		this.age = age;
	}

	@Override
	public String toString() {
		return "Member " + this.name + " " + this.age;
	}
}
```

ことり「そうそう！　これはこう書けるよ」  

```haskell
data Member = Member String Int
  deriving (Show)
```

ことり「`deriving (Show)`って行を追加したよ」  
穂乃果「これも1行で書けちゃうの！？」  
ことり「うん、そうなんだ♪　でも、もっと表示結果をカスタマイズしたいときは、もうちょっと書く必要があるかな」  
ことり「**こういう単純なパターンを実装したい時には、derivingっていうのを使うよ！**」  

```haskell
main :: IO ()
main = do
  let kotori = Member "南ことり" 16
  print kotori
```

ことり「実行っと」  

```console
$ stack runghc -- DataType.hs
Member "南ことり" 16
```

穂乃果「すごーい！　ちゃんと表示されたー！」  
ことり「やったね！」  

穂乃果「でもことりちゃん、この`Show`ってなに？」  
ことり「それはね穂乃果ちゃん、いわゆる型クラスって言って……」  

…………

（次回に続く）

- [次回（ことり、穂乃果と一緒に学ぶHaskell（入門）その2「関数とデータ型」）](./2017-05-11-learn-haskell-with-muse.html)


# 参考にしたページ

- [Learn You a Haskell for Great Good!（原著） - Types and Typeclasses](http://learnyouahaskell.com/types-and-typeclasses#believe-the-type)
- [μ's - Wikipedia](https://ja.wikipedia.org/wiki/%CE%9C%27s#.E5.8D.97_.E3.81.93.E3.81.A8.E3.82.8A.EF.BC.88.E3.81.BF.E3.81.AA.E3.81.BF_.E3.81.93.E3.81.A8.E3.82.8A.EF.BC.89)

- - -

　疑問点があれば、Twitterでリプライくれれば（そのリプライを見逃してなければ）返すよ！  
[\@public_ai000ya - Twitter](https://twitter.com/public_ai000ya)
