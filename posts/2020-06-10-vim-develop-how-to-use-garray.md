---
title: 【Vimにコントリビュート】garray_Tの使い方
tags: Vim, C
---

# はじめに

Vimは古典的C言語（多分C99以下の企画）で書かれており、
またライブラリの依存関係を最小に抑えておきたいためでしょうか、
Vimのソースコード内に独自のAPI（`struct`や諸関数）が含まれています。

今回、私はVimへの下記PullRequestを、一年に渡って作成しています。

- [Support 'template string' ('string interpolation') by aiya000 - Pull Request #4634 - vim/vim - GitHub](https://github.com/vim/vim/pull/4634)

（よければPRのトップコメントに :+1: する等で、応援してください！ マージされる可能性が高まります！）

そこで`garray_T`という便利な`struct`を発見したので、解説させていただきます。

※ 筆者はVimコントリビュート初心者です。誤ったことを言っていたら、ごめんなさい。

# `garray_T`の用途・使い方
## 要素が`char_u`な場合

`garray_T`はC++の`std::vector<T>`や、Javaの`ArrayList<T>`、Kotlinの`MutableList<T>`に相当します。
ただしCにジェネリクスはないので、型引数を持つ代わりに、キャストを前提としています。

定義は以下です。

```c
/*
 * Structure used for growing arrays.
 * This is used to store information that only grows, is deleted all at
 * once, and needs to be accessed by index.  See ga_clear() and ga_grow().
 */
typedef struct growarray
{
    int	    ga_len;		    // current number of items used
    int	    ga_maxlen;		    // maximum number of items possible
    int	    ga_itemsize;	    // sizeof(item)
    int	    ga_growsize;	    // number of items to grow each time
    void    *ga_data;		    // pointer to the first item
} garray_T;
```

以下のように使用します。

（以下、コンパイルは未検証です。……Vimのソースコードを持ってくるのは、とっても大変なので :bow:）

```c
// Vimのコーディングスタイルに多分従っているコード
    static void
foo(char_u **xs, size_t xs_size)  // char_uはVim特有の文字型
{
    int         i;
    garray_T    result;  // char_uの可変配列 = 可変文字列
    ga_init2(&result, sizeof(char_u), 80);

    ga_append(&result, '"');
    for (i = 0; i < xs_size - 1; ++i)
    {
        ga_concat(&result, xs[i]);
        ga_append(&result, ',');
    }
    ga_concat(&result, xs[xs_size - 1]);

    printf("%s\n", (char_u *)result.ga_data);

    ga_clear(&result);
}

char_u *xs[3] = {
    (char_u *)"foo",
    (char_u *)"bar",
    (char_u *)"baz"
};
foo(xs, 3);  // "foo,bar,baz"
```

`ga_init2()`は`garray_T`のコンスタントラクターです。
引数にそれぞれ「初期化先、要素のサイズ、メモリアロケートするときの増分」を指定します。

コンスタントラクターとして`ga_init()`を使うこともできます。

```c
/*
 * Initialize a growing array.	Don't forget to set ga_itemsize and
 * ga_growsize!  Or use ga_init2().
 */
    void
ga_init(garray_T *gap)
{
    gap->ga_data = NULL;
    gap->ga_maxlen = 0;
    gap->ga_len = 0;
}

    void
ga_init2(garray_T *gap, int itemsize, int growsize)
{
    ga_init(gap);
    gap->ga_itemsize = itemsize;
    gap->ga_growsize = growsize;
}

```

`ga_append()` と `ga_concat()` は、要素が`char_u`な`garray_T`に特化した関数で、
適宜メモリアロケートしつつ`result.ga_data`にデータ（`char_u`及び`char_u*`）を追加していきます。

これよって、むやみに手動メモリアロケ―としつつ
`sprintf()`するという呪いのようなコードから解放されます。

それこそが、`garray_T`の存在意義でしょう！

最後に`ga_clear()`でアロケートされたメモリを解放（free）してあげます。

## 要素が`char_u`でない場合

`garray_T`は要素が`char_u`でない場合も使用できます。

```c
    static void
to_scalable(int *xs, size_t xs_size, garray_T *result)
{
    int i;

    ga_init2(result, sizeof(int), 80);

    for (i = 0; i < xs_size; ++i)
    {
        ga_grow(result, 1);
        ++result->ga_len;

        ((int *)result)[result->ga_len - 1] = xs[i];
    }
}

int         i;
garray_T    result;
int         xs[3] = { 1, 2, 3 };
to_scalable(xs, 3, &result);

for (i = 0; i < result.ga_len; ++i)
{
    printf("%d\n", ((int *)result.ga_len)[i]);
}
// 1
// 2
// 3

ga_clear(&result);
```

`ga_grow(garray_T *ga, int n)`は`garray_T`がもうn個分の要素を持たない場合に、
`ga_data`を拡張する関数です。

`ga_len`は`garray_T`中の要素数を表し、手動で増分する必要があります。
（多分……。）

# まとめ

- 関数
    - `ga_init()`, `ga_init2()`: コンスタントラクター
    - `ga_append()`, `ga_concat()`: `char_u`が要素の`garray_T`への追加関数
    - `ga_grow()`: 新たな要素を追加したいときの関数
    - `ga_clear()`: 初期化済み`garray_T`を解放（free）する。
- `garray_T`のプロパティ
    - `ga_data`: 全要素の実体
    - `ga_len`: 中の要素数

Enjoy vimming!
