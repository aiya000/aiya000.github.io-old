---
title: Vimのソース内で自作した関数の結果を確認する
tags: Vim, C
---

## 起

　Vimにコントリビュートしたいけど、
「`char_u*`って？　`typval_T`ってなんじゃい？　`eval1`？　`:h expr1`？」
っていう状態だった。

　とりあえず、自作関数で動作を確認したい。

```c
    static void
mine(void)
{
    static int b = 0;
    if (!b) {
	b = 1;
	char_u* x = vim_strsave((char_u*) "10");
	typval_T y = { VAR_UNKNOWN, 0, {0} };
	eval1(&x, &y, 1);
	printf("\n");  // ここをX行目と仮定する
    }
```

## 結

1. eval.hの`ex_echo`関数をエディタで開く。
1. その上に上記の`mine`関数を定義する。
    - 名前は`mine`でなくてもよい。内容もお好みで。
1. `ex_echo`関数の変数宣言句の下で、`mine`を呼び出す。
    - ```c
      /*
       * ":echo expr1 ..."	print each argument separated with a space, add a
       *			newline at the end.
       * ":echon expr1 ..."	print each argument plain.
       */
          void
      ex_echo(exarg_T *eap)
      {
          char_u	*arg = eap->arg;
          typval_T	rettv;
          char_u	*tofree;
          char_u	*p;
          int		needclr = TRUE;
          int		atstart = TRUE;
          char_u	numbuf[NUMBUFLEN];
          int		did_emsg_before = did_emsg;
          int		called_emsg_before = called_emsg;

          mine();  // ha-ya!

          if (eap->skip)
          ++emsg_skip;
          while (*arg != NUL && *arg != '|' && *arg != '\n' && !got_int)
      ```
1. CLIで`make`。
1. Vimで`:packadd termdebug`, `:execute 'Termdebug' expand('~/path/to/vim/src/vim')`。
1. gdbウィンドウで`b mine`からの`run -u NONE --noplugin`。
1. Vimウィンドウで`:echo 10`。
    - `10`でなくてもよい。なんでもいいから`ex_echo`を呼び出す。
1. gdbウィンドウで`n`して、`mine`のX行目へ進む。
    - X行目については、上記`mine`の定義を参照。
1. gdbウィンドウで結果を確認する。
    - ```
      Breakpoint 1, mine () at eval.c:8897
      8897    {
      (gdb) n
      8899        if (!b) {
      (gdb) 
      8900            b = 1;
      (gdb) 
      8901            char_u* x = vim_strsave((char_u*) "10");
      (gdb) 
      8902            typval_T y = { VAR_UNKNOWN, 0, {0} };
      (gdb) 
      8903            eval1(&x, &y, 1);
      (gdb) 
      8904            printf("\n");
      (gdb) p x
      $1 = (char_u *) 0x5555558cbb52 ""
      (gdb) p y
      $2 = {v_type = VAR_NUMBER, v_lock = 0 '\000', vval = {v_number = 10, v_float = 4.9406564584124654e-323, v_string = 0xa <error: Cannot access memory at address
       0xa>, v_list = 0xa, v_dict = 0xa, v_partial = 0xa, v_job = 0xa, v_channel = 0xa, v_blob = 0xa}}
      (gdb) p y.v_type
      $3 = VAR_NUMBER
      (gdb) p y.vval.v_number
      $4 = 10
      ```

完了！
