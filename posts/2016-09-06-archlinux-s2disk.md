---
title: いい加減ArchLinuxでのhibernate環境の構築についてメモっとく
tags: Linux
---
　以前kernelバックエンドを使わないsuspend on disk(hibernate, s2disk)の環境を作った時も
(面白いけど)苦労したのにメモってなかったのでまた(面白いけど)苦労した。  
ので作業を思い出して、メモしておく。

+ 参考ページ
    - [pm-utils - ArchWiki](https://wiki.archlinuxjp.org/index.php/Pm-utils)
    - [Uswsusp - ArchWiki](https://wiki.archlinuxjp.org/index.php/Uswsusp)


# 構成
　構成は`uswsusp + pm-utils`にする。  
uswsuspはユーザースペースでのsuspendを可能にするツールで、pm-utilsはそのフロントエンドになる。

　スワップメモリにはパーティションではなくスワップファイルを使う。  
(スワップファイルは/root/swapに置いた)

- [スワップ - ArchWiki](https://wiki.archlinuxjp.org/index.php/%E3%82%B9%E3%83%AF%E3%83%83%E3%83%97#.E3.82.B9.E3.83.AF.E3.83.83.E3.83.97.E3.83.95.E3.82.A1.E3.82.A4.E3.83.AB.E3.81.AE.E4.BD.9C.E6.88.90)


# インストール

```console
$ yaourt -S uswsusp pm-utils
```


# 設定
　uswsuspが動作するように、自分の環境をuswsuspに伝える。 + alpha

/etc/suspend.conf
```conf
snapshot device = /dev/snapshot
# いつもここ間違えるけど、/root/swap自体ではなく/root/swapがあるパーティションを指定する
resume device = /dev/sda3
# swap-offset /root/swapの結果
resume offset = 2326528
# ついでに設定
compress = y
threads = y
```

　pm-utilsがバックエンドにuswsuspを使うようにする。

/etc/pm/config.d/module
```conf
SLEEP_MODULE=uswsusp
```

　次に重要な作業をする。  
ここをミスったところ、僕の環境では起動不可になった。  
[ここ](https://wiki.archlinuxjp.org/index.php/Uswsusp#initramfs_.E3.81.AE.E5.86.8D.E4.BD.9C.E6.88.90)参照。

/etc/mkinitcpio.conf
```conf
.
.
.
HOOKS="base udev autodetect modconf block filesystems keyboard fsck uresume"
.
.
.
```

僕は[カーネルにlinux-ltsを使っているので](http://127.0.0.1:8000/posts/2016-09-06-archlinux-mkinitcpio-if-linux-lts.html)、
-pオプションにはlinux-ltsを指定する。

```console
# mkinitcpio -p linux-lts
```


# 完成
　これでマシンの再起動後に以下のコマンドを打てば、マシンをhibernateすることができる。 はず。

```console
$ sudo pm-hibernate
```
