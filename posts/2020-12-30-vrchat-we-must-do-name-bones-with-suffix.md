---
title: アバター改変で服などを着せるするなら、絶対にボーン名を変更しておいた方がいい
tags: VRChat, Unity
---
# 概要

ボーン名を変更しない場合、アバターのArmatureがどんどん肥大化していって、**どのボーンがどの服飾のボーンなのかわからなくなります**。

その場合、ある服飾がいらなくなったときに、どのボーンを削除すればいいのかわからず、手動で確認していくことになります。

見てください、私のArmature。
まったくわからない。

![](/images/posts/2020-12-30-vrchat-we-must-do-name-bones-with-suffix/abandon.PNG)

**手間……手間……！！**

# 「ボーン名の変更」とは？

例えばこの`02`という服は、次のようなボーン構成になっています。（可愛ですよねこの服～～！！:sparkles:）

![](/images/posts/2020-12-30-vrchat-we-must-do-name-bones-with-suffix/unnamed.PNG)

このうち特有のボーン名を持たないボーン（Humanoidの命名に沿ったボーン）の名前の後ろに、`_〇〇`という文字列を追加していきます。

（今回の場合、`Bone`・`skirt〇_〇`といったボーンは特有の名前なので、対象外。気になるならこれらも対象にしていいと思います！）

![](/images/posts/2020-12-30-vrchat-we-must-do-name-bones-with-suffix/named.PNG)

- - -

【おまけ・宣伝】

この操作を自動化したUnityのEditor拡張をリリースしました！
アバター着せ替えツールが手に合わないとき、服がアバター着せ替えツールに対応していなかったりしたときは、どうぞご利用ください:sparkles:

<div class="wrap-fluid">
[![](/images/posts/2020-12-30-vrchat-we-must-do-name-bones-with-suffix/AddBoneNamesSuffixes.PNG)](https://aiya000.booth.pm/items/2615466)
</div>

[【Unity・VRChat】AddBoneNamesSuffixes【子GameObjectの特定の名前にsuffixを追加】 - galaxy-sixth-sensey - BOOTH](https://aiya000.booth.pm/items/2615466)

- - -

そうすると、アバターのArmature内にあるボーンがどの服飾のものかもわかりやすくなるので、管理しやすいですね！

![](/images/posts/2020-12-30-vrchat-we-must-do-name-bones-with-suffix/clearly.PNG)

おわり。

……。

さてそろそろ現実逃避はやめて、どれのものなのかわからなくなった、不明なボーンの名前を**手動で**変更する作業に戻ります……。
まさしくこの記事に書いたことをやってこなかった、ツケでございます。
……えーん。
