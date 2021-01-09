---
title: Google Cloud Functionsでnode.jsを使う場合、devDependenciesを使うとデプロイが失敗する
tags: node.js, GCP
---
# 結

Google Cloud Functionsのプロジェクトでは`npm install --save-dev`や`yarn add --dev`は使わずに、`npm install`や`yarn add`を使うこと。

もししてしまっても、`package.json`の`devDependencies`を手動で`dependencies`に移せば大丈夫。

# 問題

これになる :point_down:

```shell-session
$ yarn deploy
yarn run v1.22.5
$ firebase deploy --only functions

=== Deploying to 'foo'...

i  deploying functions
Running command: yarn build
$ tsc

...

✔  functions: . folder uploaded successfully
i  functions: updating Node.js 12 function bar(us-central1)...
⚠  functions[bar(us-central1)]: Deployment error.
Function failed on loading user code. This is likely due to a bug in the user code.
Error message: Error: please examine your function logs to see the error cause: https://cloud.google.com/functions/docs/monitoring/logging#viewing_logs.
Additional troubleshooting documentation can be found at https://cloud.google.com/functions/docs/troubleshooting#logging.
Please visit https://cloud.google.com/functions/docs/troubleshooting for in-depth troubleshooting documentation.

...
```

package.jsonの一部

```json
  "devDependencies": {
    "request-promise-native": "^1.0.9"
  },
```

# 解決

長らく悩んで
GCPのログエクスプローラーを見てみると、ちゃんと書いてあった……。

```json
{
  "textPayload": "Did you list all required modules in the package.json dependencies?",
  "insertId": "000000-ad829364-20bb-4471-96d7-51b483614caf",
  "resource": {
    "type": "cloud_function",
    "labels": {
      "project_id": "foo",
      "function_name": "bar",
      "region": "us-central1"
    }
  },
  "timestamp": "2021-01-09T13:54:40.865Z",
  "labels": {
    "execution_id": ""
  },
  "logName": "projects/foo/logs/cloudfunctions.googleapis.com%2Fcloud-functions",
  "receiveTimestamp": "2021-01-09T13:54:42.400107672Z"
}
```

ぴえんでございます！！！！！
