---
title: 今までPublishしてきたワールドが突然Unpublished VRChat Worldになってしまうを修正する
tags: VRChat, Unity
---

ハロー・おはよー、あいやです！:sparkles:

最近はVRChatワールド作成にずっぷりはまっています。
こんなワールドを作りました！（作っています。） :point_down:

- - - - -

【ここから広告🤔】

- [HappyBirthdayOurBestFriend](https://www.vrchat.com/home/world/wrld_403fd1e7-4112-4a10-ae07-60fcee56158d)

<blockquote class="twitter-tweet" data-conversation="none"><p lang="ja" dir="ltr">地下みんな、だいすきだぁ～～<br>( ◜◡◝ )𓂃 𓈒𓏸𑁍 <a href="https://t.co/vCGDWI3OAR">pic.twitter.com/vCGDWI3OAR</a></p>&mdash; あいや@VRChat＆ボイトレ (@aiya000_vrchat) <a href="https://twitter.com/aiya000_vrchat/status/1320754405516267521?ref_src=twsrc%5Etfw">October 26, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

- - -

- [HabakiHouse](https://vrchat.com/home/world/wrld_3119281c-8051-4d38-bda3-7416f1bef001)
    - [こちらで無料頒布中](https://aiya000.booth.pm/items/2346700)
    - [こちらでソースを公開中](https://github.com/aiya000/HabakiHouse)

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">【無料・Unity】巾木ハウス【VRChat想定・きれいな木製の家】 | galaxy-sixth-sensey <a href="https://t.co/rQ8LhyzHGn">https://t.co/rQ8LhyzHGn</a> <a href="https://twitter.com/hashtag/booth_pm?src=hash&amp;ref_src=twsrc%5Etfw">#booth_pm</a> <br><br>きれいな感じになったよ～～❣<br>chair collidersもついか！ <a href="https://t.co/ElrgDZYkQF">pic.twitter.com/ElrgDZYkQF</a></p>&mdash; ⿻あいや⿻ 技術書執筆「せつラボ」 (@public_ai000ya) <a href="https://twitter.com/public_ai000ya/status/1313115990255828994?ref_src=twsrc%5Etfw">October 5, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

- - -

- [The someone's heaven](https://www.vrchat.com/home/world/wrld_eaeb8a07-ded4-4e82-a2eb-f9d7850f3bf3)

やさしめのゆめにっきやLSD的な何か。
制作中！

【ここまで広告！】

- - - - -

今回は、ずーっと悩んでいたある問題が解決したので、シェアします！

# 概要

この記事では、
今まで`Build & Publish for Windows`（`Build & Publish for Android`）してきたワールドが、
VRChat SDKのControl Panelで突然**Unpublished VRChat World**になってしまう問題への、
私の場合の解決方法を示します。

この問題ではその他に、次の特徴があります。

- `Build & Publish`を続行すると、**New World Creation**になってしまう
- さらに続行しても、**NullReferenceException**でワールドのPublishはできない

<div class="wrap-fluid">
![](/images/posts/2020-11-09-vrchat-fix-world-creation-null-reference-exception/error.PNG)
</div>

# 解決

私の場合、ワールド内のあるアバターがコンポーネントとして`Pipeline Manager`が含まれていたため、干渉してしまっているせいでした。

![](/images/posts/2020-11-09-vrchat-fix-world-creation-null-reference-exception/pipeline-manager.PNG)

これを右上の歯車から`Remove Component`すれば、無事`Build & Publish`できるようになりました :tada:

# 余談

この問題は下記のツールによって発見されました。

- [VRWorld Toolkit - Booth](https://booth.pm/ja/items/2080961)

またこれを使えば、`Pipeline Manager`を含んだままPublishしようとしても、修正をサジェストしてくれるようでした。

![](/images/posts/2020-11-09-vrchat-fix-world-creation-null-reference-exception/fix-suggestion.PNG)

すごくおすすめです！

- - -

ありがとう！
