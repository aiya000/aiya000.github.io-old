---
title: Vim_scriptで定数
tags: Vim, プログラミング
---
# Vim scriptで定数

```
let A = 10
lockvar A
let A = 20  " 例外
```

これでできるらしい。  
ただし、これでできるのは「変数への書き込み禁止」であって  
書き込み禁止を解除することが可能。

```
let A = 10
lockvar A
unlockvar A
let A = 20  " 通る
```

なので、強制力はないけど意味力のある変数…って感じになる。  
  
まとめるとこう書ける。

```
let A = 10 | lockvar A
```


さらに注意として、間接的に他の辞書などを書き換え禁止できない。  
```
let B = {'bar' : {'baz' : 30}} | lockvar B
let B.bar.baz = 40  " 通る
let C = {'hoge' : [10]} | lockvar C
let C.hoge[0] = 20  " 通る
```

もちろんこういう対策もできるはできる。
```
let D = {'ahoge' : [10]} | lockvar D | lockvar D.ahoge[0]
```


便利。


- - -
追記  

強者さん達に助言をいただきました。
<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr"><a href="https://twitter.com/public_ai000ya">@public_ai000ya</a> lockvar [深度] [変数] にすれば，B, Cの例は回避できます．&#10;lockvar 3 B&#10;極端に，lockvar 100 C とかもありかもしれませんねっ．</p>&mdash; koturn@就活笑顔赤べこウンウンマン (@koturn) <a href="https://twitter.com/koturn/status/620587123918290944">2015, 7月 13</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>
<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr"><a href="https://twitter.com/public_ai000ya">@public_ai000ya</a> <a href="https://twitter.com/koturn">@koturn</a> 単に lockvar! 使うという手もありますね</p>&mdash; バンビちゃん@実際無職 (@pink_bangbi) <a href="https://twitter.com/pink_bangbi/status/620712436736208896">2015, 7月 13</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

前者の例を使うとこうなります。
```
let A = {'foo' : {'bar' : 10}} | lockvar 3 A
let A.foo.bar = 20  " 例外
```

後者の例を使うとこうなります。
```
let B = {'hoge' : {'baz' : 10}} | lockvar! B
let B.hoge.baz = 20  " 例外
```

koturnさん、バンビさん、ありがとうございます！
