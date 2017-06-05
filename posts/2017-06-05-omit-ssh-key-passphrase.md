---
title: Linuxとxfce4でSSH鍵のパスフレーズ入力を永続的に省略する
tags: Linux, git
---
# 想定
　ssh接続先の認証にはパスフレーズではなく鍵認証が設定されていて、その鍵にパスフレーズを設定している。  
ssh接続時にその鍵のパスフレーズを入力することなく接続できるようにする。

xfce4を使用している。


# 結論
　gnome-keyringとseahorseを使用する。  
gnome-keyring
全てはこちらに書いてある。

- [GNOME Keyring - ArchWiki](https://wiki.archlinuxjp.org/index.php/GNOME_Keyring)
- [Xfce - SSH エージェント - ArchWiki](https://wiki.archlinuxjp.org/index.php/Xfce#SSH_.E3.82.A8.E3.83.BC.E3.82.B8.E3.82.A7.E3.83.B3.E3.83.88)


# 手順

```console
$ yaourt -S gnome-keyring libgnome-keyring seahorse
```

xfce4使ってる人は、以下を行う。

- [Xfce - SSH エージェント - ArchWiki](https://wiki.archlinuxjp.org/index.php/Xfce#SSH_.E3.82.A8.E3.83.BC.E3.82.B8.E3.82.A7.E3.83.B3.E3.83.88)

いくつかのディスプレイマネージャを使用していれば、自動でgnome-keyring-deamonを起動してくれるらしい。

そうでないstartxを使う環境など（.xinitrcを介する環境）は.xinitrcにこれを書く。

```sh
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
```

皆さん多分/usr/lib/seahorseは`$PATH`に追加していないと思うので、フルパスでseahorse-ssh-askpassコマンド打つ
```console
$ /usr/lib/seahorse/seahorse-ssh-askpass path/to/ssh_key
```

あとは再起動して、いける。


# 動機
　sshの認証自体のパスフレーズ省略は.netrcを用いればできると思うけど、鍵の省略はできなかったんだよ〜。  
逆に~/.ssh/configだと、`IdentityFile`で鍵の指定はできても、その鍵のパスフレーズは指定できなかったんだ。


# 難しいところ
　これを設定する必要があるのに気づかなかった。

- [Xfce - SSH エージェント - ArchWiki](https://wiki.archlinuxjp.org/index.php/Xfce#SSH_.E3.82.A8.E3.83.BC.E3.82.B8.E3.82.A7.E3.83.B3.E3.83.88)

　.xinitrcをxfce4セッションとして使うようにしてるんだけど、なんで.xinitrcに書いておくんじゃだめだったんだよ？  
.xinitrcに書いておくと`$SSH_AUTH_SOCK`の値が/tmp以下になって、xfce4に上記設定をすると/run以下になるのは調べた。  
うんこうんこちんこ。
