#  Deploy

## Serverless framework

### 前提条件

* AWS CLIでAWS環境にアクセスできること

### インストール手順


1. npmをインストールする

<a href="https://qiita.com/Esfahan/items/067fc366d6a6e7b8690d" target="_blank">npmインストール</a>

2. 以下のコマンドで確認

```
node -v
```

3. 問題なければServerless Frameworkをインストール

```
sudo npm install -g serverless@3
```

4. 完了したら以下のコマンドを叩いてみる

```
serverlss
```

もしくは以下のエイリアス

```
sls -v
```

以下コマンド実行

```
serverless plugin install -n serverless-python-requirements
```

change set install

```
npm install --save serverless-cloudformation-changesets
npm install serverless-aws-documentation --save-dev
```

開発環境

```
AWS_SDK_LOAD_CONFIG=true sls deploy --stage dev --changeset
AWS_SDK_LOAD_CONFIG=true sls deploy --stage dev
```

本番環境

```
AWS_SDK_LOAD_CONFIG=true AWS_PROFILE=shiki-user sls deploy --stage prod
```

[CFNの条件関数](https://dev.classmethod.jp/articles/cloudformation-conditions/)

[serverless.ymlの記載について](https://makky12.hatenablog.com/entry/2019/06/23/183233)