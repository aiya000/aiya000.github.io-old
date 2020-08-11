---
title: VRChatのアバターを新しいアバターとしてアップロードする
tags: VRChat, Unity
---
## 問題

僕はあるアバターをアップロードしていました。
そのアバターの名前を`X`といいます。
そして今回、`X`に大きな改変を加えました。

大きな改変を行ったので、それを`X`と別物のアバター、`Y`としてアップロードしようと思いました。
そしていつも通りVRChat SDKウィンドウのBuilderで 'Build & Publish for ZZZ' して、Gameウィンドウでアバター名を`Y`に変更し、アップロードしました。

そうしてVRChat上でMy Avatarsを確認したところ、`X`が消えて、`Y`になってしまっていました。

僕は`X`と`Y`の両方を保持したかったのに。

## 解決

解決方法は簡単です。

とりあえずgit（履歴改変ツール的なもの）を操作して、`X`（もともとの状態のアバター）を再アップロードして、ことなきを得たとします。

そしてまたgitを駆使して、`Y`（改変後の状態のアバター）も手に入れました。

それでは、問題を解決していきます。

Hierarchyウィンドウのアバターを右クリックし、Inspectorの**Pipeline Manager (Script)**にある**Detach (Optional)**をクリックします。

<div class="wrap-fluid">
![](/images/posts/2020-08-11-make-vrchat-avatar-as-a-new/1.PNG)
</div>

その後、いつも通りアップロードしましょう。
名前を`Y`に変えてからアップロードしてもいいですし、実は名前を変えなくてもよいです。

大事なのはアバターのIDを**Detach**してからアップロードすると、新しいIDが割り振られてアップロードされる、というところです。

<div class="wrap-fluid">
![](/images/posts/2020-08-11-make-vrchat-avatar-as-a-new/2.PNG)
</div>

ありがとう！
