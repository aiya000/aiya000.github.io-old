
# EclipseにEGitを入れる
  
***省略***


***EGitが入りました。***  


# EGitの使い方

## 1. The Project
はい、プロジェクトを作りました。  
![project](/images/posts/2014-09-26-EclipseにEGitを入れる/1.png)  


## 2. The Remote
GithubあたりにGitリモートリポジトリを作ります。  
以下参照。  
[とても便利なサイト](http://google.co.jp/search?q=github+リポジトリ+作り方)  


## 3. The Register
プロジェクトを右クリックはい。  
Team > Share Project  
![share-pro](/images/posts/2014-09-26-EclipseにEGitを入れる/2.png)  

Gitを選択してNext。  
![select-git](/images/posts/2014-09-26-EclipseにEGitを入れる/3.png)  
  
RepositoryにはGitのデータを置くディレクトリを指定。  
適当な場所でいいです、デスクトップ上のディレクトリでもいいです。  
Repositoryを入力すると他が自動入力されます。  
![place-git](/images/posts/2014-09-26-EclipseにEGitを入れる/4.png)  
  
***ローカルリポジトリができました。***  


## 4. The Push
はい、プロジェクトを、はい右クリック。  
![commit-git](/images/posts/2014-09-26-EclipseにEGitを入れる/5.png)  
はい、Team > Commit  
  
メッセージを入力。 "Initilize."  
[Commit]ボタンをおすっ！！  
![commit2-git](/images/posts/2014-09-26-EclipseにEGitを入れる/6.png)  
  
  
ここでGitのリモートリポジトリのクローンURLをURIに入力します。  
[便利](http://google.co.jp/search?q=github+clone+URL)  
  
![uri-git](/images/posts/2014-09-26-EclipseにEGitを入れる/7.png)  
  
Authenticationに自分のGithubアカウント情報を入力。  
Store in Secure Storeへのチェックは…とりあえずしておく。  
>> [Next]  
  
  
Source refにはmasterを選択しておきます。  
![ref-git](/images/posts/2014-09-26-EclipseにEGitを入れる/8.png)  
>> [Finish]!!


## $. The End
できたっ！！  
![end-git](/images/posts/2014-09-26-EclipseにEGitを入れる/9.png)  
  
  
  
***おわり。***  
  
