---
title: WIP【Blender未使用】UnityでVRChatアバターの素体（胴体）を入れ替える方法
tags: VRChat, Unity
---

## 初めに

この記事では、下記のシークエンスを解説します。

1. あるアバターから、頭部を切り出す
1. ある素体（アバターのうち胴体）と、切り出した頭部を結合する

また手順は全てUnity上で行い、**Blenderは使用いたしません**！
（重要。筆者はまだBlenderと和解できておりません 🤔 ）

- 用意すべきもの
    - アバター
    - 素体

今回は一例として、下記の構成で説明します。

- 「用意すべきもの」の構成
    - アバター => [NecoMaid-RICH](https://booth.pm/ja/items/2147191)
    - 素体 => [QuQu日帰り温泉プラン](https://booth.pm/ja/items/2259630)

## Special Thanks

まず初めに。

この記事は、先日[えくり様](https://twitter.com/EkuriVr)に教えていただいたことを、そのまま文字化したものです。
記事化の許可を快く許していただきました。
ありがとうございます！

えくり様はアバター改変の有償サポートをしてくださっています！

「改変したアバターを納入」する形ではなく「アバター改変のノウハウ教えてくださる」のが特徴です。
ここで得た知識は、次から自分で生かせるので、大変お得になっています。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">☆えくり流改変サポート☆<br>あなたのカワイイ･カッコイイを形にするお手伝いをいたします！<br>アバターを弄りたいけどやり方がわからない･･･<br>Unityとか複雑でよくわからない･･･<br>自分で調べる時間がもったいない！<br>そんな方にオススメです！気軽にご相談ください！<a href="https://twitter.com/hashtag/VRC?src=hash&amp;ref_src=twsrc%5Etfw">#VRC</a> <a href="https://twitter.com/hashtag/VRChat?src=hash&amp;ref_src=twsrc%5Etfw">#VRChat</a> <a href="https://twitter.com/hashtag/Unity?src=hash&amp;ref_src=twsrc%5Etfw">#Unity</a> <a href="https://twitter.com/hashtag/VRoid?src=hash&amp;ref_src=twsrc%5Etfw">#VRoid</a> <a href="https://t.co/zzpl8cjtC7">pic.twitter.com/zzpl8cjtC7</a></p>&mdash; えくり＠改変サポート受付窓口 (@EkuriVr) <a href="https://twitter.com/EkuriVr/status/1218919490781450241?ref_src=twsrc%5Etfw">January 19, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

気になった方はぜひ。おすすめです！

## 下準備

まずは下記を行っていきます。

1. 基盤のインポート
    - VRCSDK2
    - DynamicBone（必要な場合）
    - UTS2等（必要な場合）

「基盤のインポート」については記事がありふれていますので、説明を省略します。

## 素体の準備
### 素体のインポート

素体の`.fbx`を含んだフォルダごと、ProjectにD&Dします。
（今回の場合は`QuQuonsen`です。）

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/1.PNG)

（
QuQuonsenの場合、
このようなよくわからないダイアログがでてきたので、
とりあえず**Fix now**しました。

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/2.PNG)
）

### 素体fbxのHumanoid化

Projectで`Assets/QuQuonsen/onsen`をクリックすると、
Inspecorが下記のような状態になります。

そこで**Rig**を選択し、
'Animation Type'を**Humanoid**に変更。
その後**Apply**を押します。

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/3.PNG)

ここで'Configure'クリックすると、
Inspectorが次のような状態になります。

ここで各ボーンが正常に、
Humanoid形式に設定されているかが確認できます。

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/4.PNG)

いずれかのボーンが正常に設定されていない場合、
そのボーン部分が赤く表示されます。
（次の画像は'Hips'が'None'に設定されてしまっている場合。）

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/5.PNG)

その場合は'Hierarchy'に表示されているアバターのボーン
（今回の場合`onsen(Clone)`の`Armature > Hips`）
をInspectorのHipsにD&Dしてあげてください。

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/6.PNG)

確認したら'Apply'あるいは'Revert' & 'Done'を押して、元のInspector画面に戻りましょう。

### 素体fbxのMaterial調整

次にInspectorの'Materials'タブをクリックし、
`Location`を**Use External Material**した後、
また`Location`を**Use Embedded Material**に戻して、
そして'Apply'を押してください。

これはBlenderで作成したMaterialを、
Unityに引き継ぐために行うもの、
とのことです。

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/7.PNG)

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/8.PNG)

### 素体シェーダーの設定

さてようやくですが、
素体fbxをHierarchyに追加（D&D）しましょう。

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/9.PNG)

次にその素体配下の、
Armature以外のオブジェクトのシェーダーを**UTS2のToon_DoubleShadeWithFeather**等に変更します。

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/10.PNG)

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/12.PNG)

- - -

ここでシェーダーが変更できない場合があるようです。

僕は下記サイトを参考に

- [Unityでマテリアルが変更できない時 - Sirohood](https://sirohood.exp.jp/20190219-1973/)

先ほど設定した`Materials`の`Location`を**Use External Materials (Legacy)**に変更することで、
シェーダーを変更できるようにしました。

![](/images/posts/2020-08-02-without-blender-composing-avatar-head-and-nbody/11.PNG)

- - -


TODO: 続き書く

TODO: 各画像の幅を設定する

## アバターのインポート

アバターの`.fbx`や`.prefab`をインポートします。
以下、NecoMaid-RICHちゃんの場合です。

`NecoMaidRICH1.1.unitypackage`（現時点での最新版）ファイルをUnityにインポートします。

TODO: 続き書く



- - - - -

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">💥💥💥💥💥💥💥💥💥💥💥💥💥<br>💥 Blenderと和解ガチャ発動！ 💥<br>💥💥💥💥💥💥💥💥💥💥💥💥💥<br><br>🆘⚠️💞 ﾄｩﾙﾙﾝ<br><br>⚠️💞⚠️ ﾄｩﾙﾝ<br><br>💞💞🆘 ﾄｩﾙﾝ<br><br>ﾄｩﾙﾙ ﾙﾙ ﾙﾙ……<br><br>🆘🆘🆘 ﾄﾞｰﾝ!!<br><br>✋✋✋✋✋<br>B l e n d e r と<br>和 解 で き ま せ ん<br>で し た<br>✋✋✋✋✋<a href="https://twitter.com/hashtag/VRChat?src=hash&amp;ref_src=twsrc%5Etfw">#VRChat</a></p>&mdash; ⿻あいや⿻ VRChat＆言語自作＆技術書典「せつラボ」 (@public_ai000ya) <a href="https://twitter.com/public_ai000ya/status/1289179437150244870?ref_src=twsrc%5Etfw">July 31, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
