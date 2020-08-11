---
title: VRChatのアバターをローカルで簡易テストする
tags: VRChat, Unity
---

今回は、Unity上でVRChatアバターの**簡易**テストを行う方法を紹介したいと思います :sunglasses:

## 概要

UnityちゃんのダンスをEmoteに設定し、**VRCDeveloperToolのVRCAvatarTester**で再生する。

## 準備するもの

- VRCSDK2
- [VRCDeveloperTool](https://booth.pm/ja/items/1016739)
- ユニティちゃんライブステージ！ -Candy Rock Star-
    - [こちら](https://unity-chan.com/contents/guideline/)からダウンロード
- つぶしてもいいEmoteをひとつ

## 方法

まずはテストしたいアバターの入ったUnityプロジェクトに、VRCSDK2とVRCDeveloperToolをimportします。

次に「ユニティちゃんライブステージ！ -Candy Rock Star-」のzipから`unitychan-crs-master\Assets\UnityChan\Animations`をProjectウィンドウにD&Dします。

<div class="wrap-fluid">
![](/images/posts/2020-08-11-vrchat-test-avatar-at-local/1.PNG)
</div>

Hierarchyウィンドウのアバターを右クリックし、Inspectorの'Custom Standing Anims'をクリックします。

<div class="wrap-fluid">
![](/images/posts/2020-08-11-vrchat-test-avatar-at-local/2.PNG)
</div>

するとProjectウィンドウに、設定されているアニメーションオーバーライド（ここでは`CustomOverideEmpty1`）がハイライトされるので、それをクリックします。

<div class="wrap-fluid">
![](/images/posts/2020-08-11-vrchat-test-avatar-at-local/3.PNG)
</div>

InspectorにEMOTE1～8が表示されるので、好きなものを選び（ここではEmote4）、その右側にあるドットをクリック。

<div class="wrap-fluid">
![](/images/posts/2020-08-11-vrchat-test-avatar-at-local/4.PNG)
</div>

`001_SAK01_Final`を選択し、選んだEmoteに設定します。

<div class="wrap-fluid">
![](/images/posts/2020-08-11-vrchat-test-avatar-at-local/5.PNG)
</div>

その後VRCDeveloperToolのVRCAvatarTesterウィンドウで、Playします。

（詳しいVRCAvatarTesterの使い方は[こちら](https://booth.pm/ja/items/1016739)を参照ください :bow:）

<div class="wrap-fluid">
![](/images/posts/2020-08-11-vrchat-test-avatar-at-local/6.PNG)
</div>

これでユニティちゃん踊りをアバターがやってくれるので、チェックします。

ありがとう！
