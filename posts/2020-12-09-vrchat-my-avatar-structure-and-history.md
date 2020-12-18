---
title: 【Avatar3.0】初心者におすすめのアバター改変【段階別】
tags: VRChat, Unity
---

# 目次

- [初めに](#%E5%88%9D%E3%82%81%E3%81%AB)
- [今回の内容](#%E4%BB%8A%E5%9B%9E%E3%81%AE%E5%86%85%E5%AE%B9)
- [まとめ](#%E3%81%BE%E3%81%A8%E3%82%81)
- [Visitor編 - アバターワールド](#visitor%E7%B7%A8---%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC%E3%83%AF%E3%83%BC%E3%83%AB%E3%83%89)
- [New User編 - NecoMaid RICH](#new-user%E7%B7%A8---necomaid-rich)
  - [アバター改変](#%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC%E6%94%B9%E5%A4%89)
  - [キッシュちゃん素体](#%E3%82%AD%E3%83%83%E3%82%B7%E3%83%A5%E3%81%A1%E3%82%83%E3%82%93%E7%B4%A0%E4%BD%93)
  - [できました](#%E3%81%A7%E3%81%8D%E3%81%BE%E3%81%97%E3%81%9F)
- [Avatar 3.0](#avatar-30)
- [終わり](#%E7%B5%82%E3%82%8F%E3%82%8A)

# 初めに

本稿は「VRChat Advent Calendar 2020」にむけた記事です！:tada:

- [VRChat Advent Calendar 2020](https://adventar.org/calendars/5102)

# 今回の内容

初めましての人は初めまして。
あいやと申します！

VRChatはじめたての頃って、「アバターってなに？」って感じですよね。
あるいはNew Userになってアバターをアップロードできるようになっても、魅力がよくわからなかったり。

今回は「【Avatar3.0】初心者におすすめのアバター改変【段階別】」と称しまして、その魅力の一片を見ていただければと思います！:sparkles:

- - - - -

## 本稿の内容

- 「VRChatはじめてみました」からの、**段階別おすすめアバター**
    - Visitor編
    - New User編
    - 「その後」編
- あるいは単に、筆者の過去・現在の**使用アバターの紹介**

具体的な技術詳細は省かせていただきますので、読み物寄りの内容となっております。

- - - - -

ちなみに、今の私のアバターはこのような感じです:point_down:

<blockquote class="twitter-tweet">
<p lang="ja" dir="ltr">こんにちは<br>「あいや」と申します！<br><br><br>「かわいい」が大好きで、女の子になるのを目指してます🐕️🎀<br><br>「あいちゃん」って呼ばれてます✨<br>呼ばれたいです……<br><br>甘えさせてくれる方、募集中です💕(,,&gt;᎑&lt;,,)<br><br>よろしくおねがいします✨<a href="https://twitter.com/hashtag/VRChat?src=hash&amp;ref_src=twsrc%5Etfw">#VRChat</a><a href="https://twitter.com/hashtag/VRChat%E5%A7%8B%E3%82%81%E3%81%BE%E3%81%97%E3%81%9F?src=hash&amp;ref_src=twsrc%5Etfw">#VRChat始めました</a> <a href="https://t.co/fPAHR67TtO">pic.twitter.com/fPAHR67TtO</a></p>&mdash; あいや@VRChat＆ボイトレ (@aiya000_vrchat) <a href="https://twitter.com/aiya000_vrchat/status/1335597258599923713?ref_src=twsrc%5Etfw">December 6, 2020</a>
</blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

# まとめ

本稿は読み物寄りの内容ですので、蛇足が多くなります。
識者の方々に蛇足は必要ないと思いますので、本稿の趣旨の結論から先に書きます。

1. Lua Avatar WorldからLuaちゃんをもらってくる
    - とにかくアバターワールドをたのしもう！
1. NecoMaid-RICHちゃんを買う
    - **初めてのアバターに最適！**
1. Mesh Deleter With Textureとキッシュちゃん素体を使ってジャージを着る
    - **オリジナリティの獲得**
1. Avatar3.0を使う
    - A3Box + RadialInventory
    - A3BoxのObjectSwitchの代わりにRadialInventoryを使うことで、**作業が楽＆排他的切り替えが楽**

# Visitor編 - アバターワールド

さて「VRChatはじめてみました」の段階。
Visitorは誰もがVRChatの魅力に惚れひれ伏すか、あるいは戸惑うものかと思います。

私的には「最初期ってとにかく楽しめる段階だから、ぼっちでもいいから、とにかくワールド巡ったりしてくれ～～！」って感じですが、本稿の本題から外れますので、ここは引き下がります……。

ぜひVisitorさんは「**アバターワールド**」と呼ばれるワールドを巡ってみて、おすすめのアバターを見つけてみてください:sparkles:

ここで私はLua Avatar Worldで、Luaちゃんと出会いました！

- [Lua Avatar World](https://vrchat.com/home/launch?worldId=wrld_eb63bf25-ee98-4241-b682-75fcc3f86db8&instanceId=28598)

<div class="wrap-fluid">
![](/images/posts/2020-12-09-vrchat-my-avatar-structure-and-history/lua-entrance.png)
</div>

Luaちゃんの様子

<div class="wrap-fluid">
![](/images/posts/2020-12-09-vrchat-my-avatar-structure-and-history/lua-example.png)
</div>

Visitorさんはぜひ、アバターワールドを探してみてね:sparkles:

# New User編 - NecoMaid RICH

さてあなたはようやっとVisitorを抜け出し、VRChatに歓迎されました:tada:

New User。
そう、ついにアバターとワールドがアップロードできるようになったのです。

でもやっぱり……アバターって有料だし、最初は気が引けちゃいますよね。

そこで私のおすすめは、**NecoMaid RICH**ちゃんです！

- [NecoMaid RICH - Booth](https://booth.pm/ja/items/2147191)

※市販アバターの探し方について :point_right: [^to-buy-avatars]

[^to-buy-avatars]:
アバターはBoothで探すのが、私の一番のおすすめです！
あるいはvketさんもいいと思います。:point_right:
「[Booth VRChat アバター](https://booth.pm/ja/search/VRChat%20%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC)」
「[VirtualMarket アバター](https://www.v-market.work/ec/items/?search_condition=%7B%22nameDescription%22%3A%22%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC%22%2C%22page%22%3A1%2C%22limit%22%3A10%2C%22order%22%3A%22enabled_datetime%20DESC%22%7D)」

なんと2020-12-13現在、800円！？

まだあんまりピントこないかもしれませんが、テンションとしてはこんな感じです:point_down:

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">やばい人「VRChatアバターが5000円とかで高すぎる」<br>↑？？？<br><br>普通の人「5000円とかはやすい」<br>↑わかる<br><br>Necomaid-RICH「800円です」<br>↑？？？？？<a href="https://t.co/SoabqWnVbV">https://t.co/SoabqWnVbV</a></p>&mdash; あいや@VRChat＆ボイトレ (@aiya000_vrchat) <a href="https://twitter.com/aiya000_vrchat/status/1333275035704823808?ref_src=twsrc%5Etfw">November 30, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

異常な値段っていうか、もう救済ですね……。

アバターにお金を出すのがまだ億劫な人には、最高の値段。
今だからこそ「値段でアバターを決めるのはもったいない」と思いますが、当時の価値観にとって、うってつけの選択肢でした。

<div class="wrap-fluid">
![私の '微' 改変済みRICHちゃん](/images/posts/2020-12-09-vrchat-my-avatar-structure-and-history/necomaid-rich-example.png)
</div>

ちなみに「**DynamicBone**は絶対に買った方がいい」と誰もかれもに言われたので、ここでDynamicBoneはがんばって買いました。
（今ではやはりこれも、安い買い物だったと思います。）

## アバター改変

さてアバターをアップロードできて、市販のアバターを導入してみたところで、**アバター改変**をするのはいかがでしょうか。

例えば↑で上げた私のRICHちゃんも、天使の羽と輪をつける、ちょっとした改変をしてあります:sparkles:

……とはいえ、それだけだとオリジナリティがなくて、その、体が……
**意識**[^self]に適合しませんよね！

[^self]: もしかしたらもう「もっと可愛い女の子になりたい！」という意識……
内なる**kawaii**が目覚めているかもしれません。
その意識に合わせて、改変をしてあげましょう:sparkles:

それならば、よし、服です～～！
自分で選んだ可愛い服を、自分に着せてあげるんです！

楽しくBoothウィンドウショッピングをして、服を探しましょう。
すごい楽しいんです。Boothウィンドウショッピング！

<div class="wrap-fluid">
![Booth画面](/images/posts/2020-12-09-vrchat-my-avatar-structure-and-history/window-shopping-on-booth.png)
</div>

## キッシュちゃん素体

……と、その前に。

体に服を着せるには、基本的に**素体**と呼ばれるものが必要です。
素体とはおおまかに「裸や下着姿のアバター」のことですです。

実はNecoMaid RICHちゃんやNecoMaidちゃんたち[^necomaids]は、「素体が今は売ってないので、専用服[^special-cloths]がまったくない」という欠点を持ちます。
[^counter-for-clothing]

[^necomaids]:
NecoMaidには、無印・RICH・Premiumの3人がいます。
私の脳内設定では――無印ちゃんはRICHちゃんの若干幼いころで、PremiumちゃんはRICHちゃんの姉。

[^counter-for-clothing]:
これは後述の**Mesh Deleter With Texture**で解決します。
あるいはBlenderで解決していいかもしれませんが、私は小物を作るくらいしか、Blenderを使えない！:sob:

[^special-cloths]:
専用服というのは「このモデル向けに作ったので、このモデルに着せる分には簡単な設定だけで着れるよ」というものです。
非専用服は後述の**Mesh Deleter With Texture**を使うなどの方法で着せる必要があります。
Blenderで解決できることもありますが、……:point_up:

服を着せるには、素体が必要になります。
ですので、どうにかしなきゃいけません。

「服を着るには、体がなければいけません。」 [^no-naked-no-wearing]

[^no-naked-no-wearing]: これ、格言になりませんか？

ここで私は「RICHちゃんから頭をとってきて、キッシュちゃん素体につける」という方法を選びました。

- [『キッシュ』用素体](https://booth.pm/ja/items/1026956)

ここらでだんだん、お金という重力が重くなってきますが、大丈夫ですよね。
大丈夫ですか？

ともあれ体が手に入ったので、服を着れます。

<div class="wrap-fluid">
![](/images/posts/2020-12-09-vrchat-my-avatar-structure-and-history/necomaid-rich-quche-nbody.png)
</div>

服を選ぶよー！！

## できました

というわけで、できましたーー！:sparkles:

私が選んだのは、このジャージです。

<div class="wrap-fluid">
![](/images/posts/2020-12-09-vrchat-my-avatar-structure-and-history/necomaid-rich-onsen-casual-example.png)
</div>

- [VRChat想定　着せ替え改変用3Dモデル　汎用型ジャージ](https://booth.pm/ja/items/1337770)

ジャージ。
「可愛い服って言ったじゃないですか！！」って感じですか？

私もまだこのときは、素直に**kawaii**を自分で体現できなかったのです……。
最初ははずかしいよね //

ていうか、このジャージ可愛いし！

やはり技術的詳細は他で紹介され尽くしているため省略しますが、ここでは以下のようなことを行いました。

- [Mesh Deleter With Texture](https://booth.pm/ja/items/1501527)で体を削り取る
- ジャージを着せる
- 髪を[まとまるロング](https://booth.pm/ja/items/2362976)に変える

おめでとうございます。
この行程を超えたあなたは、きっとあなたの内なる**kawaii**に、バーチャルボディが追いついたことでしょう。

歓迎いたします。ようこそ、ブシドーへ。 [^bushido]

[^bushido]: kawaiiは武士道　―　**ブシドー**　―　。

# Avatar 3.0

最後にAvatar3.0対応をします。
わーい！ [^necomaid-sdk-version]

[^necomaid-sdk-version]:
NecoMaid RICHちゃんはAvatar2.0対応なので、自前でAvatar3.0に移行する必要がありました。
Avatar3.0使いたい！
Avatar3.0を使うと、後述のExpressions Menuというもので、たのしいことがいっぱいできます！

技術的なことは、先日ろーてくちゃんが記事を書いてくれましたので、そちらをご参照ください:sparkles:

- [オリオンちゃんでわかる初心者向けAvatars3.0セットアップ](https://lowteq.fanbox.cc/posts/1693812)

Avatar3.0では、Playable Layersというものが導入されました。

Playable LayersではExpressions Menuという特別なメニューに、様々なロジックを組むことができます。
しかしながらこれはそこそこ手間がかかるので、既存の用意された環境を使います。

- [A3Box - Booth](https://booth.pm/ja/items/2357888)
- [Radial Inventory System V2](https://booth.pm/ja/items/2278448)

Radial Inventory Systemはアバターに「オブジェクトを出し入れする機能」を追加します。
例えば武器やバリアー・耳かきやハムスターなど。
なんと服を着替えたりもできます！

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">あいやのお着換えです💖✨✨<br>案外うまくできてるでしょ！ <a href="https://t.co/QE3p7mvWjE">pic.twitter.com/QE3p7mvWjE</a></p>&mdash; あいや@VRChat＆ボイトレ (@aiya000_vrchat) <a href="https://twitter.com/aiya000_vrchat/status/1338037778672570369?ref_src=twsrc%5Etfw">December 13, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

A3BoxにもObjectSwitchという機能がありますが、Radial Inventory Systemは排他的な切り替えが楽にできたので、そちらを使うことにしました。[^exclusive-toggle]

[^exclusive-toggle]:
例えば服を着替えるときには、「カジュアルなパーカーと鎧を同時に着る」ということはないですよね。
そういうときに「排他的な切り替え」は便利です。
現実では「鎧の下にパーカーを着る」というシチュはありえるかもしれませんが、鎧を着たらパーカーが見えなくなるので、バーチャルでは意味がない！

A3BoxはObjectSwitch以外にもいくつかの機能を持ちます。
それぞれ以下のようなものです。

- ハンドジェスチャー設定機能
    - Avatar2.0ではハンドジェスチャーも自前で設定しなければいけません
    - A3Boxのこれをそのまま使うだけで、Avatar2.0と同じようにハンドジェスチャーによる表情切り替えなどが行えます
- EmoteBox
    - Avatar2.0でのEmoteと同じ機能
        - Avatar3.0でExpressions Menuを用意するときは、Emote機能を自前で用意する必要があります
    - A3Boxでは32個のEmoteが同梱されています
        - 最強:pray::heart:
- FaceBox
    - 表情をメニューで選択し、切り替えを行う機能
    - 「笑顔とピースサインで写真を撮りたいけど、ピースサインはハンドジェスチャーで怒り顔に設定している」というときに便利です[^aaaaaaaaaaa]

[^aaaaaaaaaaa]: ピースサインで怒り顔の人以外……つまり表情とハンドジェスチャーを独立させたい人の全員に便利です

# 終わり

あなたのkawaiiは見つかりましたか？
あるいはkakkoiiかもしれませんし、もっと他のものかもしれません。

そう、芽生え始めたor芽生えるかもしれない、あなたの**バーチャルに対する意識**のことです。
あえて**バーチャル自我**とでも言い直しましょうか:hearts:

あなたのバーチャル自我としあわせ・平穏が、ありますよう祈っております:sparkles:

<div class="wrap-fluid">
![](/images/posts/2020-12-09-vrchat-my-avatar-structure-and-history/my-avatar-1.jpg)
</div>

<div class="wrap-fluid">
![](/images/posts/2020-12-09-vrchat-my-avatar-structure-and-history/my-avatar-2.jpg)
</div>

<div class="wrap-fluid">
![](/images/posts/2020-12-09-vrchat-my-avatar-structure-and-history/my-avatar-3.png)
</div>

おわり。
