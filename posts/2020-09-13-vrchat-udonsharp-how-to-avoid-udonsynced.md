---
title: Udon#でUdonSyncedを使わない方法
tags: VRChat, Udon#
---
# 目標

Udon#コードで`UdonSynced`を使わずに、各ネットワークユーザーの`bool`の値を同期する。
`int`もがんばってみる（ただし`int`に対しては、不完全な対応になります）。

# まとめ

以下のようなコードでがんばります。

- `bool`向け対応

```cs
using UdonSharp;
using UnityEngine;
using VRC.Udon.Common.Interfaces;
using VRC.Udon;

/// <summary>
/// Sets a value with network users.
///
/// NOTE:
/// Don't use DoSetValueTo*() directly.
/// Please use Set() instead.
/// </summary>
public class BoolSync : UdonSharpBehaviour {
    private bool val = false;

    public void Set(bool val) {
        this.SendCustomNetworkEvent(NetworkEventTarget.All, "DoSetValueTo" + val);
    }

    public void DoSetValueToTrue() {
        this.val = true;
    }

    public void DoSetValueToFalse() {
        this.val = false;
    }

    public bool Get() => this.val;
}
```

- `int`向け対応
    - `-1, ..., maxValue`という範囲への限定的な対応
    - メタプログラミングがんばれば`int.MinValue, ..., int.MAX_VALUE`くらいも可能ではあると思う（Udon#でメタプログラミングできるかは不明）

```cs
using UdonSharp;
using UnityEngine;
using VRC.Udon.Common.Interfaces;
using VRC.Udon;

public class IntSync : UdonSharpBehaviour {
    private readonly int MAX_VALUE = something;  // 最大値

    private int val = 0;

    public void Set(int val) {
        if (val > -1 && this.MAX_VALUE < val) {
            Debug.Log($"Illegal argument (the argument must be -1~{this.MAX_VALUE}): {val}");
            return;
        }

        if (val == -1) {
            this.SendCustomNetworkEvent(NetworkEventTarget.All, "DoSetValueToNothing");
        } else {
            this.SendCustomNetworkEvent(NetworkEventTarget.All, "DoSetValueTo" + val);
        }
    }

    public int Get() => this.val;

    /* - - vvvvvvvvvvvvvvv - - */
    /* - - v UNDERGROUND v - - */
    /* - - vvvvvvvvvvvvvvv - - */

    public void DoSetValueToNothing() {
        this.val = -1;
    }

    public void DoSetValueTo0() {
        this.val = 0;
    }

    public void DoSetValueTo1() {
        this.val = 1;
    }

    public void DoSetValueTo2() {
        this.val = 2;
    }

    public void DoSetValueTo3() {
        this.val = 3;
    }

    /* 以下、対応させたい値まで各 */
}
```

ある`UdonSharpBehaviour`でそれぞれを使う。

```cs
public class Foo : UdonSharpBehaviour {
    public BoolSync paused;
    public BoolSync unPaused;
    public IntSync playing;
}
```

これらのためのGameObjectを作る。

![](/images/posts/2020-09-13-vrchat-udonsharp-how-to-avoid-udonsynced/setup-x-sync-as-gameobjects.PNG)

`Foo`のInspectorでそれらをD&Dして参照させる。

![](/images/posts/2020-09-13-vrchat-udonsharp-how-to-avoid-udonsynced/using-x-sync.PNG)

# 導入

先日、VRChat（VRCSDK3）向け音楽プレイヤーをリリースしました :tada::sparkles::sparkles:

- [【無料・設定・改変しやすい】EasyAudioPlayer【音楽再生VRChatオブジェクト】](https://aiya000.booth.pm/items/2328424)

<iframe width="560" height="315" src="https://www.youtube.com/embed/HOQmMhuBhUE" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

これのネットワーク同期を実装するにあたって、「`UdonSynced`が同期されたりされなかったりする」という問題が起きました。

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">UdonSyncedなintが同期されない件、解決しました✨😊<br><br>// これで解決する<br>for (var i = 0; i &lt; 100000; i++) {} <a href="https://t.co/j5CQiHmpr4">pic.twitter.com/j5CQiHmpr4</a></p>&mdash; ⿻あいや⿻ VRChat＆言語自作＆技術書典「せつラボ」 (@public_ai000ya) <a href="https://twitter.com/public_ai000ya/status/1302519775604604928?ref_src=twsrc%5Etfw">September 6, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

おそロシア。

また`UdonSynced`についての仕様が見つからなかったので（どういうことなの？？）、`UdonSynced`を捨てる覚悟を決めました。

# 解説

これに対して上記「まとめ」に書いたように、対応しました。

`int`に関しては読者様に納得していただけるような対応ではないと思いますが、今回の用途ではこれで十分だったため、このようにしました。

「`IntSync`って言ってるけど`int`じゃないじゃん！」……
はい、まったくもってその通りでござる。

……。

## 設定方法

まず最初の難解な部分は、`BoolSync`および`IntSync`が`UdonSharpBehaviour`であることでしょうか。

これは現時点（2020-09-13）でUdon#が`UdonSharpBehaviour`以外のクラスを作成できないためです。

そのためのワークアラウンドを示していきます。

ここで`BoolSync`や`IntSync`を使いたいUdonBehaviorのあるGameObjectを`Foo`と呼び、次のように定義しておきます。

```cs
public class Foo : UdonSharpBehaviour {
    public BoolSync paused;
    public BoolSync unPaused;
    public IntSync playing;

    public override void Interact() {
        Debug.Log(this.paused.Get());
        Debug.Log(this.unPaused.Get());
        Debug.Log(this.playing.Get());
    }
}
```

ここでそれぞれのフィールドは`public`である必要があります。
それはそれぞれを、UnityのInspectorで設定してあげる必要があるからです。
（その方法を、次に示します。）

次にそれぞれのフィールドの値を保持するものを、GameObjectとして作成してあげます。
（今回はEmpty Objectの中にまとめて作りました。）

![](/images/posts/2020-09-13-vrchat-udonsharp-how-to-avoid-udonsynced/setup-x-sync-as-gameobjects.PNG)

その後、`Foo`を設定されているGameObjectをクリックし、Public VariablesにそれぞれをD&Dしてあげます。

![](/images/posts/2020-09-13-vrchat-udonsharp-how-to-avoid-udonsynced/using-x-sync.PNG)

設定は以上です。

あとは`Foo#Interact()`などで、`this.paused`・`this.unPaused`・`this.playing`の`Set()`・`Get()`メソッドを使ってあげてください。

（余談: setter/getterを使ってないのも、Udon#がそれをサポートしてくれてないから……。）

- - - - -

以上です。

ありがとう！
