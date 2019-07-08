---
title: NativeScriptの型不安全なObservableを型安全にする
tags: TypeScript
---
## 結

- [Typgin NativeScript's untyped Observable - GitHub](https://gist.github.com/aiya000/5f12ca0276eabaf6bf1331ee2cd96fae)

## 起

- [Observable - NativeScript Docs](https://docs.nativescript.org/ns-framework-modules/observable)
- [Observable | NativeScript](https://docs.nativescript.org/api-reference/classes/_data_observable_.observable)

　NativeScriptのObservableは、プロパティへの代入（っぽいメソッド）から、処理をフックすることができるクラスです。
MVVMパターンとかに使えます。
（って公式が言ってた。）

　しかしこのObservableにはやばい欠陥があって、上記リンクを見てもらえればわかるのですが、代入と取得（に対応するメソッド）の型が忘却されちゃってます。

```typescript
export class Observable {
  // ...

  //                 vvv
  get(name: string): any

  //                       vvv
  set(name: string, value: any): void

  // ...
}
```

　え、`any`……？　あっ、あたなは最低です！　静的型付けをなんだと思っているのですか！

## 結

　TypeScriptの型付けはめっちゃ考えられているので、型引数で情報を渡してあげるだけで、それに対する安全な`get/set`の型を導出してあげられます。
ただし`super`の最低な`get/set`をなかったことにはできないので、deprecatedにしておいて、新しく`assign/take`というのを定義してあげることにします。
（この`deprecated-decorator`は、そのメソッドが**実行時に**使用された際に、メッセージをコンソールに出力するものなので、**静的**なものではないようです。注意。）

ヘルパー型さん [^field-contravariants]
```typescript
/**
 * Declare a type T of a property K via K of a type X.
 *
 * - Field<{foo: number, bar: string}, 'foo', number> = 'foo'
 * - Field<{foo: number, bar: string}, 'bar', string> = 'bar'
 * - Field<{foo: number, bar: string}, 'foo', string> = never
 */
type Field<X, K extends string, T> = K extends keyof X
  ? T extends X[K] ? K : never
  : never
```

冒涜的でないObservable [^take-null-possibility]
```typescript
/**
 * Don't dirty your hands.
 * You must use this instead of [[Untyped.Observable]].
 */
export default class Observable<X extends object> extends Untyped.Observable {
  constructor() {
    super()
  }

  /**
   * A typed safety set()
   */
  public assign<K extends string, T>(name: Field<X, K, T>, value: T): void {
    super.set(name, value)
  }

  @deprecated('assign')
  public set(name: string, value: any): void {
    super.set(name, value)
  }

  /**
   * A type safety get()
   */
  public take<K extends string, T>(key: Field<X, K, T>): T | undefined {
    return super.get(key)
  }

  @deprecated('take')
  public get(name: string): any {
    super.get(name)
  }
}
```

チェックしてみる。
```typescript
const p = new Observable<{ x: number, y: string }>()
p.assign('x', 10)
p.assign('y', 'poi')
// 2345: Argument of type '"y"' is not assignable to parameter of type 'never'.
// p.assign('y', 10)

const x: number = p.take('x')
const y: string = p.take('y')

// 2345: Argument of type '"y"' is not assignable to parameter of type 'never'.
// const e: number = p.take('y')
```

OK!!!

　コード全文はこちら :point_down:

- [Typgin NativeScript's untyped Observable - GitHub](https://gist.github.com/aiya000/5f12ca0276eabaf6bf1331ee2cd96fae)

　TypeScriptのconditional typesは初めてだったので、いい~~型慣らし~~肩慣らしになったと思います。
TypeScriptに型を付けてもらうのではなく、TypeScriptで型を付けにいく側にまわった気分はどうだ？

　See you next time :wave:

[^field-contravariants]: ここで`T extends X[K]`なのは、`const z = new Observable<{x: {xx: number}}>(); z.assign('x', {})`を許さないためです。
[^take-null-possibility]: ここで`take`の戻り値がnullableなのは、`const z = new Observable<{x: number}>; z.take('x')`としたときにnullを返すためです。（Observableは必ずしも初期化を強制しない。）
