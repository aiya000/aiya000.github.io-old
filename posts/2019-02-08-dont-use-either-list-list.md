---
title: List&ltEither&ltE, A&gt&gtからEither&ltList&ltE&gt, List&ltA&gt&gtを取らない
tags: Haskell, Kotlin
---

`List<Either<E, A>>`から「全てのleft値 or 全てのright値」を取るときは、左に`NonEmptyList<E>`をかけること。

# 結論

`Either<List<E>, List<A>>`ではなく`Either<NonEmptyList<E>, List<A>>`を使いましょう！

```kotlin
import arrow.core.Either
import arrow.core.left
import arrow.core.right
import arrow.data.NonEmptyList

/**
 * leftが1つでもあれば全てのleftを。
 * そうでなければ全てのrightを返します。
 *
 * ```
 * >>> val xs = listOf<Either<Unit, Unit>>()
 * >>> xs.collect()
 * Right(b=[])
 * ```
 */
fun <E, T> List<Either<E, T>>.collect(): Either<NonEmptyList<E>, List<T>> {
    val (lefts, rights) = this.partition { it is Either.Left }
    return when (val head = lefts.getOrNull(0)) {
        null -> rights.map(::unsafeRight).right()
        else -> NonEmptyList(head, lefts.drop(1).map(::unsafeLeft)).left()
    }
}

private fun <E, T> unsafeLeft(self: Either<E, T>): E = (self as Either.Left).a
private fun <E, T> unsafeRight(self: Either<E, T>): T = (self as Either.Right).b
```

# 対象言語

`Either<E, A>`と`List<T>`がある言語全般。

以下Kotlinでは、kotlinに基本的・応用的な代数的データ型を提供してくれるライブラリ[arrow](https://arrow-kt.io/)を用います。

（僕の推しライブラリなので、見てみてください！ まだドキュメントが充実していない気はしますが、着々と進んでいるようです。）

# 概要

`List<Either<E, A>>`の値がときに
「left値1つでもがあれば全てのleft値を。そうでなければ全てのright値を返す」
という関数が欲しいことがしばしばあるかと思います。

これを素直に表すと

```kotlin
/**
 * leftが1つでもあれば全てのleftを。
 * そうでなければ全てのrightを返します。
 *
 * ```
 * >>> val xs = listOf<Either<Unit, Unit>>()
 * >>> xs.collect()
 * Right(b=[])
 * ```
 */
fun <E, T> List<Either<E, T>>.collect(): Either<List<E>, List<T>>
```

のようになるかと思います。

しかしこれは型の上で見ると、空リストを渡したときに`Left(listOf())`が返ってくる可能性も見えてしまいます。

（ドキュメント化はしてありますが……。）

ですのでこのような場合は`NonEmptyList<E>`をかけることで、曖昧さがなくなります！
