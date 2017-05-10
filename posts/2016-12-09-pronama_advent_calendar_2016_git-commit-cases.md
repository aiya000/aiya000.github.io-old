---
title: gitでcommitを1つに統合すべき場合 及び 1つのcommitを分解すべき場合 - プロ生アドベントカレンダー2016 - 9日目
tags: git, AdventCalendar
---
　なんか勢いでブログ記事を書いたところ、丁度今日のプロ生アドベントカレンダーが空いてたので登録する。  
本記事は[Qiita版プロ生アドベントカレンダー](http://qiita.com/advent-calendar/2016/pronama-chan) 9日目の記事です。  
昨日の記事は[Unityからマウスカーソルを操作する](http://qiita.com/kirurobo/items/fb6b39a6097338f02eb4)でした :D  
えっ、なにこれ、プロ生ちゃんがこっちのマウスカーソルを制御してるの？ すごい。


# 宣伝
[マスコットアプリ文化祭2016](https://mascot-apps-contest.azurewebsites.net/2016/About)では

![僕の作品の画像](/images/posts/2016-12-09-pronama_advent_calendar_2016_git-commit-cases/my.png)

こういうものを登録しました :D  
某所でこれでLTしたりもした。

- - -

　ちょうど1つのcommitを分解したい事案が出てきたので、備考録として残しておく。  
つまりこの記事は、僕の考えに基づいたものであり、公的に正しいとは限らない。  
ただし僕は正しいと思うよ！！


# About
　この記事では、1つの事柄をn個のcommitに分けてしまった場合、  
n個の事柄を1つのcommitに混ぜてしまった場合を仮定する。

commitの統合及び分解の具体的手法については以下。

- [今日のgit-tips (簡単で便利なrebaseによるcommit編集)](https://$host$/posts/2016-07-19-todays_git_tips.html)
- [gitでコミットを分解する](http://www.cocoalife.net/2010/11/post_857.html)
    - これをやった後に`git add -p`でよしなにするといい


# commitを1つに統合すべき場合
　例えば以下のcommitがあるとする。

```git-log
commit aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
Author: aiya000 <aiya000.develop@gmail.com>
Date:   Fri Dec 9 02:40:45 1016 +0900

    Change expected behavior of registerPlace in Foo.hs

commit bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
Author: aiya000 <aiya000.develop@gmail.com>
Date:   Fri Dec 9 02:40:28 1016 +0900

    Use foo-library instead of bar-library in Foo.hs

    Modify some functions in Foo.hs

commit cccccccccccccccccccccccccccccccccccccccc
Author: aiya000 <aiya000.develop@gmail.com>
Date:   Wed Dec 7 23:54:26 1016 +0900

    Refactor Foo.hs
```

これはFoo.hs内に限った2つの事柄であるので

- Foo.hsへの機能修正
- Foo.hsのリファクタリング

こうすべきだと思う。

```git-log
commit dddddddddddddddddddddddddddddddddddddddd
Author: aiya000 <aiya000.develop@gmail.com>
Date:   Fri Dec 9 03:00:00 2016 +0900
    Change expected behavior of registerPlace in Foo.hs

    Use foo-library instead of bar-library in Foo.hs

commit cccccccccccccccccccccccccccccccccccccccc
Author: aiya000 <aiya000.develop@gmail.com>
Date:   Wed Dec 7 23:54:26 2016 +0900

    Refactor Foo.hs
```


# 1つのcommitを分解すべき場合

```git-log
commit xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Author: aiya000 <aiya000.develop@gmail.com>
Date:   Fri Dec 9 02:40:45 1017 +0900
    Update Foo.hs and Hoge.hs

    Change expected behavior of registerPlace
        in Foo.hs

    Use foo-library instead of bar-library
        in Foo.hs, Hoge.hs
```

これは2つの事柄であるので

- 広域な変更（使用するライブラリの変更）
- Foo.hsに限る変更

2つのcommitに分割すべきである。

```git-log
commit yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
Author: aiya000 <aiya000.develop@gmail.com>
Date:   Fri Dec 9 03:01:00 1017 +0900
    Change expected behavior of registerPlace in Foo.hs

commit yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
Author: aiya000 <aiya000.develop@gmail.com>
Date:   Fri Dec 9 03:00:00 1017 +0900
    Use foo-library instead of bar-library

    in Foo.hs, Hoge.hs
```


# 注釈
　本記事に登場したcommitは、いかなる実在のcommitとは関係がありません。  
全員18歳以上です。 ご了承ください。 (？？？)
