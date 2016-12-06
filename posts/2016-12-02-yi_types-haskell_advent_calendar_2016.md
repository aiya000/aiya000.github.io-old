---
title: Yiが定義する型の紹介 - Haskell Advent Calendar 2016 - 4日目
tags: AdventCalendar, Haskell
---
　ドーモ、fix関数の簡約が「いい感じにやる」といった理解しかできないあいやです。  
この記事は[Haskell Advent Calendar 2016](http://qiita.com/advent-calendar/2016/haskell) 4日目の記事です。


# 私何もあげられるものないから、yiの型書くよ！

- [stackageに上がっている正式なドキュメントはこちら](https://www.stackage.org/haddock/lts-7.7/yi-0.12.6)

　この記事ではYi型とyiエディタの区別をするために、yiエディタのことは「yi」と呼称します :)

Yiにコントリビュートしつつ解釈したものなので、間違ってたらごめんなさい ;(

instanceの定義は省略します。

## 目次

- [EditorM](#yi-editorm)
- [YiM](#yi-yim)
- [Config](#yi-config)
- [Editor](#yi-editor)
- [Yi](#yi-yi)
- [BufferId](#yi-bufferid)
- [FBuffer](#yi-fbuffer)
- [BufferImpl](#yi-bufferimpl)
- [BufferRef](#yi-bufferref)



## 動作
　yiの動的な影響を及ぼす操作を記述することができます。  
キーバインドに設定される動作にもなったりします。

- EditorM
- YiM

- - -

<a name="yi-editorm"></a>

```haskell
newtype EditorM a = EditorM { fromEditorM :: ReaderT Config (State Editor) a }
    deriving (Monad, Applicative, MonadState Editor, MonadReader Config, Functor, Typeable)
```

　yiの状態と動作を持ちますが、IOは持ちません。  
ReaderTとStateにより、[Config](#yi-config)の読み込みと[Editor](#yi-editor)への変更を行います。  
例えば、現在保持しているバッファの一覧、バッファの追加などを取得したりできます。  
(設定の読み込みと状態の変更)

`withEditor :: MonadEditor m => EditorM a -> m a`関数でYiMに変換できたりします。
          
- - -

<a name="yi-yim"></a>

```haskell
newtype YiM a =  YiM { runYiM :: ReaderT Yi IO a } 
    deriving (Monad, Applicative, MonadReader Yi, MonadBase IO, Typeable, Functor)
```

　yiの状態と動作を持ちますが、IOを含むので何でもできます。 liftBaseすればそのままIOモナドになるので。  
`MonadState Editor`になっていることと[Yi](#yi-yi)が[Config](#yi-config)を持っていることで、
やはりこちらもEditorMと同じことを行えます。  
でもできるだけEditorMを使った方がいい :(


## 状態

- Config
- Editor
- Yi

- - -

<a name="yi-config"></a>

```haskell
data Config = Config
  { startFrontEnd :: UIBoot
  , configUI :: UIConfig
  , startActions :: [Action]
  , initialActions :: [Action]
  , defaultKm :: KeymapSet
  , configInputPreprocess :: P Event Event
  , modeTable :: [AnyMode]
  , debugMode :: Bool
  , configRegionStyle :: RegionStyle
  , configKillringAccumulate :: Bool
  , configCheckExternalChangesObsessively :: Bool
  , bufferUpdateHandler :: [[Update] -> BufferM ()]
  , layoutManagers :: [AnyLayoutManager]
  , configVars :: ConfigState.DynamicState
  }
```
 
　yi上のキーマッピング情報などの、yi起動以前に設定した情報を表します。  
例えば、initialActionsでctagsなどのタグ情報を読み込む方法を設定しておいたりします。

- - -

<a name="yi-editor"></a>

```haskell
data Editor = Editor
  { bufferStack     :: !(NonEmpty BufferRef)
  , buffers         :: !(Map BufferRef FBuffer)
  , refSupply       :: !Int
  , tabs_           :: !(PointedList Tab)
  , dynamic         :: !DynamicState.DynamicState
  , statusLines     :: !Statuses
  , maxStatusHeight :: !Int
  , killring        :: !Killring
  , currentRegex    :: !(Maybe SearchExp)
  , searchDirection :: !Direction
  , pendingEvents   :: ![Event]
  , onCloseActions  :: !(Map BufferRef (EditorM ()))
  } deriving Typeable
```

　動的な状態を保持します。  
UIに実際に表示されているタブやバッファ、検索中の単語(もとい表現)と検索状態などを保持します。

- - -

<a name="yi-yi"></a>

```haskell
data Yi = Yi
  { yiUi          :: UI Editor
  , yiInput       :: [Event] -> IO ()
  , yiOutput      :: IsRefreshNeeded -> [Action] -> IO ()
  , yiConfig      :: Config
  , yiVar         :: MVar YiVar
  } deriving Typeable
```

　動的な状態を保持します。
他の状態用の型とは違って、外界へのアクセスを許されているっぽい。


## バッファ

- BufferId
- FBuffer
- BufferImpl
- BufferRef

- - -

<a name="yi-bufferid"></a>

```haskell
data BufferId = MemBuffer Text
              | FileBuffer FilePath
              deriving (Show, Eq, Ord)
```

あるバッファの種別です。  
[Attributes](#yi-attributes)という形で[FBuffer](#yi-fbuffer)から保持されます。

- - -

<a name="yi-fbuffer"></a>

```haskell
data FBuffer = forall syntax. FBuffer
  { bmode  :: !(Mode syntax)
  , rawbuf :: !(BufferImpl syntax)
  , attributes :: !Attributes
  } deriving Typeable
```

　具体的なバッファの値を指します。  
[BufferImpl](#yi-bufferimpl)とAttributesを統合して保持します。  
[BufferRef](#yi-bufferref)から参照されます。

　これは`Editor`の`buffers`から取得できます。

- - -

<a name="yi-bufferimpl"></a>

```haskell
data BufferImpl syntax = FBufferData
  { mem         :: !YiString
  , marks       :: !Marks
  , markNames   :: !(Map String Mark)
  , hlCache     :: !(HLState syntax)
  , overlays    :: !(Set Overlay)
  , dirtyOffset :: !Point
  } deriving Typeable
```

　バッファ内のテキストやハイライトを値でを保持します。

- - -

<a name="yi-bufferref"></a>
```haskell
newtype BufferRef = BufferRef Int
    deriving (Eq, Ord, Typeable, Binary, Num)
instance Show BufferRef
```

　バッファの参照を持ちます。  
バッファの具体的な内容は持ちません。


# こんな感じで
　yiが出来る。 （雑）
