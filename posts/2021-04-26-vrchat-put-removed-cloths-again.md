---
title: アバターの削除してしまった服や服飾を、もう一度アバターに追加する
tags: VRChat, Unity
---

## 概要

ミーシェちゃんの下着をHierarchy消しちゃったけど、やっぱり使いたい！

<div class="wrap-fluid">
![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/1.PNG)
</div>

## 問題

「元prefabあるんだし、そっちからコピーしてくればいいんじゃ？」
と思い、下記手順を実行しましたが

1. ミーシェちゃんのprefabから、HierarchyにMishe （GameObject） を追加
1. `Mishe/Mishe_underwear`をMishenka [^word-mishenka] の配下にコピー

[^word-mishenka]: 今回下着を着せたい、目的のアバター。

<div class="wrap-fluid">
![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/2.PNG)
</div>

HierarchyからMisheを削除すると、ずれおちちゃいます。
`Mishenka/Mishe_underwear`（元`Mishe/Mishe_underwear`）に紐づいたボーンが削除されちゃうので、それはそう。

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/3.PNG)

なので「一度削除した服や服飾（ボーンが紐づくGameObject）を復活」させるのは簡単には無理だと思ってましたが……
できました！

## 解決

ひとつ自明な解決方法として「`Mishe`の`Armature`を`Mishenka`に対応付けてコピーする[^what-is-correspond]」というのがまず思いつくと思いますが、それだと余分にボーンのGameObjectが増えすぎるので、いやですよね。

[^what-is-correspond]: ここで「対応付けてコピーする」とは、`Mishe`のボーンを`Mishenka`に入れ子にしてコピーする「あの作業」を指します。アバター改変で服とか着せる、いつものあの作業ですね。ここで説明は割愛します。

今回は`Misenka/Mishe_underwear`の**参照するボーンを書き換えてあげる**ことで、対応します。

ちゅーこって早速やっちゃいましょっ。

### `Mishenka/Mishe_underwear`の`SkinnedMeshRenderer`が参照する`m_Bones`を発見する

まずアバタープロジェクトのシーンファイル、ここでは`./Assets/Scenes/SampleScene.unity`をテキストエディタで開きます。

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/4.PNG)

テキストを検索して、`Mishenka/Mishe_underwear`のGameObjectを見つけます。

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/5.PNG)

さっきからテキトーに「紐づいたボーン」とか言っていますが、その実際の紐づきは`SkinnedMeshRenderer`というコンポーネントに記述されています。
（残念ながら、その「紐づき」がUnity上から操作できないみたいなので、テキストエディタで開く必要があります。えーん。）

見つけたGameObject中の`m_Component`のいずれかが、その`SkinnedMeshRenderer`です。

今回はその2つめでした。
（1つめはTransformでした。）

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/6.PNG)

そのfileIDで検索して、`SkinnedMeshRenderer`の記述を見つけます。

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/7.PNG)

そこに`m_Bones`というのがあるので、場所をマークしておいてください :sparkles:

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/8.PNG)

壊れていそうなのがまるわかりですね！

これを正しく書き換えれば、全てが完了します。

### `Mishenka/Mishe_wear`の`SkinnedMeshRenderer`が参照する`m_Bones`をコピーする

「正しく書き換える」って簡単にいいますが、実際にどうすればいいのでしょうか。

実は我々は既に、これが正しかった頃の値をまだ持っています。

`Mishenka/Mishe_wear`（`underwear`でないGameObject。例えば`Mishe_shoes`とかでもいけるかも。）の`SkinnedMeshRenderer`が持っている`m_Bones`を、先ほど`Mishenka/Mishe_underwear`にしたように見つけます。

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/9.PNG)

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/10.PNG)

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/11.PNG)

めっちゃ正しそう。

これをコピーしちゃいましょう。

### 直す！！

最後にコピーした内容を、最初にみつけた`Mishenka/Mishe_underwear`の`SkinnedMeshRenderer`にある`m_Bones`に上書きします。

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/12.PNG)

:point_up: コピーっ！

![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/13.PNG)

:point_up: ペーストしたよっ！

## できた！！

できた！！

<div class="wrap-fluid">
![](/images/posts/2021-04-26-vrchat-put-removed-cloths-again/14.PNG)
</div>

終わりだよ。
