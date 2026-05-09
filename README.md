# ECSのCI/CD周りについて

このドキュメントでは、ローカルPCからAmazon ECR（Elastic Container Registry）にイメージをpushし、  
Amazon ECS（Elastic Container Service）にデプロイするプロセスを説明します。

## AWS CLIの準備

まず、AWS CLI（コマンドラインインターフェース）を設定して、アクセスキーを作成します。  
今回は、GitHub Actionsではなく、ローカルからのデプロイに焦点をあててやっていきます。

- コンソールでアクセスキーを作成し、設定します。
- AWS CLIの設定は`~/.aws/`に保存されます。
    - `aws configure list` コマンドで設定を確認できます。
    - `aws sts get-caller-identity` コマンドでクラウドネイティブハンズオン用ユーザを確認できます。

## APIサーバーの準備

好きなプログラミング言語を使用して、基本的なHello Worldサーバーを作成します。

goでの参考資料: [Building Go Images](https://matsuand.github.io/docs.docker.jp.onthefly/language/golang/build-images/)

## Dockerビルド

Dockerを使用してビルドし、ローカル環境で起動および接続を確認します。  
普通のビルドとマルチステージビルドでイメージサイズに違いがあるかも確認してみましょう。

参考資料: [Building Go Images](https://matsuand.github.io/docs.docker.jp.onthefly/language/golang/build-images/)

## ECRへのPush

ECRにイメージをpushするプロセスを説明します。

- ECRリポジトリの作成: `${name}-cloudnative-handson` という名前を使用。
- AWSの公式ドキュメントに従ってビルドとpushを行います。
- Shellスクリプトを使用してビルド: gitのcommit hashやタイムスタンプでタグをつけることが推奨されます。

## ECSの準備

一度ECRにpushしたイメージが正しく動作するかを確認します。  
ECSへのデプロイには、初回にクラスターの作成やサービスの設定が必要になり、その作業も兼ねています。

- タスクの作成: ECRからURIをコピーして作成します。
- ECSクラスターの作成。
- ECSサービスの作成: Public IPの割り当てかロードバランサーの設定をして下さい。APIとしてアクセスできるようにします。
- アクセス確認: `curl ${public ip}:8080` を使用。

## ローカルからECSへのデプロイ

AWSコマンドのみでタスク定義を更新するのは手間がかかるため、[`ecs-deploy`](https://github.com/silinternational/ecs-deploy) ツールを使用します。  
[`ecs-deploy`](https://github.com/silinternational/ecs-deploy) を使用すると、以下の手順を行ってくれます。

- 現在のECSタスク定義の取得
- 現在のECSタスク定義をベースに、新しいタスク定義の作成
- 新タスク定義をAWS上に登録
- 新タスク定義を使うようにECSサービスを更新

(ecs-deployを使用しない場合は、上記の手順をaws cliと組み合わせて書いていくことになります。余裕ができた方は挑戦してみましょう。)

ECRへのpushするshellとecs-deployを組み合わせることで、デプロイするスクリプトが完成します。  
今回はlocalからpush~deployを行いましたが、github actionsなどで動かす場合もほとんど同じ流れだと思うので、是非活用してみてください。

補足:
- [`ecspresso`](https://github.com/kayac/ecspresso) という別のツールもあります。 時間があれば、違いを試してみましょう



# 発展

発展として、ローカルではなく以下を試して見ましょう。

- Github Actionsでのビルド/デプロイ
- AWSのCode Buildを用いたビルド/デプロイ

実際の現場では、複数人での開発・複数バージョン並行しての開発が行われています。  

GitHubのブランチ戦略とともにどのタイミングでデプロイするのか、またどこへ(dev/stg/prd)デプロイするのか、  
の視点を持ちながらCI/CDを考えて見てください。

