### TypeScriptでjQueryを扱う with tsd

jQueryだけでなく、angular.jsなども使えます。

* [tsd](https://github.com/DefinitelyTyped/tsd) : JavaScriptファイルをTypeScriptで扱うための型情報ファイルを簡単に落としてこれる
  - 型ファイルは[ここ](https://github.com/borisyankov/DefinitelyTyped)から落とされる

* 前提条件
  - npmコマンドが使える
  - tscコンパイラを扱う環境が整っている [http://gcc0aiya000.blog.fc2.com/blog-entry-51.html](http://gcc0aiya000.blog.fc2.com/blog-entry-51.html)
  - gitコマンドが使える


以下手順。

#### tsdのインストール
``$ npm install -g tsd``

#### tsdを使ってjQueryを型情報ファイルを(カレントディレクトリに)落としてくる
　型情報ファイルは./typingsディレクトリ以下に自動で落とされるので、ファイルが散らばるとかはありません。
``$ tsd install jquery``

#### jQuery自体を落とすのを忘れずに
``$ wget http://code.jquery.com/jquery-2.1.4.min.js``
( ブラウザなどで落としてきてもいい )

#### jQueryを使った型安全プログラミング
　まずは、なんの変哲もないhtmlファイルです。  
hello.html
```
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8">
    <title></title>
    <script type="text/javascript" src="./jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="./hello.js"></script>
  </head>
  <body>
  </body>
</html>
```

　次にTypeScriptをコンパイルしてみます。  
まずは、ちゃんと型エラーが出るか確認。  
hello.ts
```
// jQueryの型情報を読み込みます
/// <reference path="./typings/jquery/jquery.d.ts"/>
$(() => { $("body").html(10); });
```
```
$ tsc hello.ts
hello.ts(2,26): error TS2345: Argument of type 'number' is not assignable to parameter of type '(index: number, oldhtml: string) => string'.
```
多分、別のオーバーロードと思われてますね。  
コンパイル弾かれたので成功っ！  

　今度は正しく動くか試してみます。  
hello.ts
```
// jQueryの型情報を読み込みます
/// <reference path="./typings/jquery/jquery.d.ts"/>
$(() => { $("body").html("Hello, jQuery from TypeScript !!"); });
```
```
$ tsc hello.ts
```
　エラーが出ませんでした！  
カレントディレクトリを見てみると、__hello.js__というファイルができています。  

#### できた。
ブラウザでhello.htmlを開いてみます。
![Result](http://blog-imgs-79.fc2.com/g/c/c/gcc0aiya000/TypeScriptyattahogehogbar.png)


できた！
