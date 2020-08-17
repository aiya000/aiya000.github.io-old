---
title: 【VRChat API】favorite済みワールド全てをunfavoriteする
tags: VRChat
---
## 対象読者

- LinuxのCLIが使える人

やることはCLIの初歩なので、成熟している必要はありません。

各コマンドの解説も本記事で行うので、見てみてください :sunglasses:

## 想定環境

- Linuxのターミナルエミュレーター（CLI）が使える環境
    - curlコマンドが入っており、jqコマンドを導入できる環境
        - WindowsのWSLやmingw等
        - たぶんcygwinや（がんばれば）Git bashでも可

## 使うもの

- [VRChat API](https://vrchatapi.github.io)
    - VRChatのWeb API

## 本題

そろそろワールドのfavorite枠が足りなくなってきたので、favoriteしてきたワールドのポータルを集めたワールドを作りました :sparkles:

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">移動もべんり！<a href="https://twitter.com/hashtag/VRChat?src=hash&amp;ref_src=twsrc%5Etfw">#VRChat</a> <a href="https://t.co/gPTwnusJyt">pic.twitter.com/gPTwnusJyt</a></p>&mdash; ⿻あいや⿻ VRChat＆言語自作＆技術書典「せつラボ」 (@public_ai000ya) <a href="https://twitter.com/public_ai000ya/status/1294631150816641024?ref_src=twsrc%5Etfw">August 15, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

（VRChat始めてから一か月ですが、もう足りなくなりました……。みなさん、すてきなワールドをありがとうございます :hearts:）

全てのワールドfavoriteをポータルに移植できたので、ワールドfavoriteを全て削除したいと思います。

それは次のCLIコマンドで実現できます。

```shell-session
$ hash=$(echo -n 'aiya000:password' | base64)
$ curl \
    -H "Authorization: Basic $hash" \
    'https://api.vrchat.cloud/api/1/worlds/favorites?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26' \
    > favorite_worlds_unformated.json
$ cat favorite_worlds_unformated.json \
    | jq -r '.[].favoriteId' \
    | xargs -I {} \
        curl -X DELETE \
            -H "Authorization: Basic $hash" \
            'https://api.vrchat.cloud/api/1/favorites/{}?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26'
```

上記では確認のため、一度`favorite_worlds_unformated.json`に中間内容を保存しましたが、保存しなくてもいけると思います。
:point_down:

```shell-session
$ curl -H "Authorization: Basic $hash" 'https://api.vrchat.cloud/api/1/worlds/favorites?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26' \
    | jq -r '.[].favoriteId' \
    | xargs -I {} curl -X DELETE -H "Authorization: Basic $hash" 'https://api.vrchat.cloud/api/1/favorites/{}?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26'
```

## 解説
### base64

base64は「いい感じのハッシュ値」を作るコマンドです。

VRChat APIは`Authorization`ヘッダーに、`<VRChat ID>:<VRChat パスワード>`という文字列をbase64化した（「いい感じのハッシュ値」にした）ものを要求します。
これはいわゆる「認証情報」です。

認証情報を要求することは……
例えばVRChatアカウントの情報を、他の人にいじられないようにするために、必要です。

- [Authorization - VRChat API Documentation](https://vrchatapi.github.io/#/Authorization)

内容は`$hash`変数に保存しておきます。

### curl & `favorite_worlds_unformated.json`

curlコマンドというのはWeb APIを叩くコマンドです。

`-H`というオプションでヘッダーを指定できるので、上記URLの指定する通りに`"Authorization: Basic $hash"`を指定してあげます。

`https://api.vrchat.cloud/api/1/worlds/favorites`というURLは「ユーザーにfavoriteされたワールドを一覧する関数名」のようなものです。
詳細は下記ページにて確認できます。

- [ListWorld - VRChat API Documentation](https://vrchatapi.github.io/#/WorldAPI/ListWorlds)

VRChatはURLクエリーというもので、APIキーを要求します。
上記CLIでいう`?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26`の部分です。

APIキーは、現在は`JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26`ですが、将来変わるかもしれません。

下記ページの章 'Client API Key' で確認できます。

- [Getting Started - VRChat API Documentation](https://vrchatapi.github.io/#/GettingStarted)

これで`favorite_worlds_unformated.json`に「favoriteしたワールド一覧」が保存されました。

### **favoriteしたワールドを全削除する**

本稿の本題です。

削除したいワールドの一覧は`favorite_worlds_unformated.json`に入っていますが、整形されていませんので、jqコマンドを使って整形します。

```shell-session
$ cat favorite_worlds_unformated.json | jq -r '.[].favoriteId'
```

あとはこれを、VRChat APIの`https://api.vrchat.cloud/api/1/favorites/{}`に流してあげるだけです。

- [Delete Favorite - VRChat API Documentation](https://vrchatapi.github.io/#/FavoritesAPI/DeleteFavorite)

`https://api.vrchat.cloud/api/1/favorites/{}`の`{}`には「削除したいワールドの`favoriteId`」というものがあります。
それは`$ cat favorite_worlds_unformated.json | jq -r '.[].favoriteId'`で手に入る、整形済み一覧の各要素のことです。

`https://api.vrchat.cloud/api/1/favorites/{}`は同じくAuthorizationヘッダーとapiKeyを要求するので、乗せてあげます。

curlの`-X DELETE`は「DELETEで、指定されたURLを実行する」というものです。
今のところは「'Delete Favorite'がDELETEを求めるから、指定してあげる」という感じの理解で大丈夫です。

そして最後に
`| xargs -I {} curl -X DELETE -H "Authorization: Basic $hash" 'https://api.vrchat.cloud/api/1/favorites/{}?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26'`
で、`favorite_worlds_unformated.json`の整形済み各要素を、'Delete Favorite'に投げてあげる、ということをします。

これで完了です！
