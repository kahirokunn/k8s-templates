Just practice k8s.

## EKSを利用する場合

### config.json.sampleを元にconfig.jsonを作成し、<>で囲われている部分を適切な値で埋めてください

```sh
$ cp config.json.sample config.json
$ vim config.json
```

### eksディレクトリに行き、そこにあるREADME.mdを参照してaws環境をまるまる構築してください

```sh
$ cd eks
$ less README.md
```

### AWS_ACCOUNT_ID の確認方法

```sh
$ aws sts get-caller-identity | jq ".Account" --raw-output
```
