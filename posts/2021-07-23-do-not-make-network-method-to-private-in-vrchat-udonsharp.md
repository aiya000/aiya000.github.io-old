---
title: UdonSharpでメソッドをthis.SendCustomNetworkEvent()で呼び出すときは、メソッドをprivateにしない
tags: VRChat, Udon#
---

:x: 「`howdy :)`」が表示されない

```cs
public void Start() {
  this.SendCustomNetworkEvent(NetworkEventTarget.All, "Foo");
}

private void Foo() {
  Debug.LogError("howdy :)");
}
```

:o: 「`howdy :)`」が表示される

```cs
public void Start() {
  this.SendCustomNetworkEvent(NetworkEventTarget.All, "Foo");
}

// Not `private`
public void Foo() {
  Debug.LogError("howdy :)");
}
```

当たり前だけど！！！

すごいなやんだぞ～～！！！！(つ﹏<)･ﾟ｡
