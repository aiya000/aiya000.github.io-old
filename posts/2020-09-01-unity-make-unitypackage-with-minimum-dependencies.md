---
title: エクスポートしたいprefabと、その最小限の依存関係のみを持ったunitypackageを作成する
tags: Unity
---

Hi!
VRChatにはまった結果ワールド作成沼にもはまり、最近はあんまりVRChatに行っていない、あいやです。

今回はタイトルの通りのunitypackageを作成する方法を、紹介します。

ちなみにこの方法は僕も偶然みつけただけなので、最初びっくりしました！

## 求める結果

求める結果は下記のような、`HabakiRoom.prefab`と、その最低限の依存関係のみが入ったunitypackageを作成すること。

![](/images/posts/2020-09-01-unity-make-unitypackage-with-minimum-dependencies/1.PNG)

具体的には――

`HabakiRoom.prefab`を提供するために、このunitypackageを作たい。
そのためには、unitypackageに`HabakiRoom.prefab`の依存関係（HabakiRoomのMaterialやTexture・他のprefabなど）も、unitypackageに含む必要があるよね。

――というシチュエーションを解決するもの。

## なぜその「方法」を使うの？

`HabakiRoom.prefab`の依存していない余計なものを入れると容量が大きくなってしまうし、入れたくないですよね。

なので'Exporting package'で、必要なものを手動チェックしていくと、不要なものが入ってしまったり、必要なものが入っていなかったりしてしまう可能性があります。

しかしそこはさすがUnity！　依存関係とターゲットを含んだ最小のunitypackageを作成する機能がありました！

## 方法

本題。
とはいえ、簡単なものです。

1. Projectウィンドウで、ターゲットのprefabをクリックする
  - <div class="wrap-fluid">![](/images/posts/2020-09-01-unity-make-unitypackage-with-minimum-dependencies/2.PNG)</div>
2. そのまま`Export Package...`する
  - ![](/images/posts/2020-09-01-unity-make-unitypackage-with-minimum-dependencies/3.PNG)

これで完了です。

- - - - -

Unityさいこう！
