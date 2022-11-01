---
title: Nuxt3とMSWで「The script has an unsupported MIME type ('text/html')」が出た
tags: TypeScript, Nuxt, Nuxt3
---
# 結
## 間違い

間違いは`$ msw init src/static --save`（`src/static`）していたことだった。
Nuxt2のプロジェクトのひとつでは`src/static`で成功していたので、油断していた。

```shell-session
The script has an unsupported MIME type ('text/html').
```

今回のプロジェクトではSPAを採用しているので、MSWで定義した`/mock/foo`エンドポイントで404のhtmlが取れてしまって、`text/html`と言われていた。

## 修正

公式ドキュメントの['Where is my "public" directory?'](https://mswjs.io/docs/getting-started/integrate/browser#where-is-my-public-directory)に書いてある通り、Vue.jsでは`./public`に`mockServiceWorker.js`を配置する。

今回のプロジェクトでは`public`ディレクトリが、都合上`./src`の上にあるので、下記コマンドを実行する。

```shell-session
$ npx msw init src/public --save
```

これで正しく`/mock/foo`が叩けるようになった。

## おまけ

またコンポーネントが`/mock/foo`を叩く前に`worker.start()`が完了していて欲しいので、当該Nuxt3プラグインで`await worker.start(...)`してあげると、必ず失敗しなくなります。

```diff
diff --git a/src/plugins/mockServer.ts b/src/plugins/mockServer.ts
index 692bc21..f7fbfcb 100644
--- a/src/plugins/mockServer.ts
+++ b/src/plugins/mockServer.ts
@@ -1,8 +1,8 @@
 import { worker } from '@/mocks/browser'
 
-export default defineNuxtPlugin(async ({ $config }) => {
+export default defineNuxtPlugin(({ $config }) => {
   if ($config.NUXT_ENV_API_PREFIX === '/mock') {
-    await worker.start({
+    worker.start({
       // モックAPIサーバーで定義されたエンドポイント以外にアクセスした場合に、警告しない
       // https://mswjs.io/docs/api/setup-worker/start#onunhandledrequest
       onUnhandledRequest: 'bypass',

```
