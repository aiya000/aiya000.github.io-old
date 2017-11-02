---
title: haskell-stackにlibHSyaml-0.8.24-2wdOOQKc6Dt63OCZo8Nf1H-ghc8.2.1.soがないとか言われた
tags: Haskell
---
# 起こった問題

```console
$ stack
stack: error while loading shared libraries: libHSyaml-0.8.24-2wdOOQKc6Dt63OCZo8Nf1H-ghc8.2.1.so: cannot open shared object file: No such file or directory
```


# 結論
　以下のコマンドで解決できる。

```console
$ yaourt -U /var/cache/pacman/pkg/stack-1.4.0-37-x86_64.pkg.tar.xz
$ yaourt -S haskell-stack-git
# PKGBUILDの編集で、依存関係からtlibinfoとstackを消す
```


# 事の流れ
　あることのために、ArchLinuxに`static-stack`という`haskell-stack-git`と競合するパッケージを入れる必要があった。
事を終えた後に`yaourt -S stack`をした後に`$ stack`を実行してみると、以下のエラーを吐いた。

```console
$ stack
stack: error while loading shared libraries: libHSyaml-0.8.24-2wdOOQKc6Dt63OCZo8Nf1H-ghc8.2.1.so: cannot open shared object file: No such file or directory
```

　つまるところ、stackコマンドほぼ全体が使えない。

　libHSyaml-0.8.24-2wdOOQKc6Dt63OCZo8Nf1H-ghc8.2.1.soはおそらくstack setupで入ったその場のghc8.2.1と結びついたライブラリだと思われる。
なので`$ stack setup`し直せばいけるか？　とも思ったが、しかしstackコマンドが使えないので、それもできない。

　幸いこのArchLinuxには`/var/cache/pacman/pkg/stack-1.4.0-37-x86_64.pkg.tar.xz`が存在したので`yaourt -U`でそれを入れると、
正常に動いた。

　その後`$ stack setup`してみるも「既にghcは入っている」的なことを言われたが`$ rm -rf ~/.stack`を試すのも馬鹿らしいので、
また`haskell-stack-git`を入れることにした。

```console
$ yaourt -S haskell-stack-git
# PKGBUILDの編集で、依存関係からtlibinfoとstackを消す
```

　これで解決した。
