---
title: ComboGestureExpressions_V1.5.2のEE Property Explorerで表情が生成されない
tags: VRChat, Unity
---

# EE Property Explorer

これ↓

- [ComboGestureExpressions for Avatars 3.0 + ExpressionsEditor](https://booth.pm/ja/items/2219616)

<div class="wrap-fluid-small">
![](/images/posts/2022-01-29-vrchat-fix-no-function-name-specified-on-cge/right.PNG)
</div>

# 問題: EE Property Explorerで表情が生成されない

こうなってしまった  
プレビューが生成されておらず、灰色の顔画像ばっかり

![](/images/posts/2022-01-29-vrchat-fix-no-function-name-specified-on-cge/left.PNG)

~~UnityのConsoleには`AnimationEvent has no function name specified!`というエラーが大量に出ていた~~
関係なかった

# 修正

僕の場合、シェイプキーがわんさかある、実際のアバターの顔メッシュでないものが選択されていた

![](/images/posts/2022-01-29-vrchat-fix-no-function-name-specified-on-cge/left-point.PNG)

直す  
ほとんどの場合、正しいメッシュ名は`Body`とかじゃないかな？？

![](/images/posts/2022-01-29-vrchat-fix-no-function-name-specified-on-cge/fix.PNG)

# 直った！

直った状態↓

<div class="wrap-fluid-small">
![](/images/posts/2022-01-29-vrchat-fix-no-function-name-specified-on-cge/right.PNG)
</div>

よかった！
