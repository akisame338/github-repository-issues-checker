# github-repository-issues-checker

Githubにある特定リポジトリのIssuesを確認する。

## インストール方法

```console
$ git clone https://github.com/akisame338/github-repository-issues-checker.git
$ cd github-repository-issues-checker
$ bundle install
```

## CLIアプリケーション

### 実行方法

```console
$ bundle exec ruby cli.rb
```

## Webアプリケーション

### モデル設計

#### Repositoryモデル

| フィールド名 | データ型 |
| --- | --- |
| id | integer (PRIMARY KEY) |
| name | string (UNIQUE KEY) |
| created_at | datetime |
| updated_at | datetime |

#### Issueモデル

| フィールド名 | データ型 |
| --- | --- |
| id | integer (PRIMARY KEY) |
| repository | references |
| title | string |
| body | string |
| html_url | string (UNIQUE KEY) |
| created_at | datetime |
| updated_at | datetime |

### ルーティング設計

| リクエストメソッド | URIパターン | コントローラ#アクション | 役割 |
| --- | --- | --- | --- |
| GET | /repositories | repositories#index | 取得対象のリポジトリ一覧表示<br>リポジトリ毎に最新のIssueを5件表示 |
| POST | /repositories/create | repositories#create | リポジトリをテーブルに追加 |
| DELETE | /repositories/:id | repositories#destroy | リポジトリをテーブルから削除 |
| PATCH | issues/:repository_id | issues#update | 対象リポジトリの最新Issues取得<br>未登録のデータをテーブルに追加 |
