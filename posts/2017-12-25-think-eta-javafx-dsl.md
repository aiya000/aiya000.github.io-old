---
title: Haskell (Eta) でJavaFXのEDSLを作る雰囲気を醸し出す
tags: Haskell, Eta, ポエム, AdventCalendar2017, AdventCalendar
---
　この記事は[プロ生ちゃん Advent Calendar 2017 - Adventar](https://adventar.org/calendars/2546)
の :santa: 25日目 :santa: の記事です！ :tada:

:calendar: 皆さん、アドベントカレンダーお疲れ様でした！ :calendar:


# 諸注意
　この事はおおよそ冗談で構成されており、
主に以下の主張を**雰囲気で**感じて貰うことを目的にしています。

- Haskellでは、こんなにも簡単にEDSLを作れる
- EtaとJavaFXを使って、HaskellでもマルチOS対応のGUIプログラミングができる

何を言っているのかわからなくとも、Haskellを知らなくとも、
気にせずに雰囲気で読んで、楽しんでください :sunglasses:

そう、雰囲気が大事なんですよ :kissing:


# 導入
　Etaという、JVMで動くHaskellが登場しました。

- [The Eta Programming Language](http://eta-lang.org/)
- [GitHub - typelead/eta: The Eta Programming Language, a dialect of Haskell on the JVM](https://github.com/typelead/eta)

JVMで動くということはもちろんJavaFXを使えるということなので、
Haskellの1つの懸念事項である「HaskellでGUIアプリって作りやすいの？」問題についての回答が
ついに成されました。

……
と、思われましたが……

```haskell
type LicensePane = FlowPane

-- Paneの生成
newLicensePane :: Java a LicensePane
newLicensePane = do
  doromochi       <- newLabel "ドロもち"
  imageAuthor     <- newLabel "The copyright of images in this  is owned by @HassakuTb on （ず・ω・きょ）"
  imageLink       <- newHyperlinkWithOpening "https://github.com/aiya000/eta-doromochi/blob/master/images"
  hassakuLink     <- newHyperlinkWithOpening "https://twitter.com/HassakuTb"
  zunkyoLink      <- newHyperlinkWithOpening "https://zunko.jp/guideline.html"
  bar             <- newLabel "- - -"
  aboutLicense    <- newLabel "This software includes the work that is distributed in the Apache License 2.0."
  bar'            <- newLabel "- - -"
  thisAppDepends  <- newLabel "This software depends below softwares"
  etaExamples     <- newLabel "typelead/eta-examples"
  etaExamplesLink <- newHyperlinkWithOpening "https://github.com/typelead/eta-examples"
  self            <- newFlowPane
  self <.> setOrientation verticalOrient
  let nodes = [ superCast doromochi
              , superCast imageAuthor
              , superCast imageLink
              , superCast hassakuLink
              , superCast zunkyoLink
              , superCast bar
              , superCast aboutLicense
              , superCast bar'
              , superCast thisAppDepends
              , superCast etaExamples
              , superCast etaExamplesLink
              ]
  forM_ (nodes :: [Node]) $ \node ->
    self <.> getChildren >- addChild node
  return self
```

普通に書きにくいな！？

いえいえ、これは見ての通り、JavaFX8のfxmlを使っていないコードです。

JavaFXではFXMLLoaderという優秀なクラスがあるので、それを使うだけでもっと綺麗に、
簡単に書けるはずです。

```haskell
-- Appのスタート
start :: Stage -> Java DoromochiApp ()
start stage = do
  stage <.> setTitle "ドロもち"
  configDir <- getAppConfigDir
  fxml      <- newFile (configDir ++ "/fxml/DoromochiApp.fxml") >- toURI >- toURL
  root      <- fXMLLoad fxml
  remakeView stage (root :: BorderPane)
  scene     <- newScene root 512 512
  stage <.> do
    setTitle "ドロもち"
    setScene scene
    showStage
  where
    -- @FXMLが使えない気がするので、FXMLLoader.loadで得たPane値を掘っていく
    remakeView :: Stage -> BorderPane -> Java a ()
    remakeView stage pane = do
      menuBar <- unsafeCast <$> pane <.> getTop
      libraryMenu <- (!! 0) . fromJava . superList <$> menuBar <.> getMenus
      licenseItem <- (!! 0) . fromJava . superList <$> libraryMenu <.> getMenuItems
      licenseItem <.> setOnMenuItemAction (intentToLicenseApp stage)
      return ()

    superList :: ObservableList a -> List a
    superList = superCast

    intentToLicenseApp :: Stage -> ActionEvent -> Java (EventHandler ActionEvent) ()
    intentToLicenseApp stage = \_ -> do
      root        <- newGroup
      licensePane <- newLicensePane
      root <.> getChildren >- addChild licensePane
      scene       <-  newSceneWithoutSize root
      stage <.> setScene scene
```

もっと書きにくいな！？

そして実行時エラー多いな！？
（本来のHaskellは、実行以前に実行時エラーをより多く除去できる特徴があることで、良く知られています）

- 出典
    - [GitHub - aiya000/eta-doromochi: An Eta experience](https://github.com/aiya000/eta-doromochi)


# Etaはまだまだ進化中なんです
　この問題提起は、被験者（？）である僕の主観に頼り切っていますが
（例えばもっと模索に力を入れれば、@FXMLなどを使用する方法があるかもしれない）、
しかしながら確かな問題点でもあると考えています。


# .fxmlに変わるDSLを考えよう
　ここで僕はその対処として、Eta上で使えるHaskellのEDSLを考えようと思いました。

　なぜEDSLか？  
EDSL以外の方法として、僕は3つ思いつきました。

1. @FXMLなどを使用可能か、深く調べてみる
2. .fxmlをHaskellのデータ型にパースするパーサを書く
3. .fxmlに変わる外部DSLとそのパーサを書く

なぜそれを行わないかですが

1. 作る方向でいきたい
2. めっちゃ良さそうだけど、時間がかかる
3. めっちゃ良さそうだけど、構文設計分もっと、時間がかかる

という考えです。

だってHaskellの柔軟性知ってるか？  
`State`だけでぜってー書ける。

　そこでこの記事では、そのEDSLの利用側コードを構想してみるところまでを記します。

（EDSLのためのライブラリの実装までは書かない）


# EDSLの概要を決める
　このようなEDSLには、Hakyllという完全な先駆者がいます。  
HakyllのEDSLを見てみましょう。

- [Hakyll - Home](https://jaspervdj.be/hakyll/)
- [GitHub - jaspervdj/hakyll: A static website compiler library in Haskell](https://github.com/jaspervdj/hakyll)

これは僕のブログで今まさに動いているコード（の一部）です。

```haskell
main :: IO ()
main = hakyll $ do
  match "images/**" $ do
    route idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match "js/*" $ do
    route idRoute
    compile copyFileCompiler

  match "about.md" $ do
    route $ setExtension "html"
    compile $ modernPandocCompiler
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "posts/*" $ do
    route $ setExtension "html"
    compile $ modernPandocCompiler
      >>= loadAndApplyTemplate "templates/post.html" postCtx
      >>= loadAndApplyTemplate "templates/default.html" postCtx
      >>= relativizeUrls

  match "templates/*" $ do
    compile templateCompiler
```

うん、最高ですね。

`do`はHaskellが提供する`Monad`への特殊な構文です。
これはEDSLに非常に使いやすいことで知られています。
（事実、通常のHaskellプログラミングにおいては、手続き型プログラミングのDSLとして機能する）

今回のこのDSL（`hakyll`関数に渡されている`do`ブロック）は`Rules`モナドです。
`Rules`モナドの定義を見てみましょう。

```haskell
-- | The monad used to compose rules
newtype Rules a = Rules
    { unRules :: RWST RulesRead RuleSet RulesState IO a
    } deriving (Monad, Functor, Applicative)
```

とてもわかりやすいですね。

　やはりこれから作るEDSLにも`do`は有用そうです。
なのでこれから作るEDSLの型も、
`do`を使うために`Monad`型として定義したいです。


# EDSLの構文を決める
　今回は、この.fxmlをちょうど置き換えるような構文式を考えてみます。

```xml
<BorderPane>
  <top>
    <MenuBar>
      <menus>
        <Menu text="Library">
          <items>
            <MenuItem text="License"/>
          </items>
        </Menu>
      </menus>
    </MenuBar>
  </top>
  <center>
    <ImageView fitHeight="512" fitWidth="512">
      <image>
        <Image url="/home/aiya000/zunko.png"/>
      </image>
    </ImageView>
  </center>
</BorderPane>
```

`hakyll`関数に習って`runBetaFX`関数に`do`式を適用するような形にしてみます。
ところで今EDSLの名前を思いついたのですが、`BetaFX`です。

```haskell
aPane = runBetaFX $ do
    BorderPane.top $ do
        MenuBar.menus
          [do
            Menu.text "Library"
            Menu.items
              [do
                MenuItems.text "License"
              ]
          ]
    BorderPane.center $ do
        ImageView.fitHeight 512
        ImageView.fitWidth 512
        ImageView.image $ do
          Image.url "/home/aiya000/zunko.png"
```

うん、十分実用的そうです、いけそう。

　ところでいくつかの関数の名前がバッティングしています。

ここは[OverloadedLabels](https://ghc.haskell.org/trac/ghc/wiki/Records/OverloadedRecordFields/OverloadedLabels)
の出番かもしれませんが、~~まだ良くわかってないしここで時間をとってもしょうがないので~~とりあえず今は名前空間をレイヤー分けします。

```haskell
import BetaFX (runBetaFX, _borderPane, _menuBar, _menu, _menuItems, _imageView, _image)
import qualified BetaFX.BorderPane as BorderPane
import qualified BetaFX.MenuBar as MenuBar
import qualified BetaFX.Menu as Menu
import qualified BetaFX.MenuItems as MenuItems
import qualified BetaFX.ImageView as ImageView
import qualified BetaFX.Image as Image

aPane = runBetaFX $ do
    BorderPane.top $ do
        MenuBar.menus
          [do
            Menu.text "Library"
            Menu.items
              [do
                MenuItems.text "License"
              ]
          ]
    BorderPane.center $ do
        ImageView.fitHeight 512
        ImageView.fitWidth 512
        ImageView.image $ do
          Image.url "/home/aiya000/zunko.png"
```


# EDSLの型を決める
　構文は決まったので、あとは型です。
何もかも、型が全てだ。

明らかにこれは、値コンストラクタに対して一部のフィールドのみを適用しているように見えます。
例えばここ

```haskell
_menu $ do
  Menu.text "Library"
  Menu.items $ do
    _menuItems $ MenuItems.text "License"
```

は

```haskell
Menu { text = "Library"
     , items = [ MenuItems { text = "License" }
               ]
     }
```

こう見えます。

しかしMenuのフィールド（レコード）にはtextとitems以外にonHiddenやonShowingなどが存在するので、
実際はそのようなそれはできません。

- [Menu (JavaFX 8)](https://docs.oracle.com/javase/jp/8/javafx/api/javafx/scene/control/Menu.html)

その形でやるならこうでしょうか。

```haskell
Menu { text = "Library"
     , items = [ MenuItems { text             = "License"
                           , accelerator      = KeyConbination.noMatch
                           , disable          = False
                           , graphic          = ...
                           , id               = ""
                           , mnemonicParsing  = True
                           , onAction         = \_ -> return ()
                           , onMenuValidation = \_ -> return ()
                           , parentMenu       = ...
                           , parentPopup      = ...
                           , style            = ...
                           , text             = ...
                           , visible          = ...
                           }
               ]
     , onHidden  = \_ -> return ()
     , onHiding  = \_ -> return ()
     , onShowing = \_ -> return ()
     , onShown   = \_ -> return ()
     , showing   = False
     }
```

　今まさに設定したいフィールドであるtextとitems以外は隠蔽したいですよね。
そう、こんな感じに。

```haskell
MenuBar.menus
  [do
    Menu.text "Library"
    Menu.items
      [do
        MenuItems.text "License"
      ]
  ]
```

ということで各フィールドを、状態変更を行う関数として定義するのが早いと思います。

```haskell
type BetaFX s a = State s a

MenuItems.text :: String -> BetaFX MenuItems ()

Menu.text :: String -> BetaFX Menu ()
Menu.items :: [BetaFX MenuItems ()] -> BetaFX Menu ()

MenuBar.menus :: [BetaFX Menu ()] -> BetaFX MenuBar ()

MenuBar.menus
  ([do
    Menu.text "Library"
    Menu.items
      [do
        MenuItems.text "License"
      ]
  ] :: [BetaFX Menu ()])
```

ここで`Menu.items`が各`BetaFX MenuItems ()`に対して
`MenuItems`の初期値と共に`execState :: BetaFX s a -> s`してあげればいけそうです。
（`MenuBar.menus`も同じように）

型付けが正しいことを確認してみます。

```haskell
MenuBar.menus
  ([do
    (Menu.text "Library" :: BetaFX Menu)
    (Menu.items [MenuItems.text "License" :: BetaFX MenuItems ()]
        :: BetaFX Menu ())
  ] :: [BetaFX Menu ()])
:: BetaFX MenuBar ()
```

出来てそうなので、`aPane`全体を型付けしてみます。

```haskell
do
    BorderPane.top $ do
        MenuBar.menus
          [do
            Menu.text "Library"
            Menu.items
              [do
                MenuItems.text "License"
              ]
          ]
    BorderPane.center $ do
        ImageView.fitHeight 512
        ImageView.fitWidth 512
        ImageView.image $ do
          Image.url "/home/aiya000/zunko.png"
:: BetaFX BorderPane ()

runBetaFX :: BetaFX s () -> s

aPane :: BorderPane
aPane = runBetaFX $ do
    BorderPane.top $ do
        MenuBar.menus
          [do
            Menu.text "Library"
            Menu.items
              [do
                MenuItems.text "License"
              ]
          ]
    BorderPane.center $ do
        ImageView.fitHeight 512
        ImageView.fitWidth 512
        ImageView.image $ do
          Image.url "/home/aiya000/zunko.png"
```

`runBetaFX`は明らかに`execState`ですね。

でもせっかくなのでnewtypeして、
このBetaFXは 'Eta + JavaFX' のEDSLのみに使われることを明示してみます。

```haskell
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.State.Lazy (StateT, get, put, runStateT)

newtype BetaFX s a = BetaFX
  { unBetaFX :: State s a
  } deriving (Functor, Applicative, Monad, MonadState)

runBetaFX :: BetaFX s () -> s
runBetaFX = execState . unBetaFX
```

<p class='don'>できた！！！</p>


# おまけ
　せっかくEDSLですし、ここ

```haskell
Image.url "/home/aiya000/zunko.png"
```

は環境固有の絶対パスのままではなく、
`~/zunko.png`あたりにしたいですよね。

じゃあIOを合成しちゃいますかね。

```haskell
import System.Environment (getEnv)

newtype BetaFX s a = BetaFX
  { unBetaFX :: StateT s IO a
  } deriving (Functor, Applicative, Monad, MonadState, MonadIO)

ImageView.image $ do
  homeDir <- liftIO $ getEnv "HOME"
  Image.url $ homeDir ++ "/zunko.png"
```

<p class='don'>できた！！</p>

純粋性を保ちたい場合は`IO`の代わりに`Reader`を使って、
外部から注入してあげるといいと思います！
