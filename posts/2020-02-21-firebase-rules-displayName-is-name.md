---
title: Firebase AuthenticationユーザーのdisplayNameは、Firestore rules上ではnameとして定義される
tags: Firebase, TypeScript, JavaScript
---

Firebase Authenticationユーザーを、次のように登録したとします。

```typescript
import * as Firebase from 'firebase'

const auth = Firebase.auth()
const email = someEmail
const password = somePassword

try {
  const credential = await auth.createUserWithEmailAndPassword(email, password)
  const user = credential.user
  if (user === null) {
    throw new Error(
      `creating user for authentication was success, but nobody is logging in. something wrong! credential: ${credential}`
    )
  }

  await user.updateProfile({ displayName: 'Haskell' })  // !
  await user.sendEmailVerification()
} catch (e) {
  if (e instanceof Error && /The email address is already in use by another account./.test(e.message)) {
    throw new Error(`メールアドレス「${account.email}」は既に使用されています。`)
  }
  throw new Error(e)
}
```

また、次のようにFirestoreコレクションへ、ドキュメントを追加したとします。

```typescript
const ref = await Firebase.firestore()
  .collection('accounts')
  .doc('Haskell')  // !
const doc = await ref.get()

if (doc.exists) {
  throw new Error(`アカウント名「${account.name}」は既に使用されています。`)
}

ref.set(account)
```

この際、下記コードにより`ref.get()`できるようにするには

```typescript
const ref = await Firebase.firestore()
  .collection('accounts')
  .doc('Haskell')  // !
const doc = ref.get()
```

Firestore rulesへの下記設定が必要です。

```javascript
rules_version = '2';

service cloud.firestore {
    match /databases/{database}/documents {
        match /accounts/{account} {
            allow create;
            allow read: if account == request.auth.token.name;
            // 誤り ↓
            // allow read: if account == request.auth.token.displayName;
        }
    }
}
```

この仕様、どこに書いてあります……？？？
