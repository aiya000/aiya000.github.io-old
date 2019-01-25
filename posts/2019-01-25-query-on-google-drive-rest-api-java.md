---
title: Google Drive REST API Javaで検索条件を指定する
tags: Java, Kotlin
---

[Java Quickstart - Drive REST API - Google Developers](https://developers.google.com/drive/api/v3/quickstart/java)と
[Overview (Drive API v3 (Rev. 136) 1.25.0)](https://developers.google.com/resources/api-libraries/documentation/drive/v3/java/latest/overview-summary.html)に、
[/drive/v3/files](https://developers.google.com/drive/api/v3/reference/files/list)での検索条件指定の方法が書かれていない気がするので、
迷ってしまいましたので、メモをしておきます。

結論ですが、`Drive.Files.List#setQ(String)`を使います :green_salad:

- [Drive.Files.List (Drive API v3 (Rev. 136) 1.25.0)](https://developers.google.com/resources/api-libraries/documentation/drive/v3/java/latest/com/google/api/services/drive/Drive.Files.List.html#setQ-java.lang.String-)

```kotlin
val service: Drive = ... // この取得方法はJava Quickstartのコード例を参照してください
val filesUnderFoo: List<File> = service.files().list()
    .setQ("'${foo.id}' in parents")
    .execute().files
```

やったー！

/drive/v3/filesの`q`パラメーターの構文については[Search for Files and Team Drives - Drive REST API - Google Developers](https://developers.google.com/drive/api/v3/search-parameters)を参照してください :dog2:
