Just practice k8s.

## EKSを利用する場合

```sh
$ cp config.json.sample config.json
$ vim config.json
```

### AWS_ACCOUNT_ID の確認方法

```sh
$ aws sts get-caller-identity | jq ".Account" --raw-output
```
