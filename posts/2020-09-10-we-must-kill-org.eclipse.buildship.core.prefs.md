---
title: Spring Tool Suite 4でorg.eclipse.buildship.core.prefsのせいでJAVA_HOMEが設定できなかった
tags: Java
---

<div class="wrap-fluid">
![](/images/posts/2020-09-10-we-must-kill-org.eclipse.buildship.core.prefs/to-build.png)
</div>

<div class="wrap-fluid">
![](/images/posts/2020-09-10-we-must-kill-org.eclipse.buildship.core.prefs/compile-error.png)
</div>

<div class="wrap-fluid">
![](/images/posts/2020-09-10-we-must-kill-org.eclipse.buildship.core.prefs/compile-error-detail.png)
</div>

```
Java Home: /Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home
```

```
> Could not target platform: 'Java SE 11' using tool chain: 'JDK 8 (1.8)'.
```

:anger::anger::rage::anger::anger:　:exclamation::question::question:

- - - - -

<div class="wrap-fluid">
![](/images/posts/2020-09-10-we-must-kill-org.eclipse.buildship.core.prefs/installed-JREs.png)
</div>

- `Spring Tool Suite 4 > Preferences`

:weary::x:

- - - - -

<div class="wrap-fluid">
![](/images/posts/2020-09-10-we-must-kill-org.eclipse.buildship.core.prefs/debug-config.png)
</div>

- `プロジェクト名を右クリック > Debug As > Debug Configurations...`
- `Spring Boot App > プロジェクト名`
- `JRE > Project execution environment`

:cry::x:

- - - - -

<div class="wrap-fluid">
![](/images/posts/2020-09-10-we-must-kill-org.eclipse.buildship.core.prefs/environment-variables-to-set.png)
</div>

- `同 > Environment > Environment variables to set`
- `JAVA_HOME`

:x::x::rage::x::x:

- - - - -

🤔 oO(……）

```shell-session
$ cd プロジェクト
$ ls -a
.   .git     .mvn       ...
..  .gradle  .settings  ...
```

`.settings` :point_left: :question:

```shell-session
$ cat .settings/org.eclipse.buildship.core.prefs

...

java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home

...
```

:frowning::exclamation:

```
java.home=/Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home
```

↓

```
java.home=/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home
```

:unamused: ……

again

<div class="wrap-fluid">
![](/images/posts/2020-09-10-we-must-kill-org.eclipse.buildship.core.prefs/to-build.png)
</div>

……！

<div class="wrap-fluid">
![](/images/posts/2020-09-10-we-must-kill-org.eclipse.buildship.core.prefs/success.png)
</div>

```
Working Directory: /Users/xxxxxx/Repository/rem-server
Gradle user home: /Users/xxxxxx/.gradle

...

Java Home: /Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home

...

BUILD SUCCESSFUL in 13s
5 actionable tasks: 1 executed, 4 up-to-date
```

:ok_hand::sparkles:

……

:fire::fire: :grimacing::grimacing::grimacing::grimacing::grimacing: :fire::fire:

- - - - -

:raised_hands:
