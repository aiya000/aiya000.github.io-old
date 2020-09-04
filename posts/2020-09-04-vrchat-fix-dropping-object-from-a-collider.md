---
title: 【VRChat・メモ】ちゃんとコライダーを設定してるのにオブジェクトが床の下に落ちてしまうときの修正方法
tags: VRChat, Unity
---

あるGameObject`X`が、PlaneなGameObject`Plane`のちょうど上に、positionを設定しました。
このときのHierarchyは下記のようになっていました。

```
MainScene
|-- X
|-- Plane
```

そして`X`に`UdonBehavior`（'Synchronize Positoin'）・`BoxCollider`・`VRC Pickup`を設定しましたが、なぜか`Plane`の下に落ちてしまいました。

その後Hierarchyを以下のようにすると、`X`は`Plane`の上に乗っかるようになりました。

```
MainScene
|-- Plane
    |-- X
```

なんで～～ :cry::sweat_drops:
