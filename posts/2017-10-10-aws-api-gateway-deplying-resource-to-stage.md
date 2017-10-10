---
title: AWS API Gatewayのリソースを作成したらステージへのデプロイが必要
tags: AWS
---
　AWSのAPI Gatewayで、受け取ったjsonパラメータをそのまま返すechoサーバをリリースに定義したのだけど、
それに対するAPI Gateway上での`テスト`行うのはうまくいくのに、
下記のような手元からのcurlコマンドはうまくいかない。

```console
$ curl \
        -H 'x-api-key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' \
        -d '{"dia":"ruby"}' \
        -H 'Content-Type: application/json' \
        -X POST \
        'https://xxxxxxxxxx.execute-api.yyyyyyyyyyyyyy.amazonaws.com/test/lackybeast'
{"message":"Internal server error"}
```

とても恐ろしい集団心理である…

- 「`{"dia":"ruby"}`！　`{"dia":"ruby"}`はまだか！！」
- 「なぜ出来ない！！！　一体どうなってるんだ！！！」
- 「エラーレスポンスが、お粗末すぎるぞォーー！！！！！」
- 「早く…`{"dia":"ruby"}`をくれ…」

なぜなら、もうお分かりだろう。

誰も…<p class='don'>デプロイをしていないのである！！</p>

- 「誰か早く`{"dia":"ruby"}`を返してくれー！！　正常なjsonレスポンスを！！　誰かーー！！」

そう！！　誰も！！　<p class='don'>リリースをステージにデプロイしていないのである！！！！！</p>

![created-POST](/images/posts/2017-10-10-aws-api-gateway-deplying-resource-to-stage/POST-is-created.png)  
　

- 「どうしてー！！　API Gatewayは何をしているのーー！！　早く成功レスポンス返してー！　お願いー！！」

こう、泣きながら叫んでいるエリちゃんでさえ。

誰も！！　誰も<p class='don'>デプロイをしていないのである！！！</p>

![must-deploy](/images/posts/2017-10-10-aws-api-gateway-deplying-resource-to-stage/deploy-is-needed.png)  
　

- - -

　どこが`Internal server error`やねん。


# 参考ページ

- [誰も消防車を呼んでいないのである！とは (ダレモショウボウシャヲヨンデイナイノデアルとは) [単語記事] - ニコニコ大百科](http://dic.nicovideo.jp/a/誰も消防車を呼んでいないのである!)
