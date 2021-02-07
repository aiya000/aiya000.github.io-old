---
title: 【Nuxt.js】storeでないモジュールを`@/store/`配下に置いてはいけない
tags: Nuxt.js, TypeScript, JavaScript
---
【Nuxt.js】storeでないモジュールを`@/store/`配下に置いてはいけない。[^notice-at]

[^notice-at]: `@/foo`の`@/`はプロジェクトディレクトリのトップを表す。

# 問題と解決

ある日、Nuxt.jsのstore機構を理解しないまま`./store/password.ts`というファイルを作成すると、下記の実行時エラーになった。

```
client.js?06a0:97 TypeError: Cannot set property password of #<Object> which has only a getter
    at eval (index.es.js?9e80:61)
    at Array.forEach (<anonymous>)
    at useAccessor (index.es.js?9e80:59)
    at eval (index.es.js?9e80:66)
    at _callee$ (nuxt-typed-vuex.js?679e:8)
    at tryCatch (runtime.js?96cf:62)
    at Generator.invoke [as _invoke] (runtime.js?96cf:296)
    at Generator.prototype.<computed> [as next] (runtime.js?96cf:114)
    at asyncGeneratorStep (asyncToGenerator.js?1da1:3)
    at _next (asyncToGenerator.js?1da1:25)
```

`./store/password.ts`を削除すると、この実行時エラーは出なくなる。

# 原因

Nuxt.jsのプロジェクトで`@/store/`配下にモジュールを作ると、それはストアになる。

- [ストア - NuxtJS](*https://ja.nuxtjs.org/docs/2.x/directory-structure/store/)

通常のモジュールは、`@/store`配下でない、他のパスに作成すること。

# 余談

以下、だらだらとした余談。

今回、私は`@/store/index`（トップレベルのstore）のstateの部分集合になるモジュールを作りたかった。
それにより、当問題に当たった。

より具体的に言えば「パスワードをCookieに保存するCookieから読み込む・削除する」という関数を、`@/store/index`からモジュール分割したかった。

それらはセキュリティのため、ある暗号化アルゴリズムx・自然数n,mを使ってこねこねしたため、わりと行数がある。
なのでモジュール分割が推奨された。

結局これらは`@/data/Password`に移動された。
もともとこれらの関数は、この独自型である`Password`型（`string`のnewtype）に関するものだった。

「`Password`はCookieに関する性質を持つ」という解釈があれば、`@/data/Password`に移動しても妥当っぽそう。

おわり。
