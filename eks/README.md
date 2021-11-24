## prerequirements

tfenvを利用している方は`$ tfenv use <version>`してください.

## create

```sh
$ terraform -chdir=./terraform init
$ terraform -chdir=./terraform apply
$ make up
```

## destroy

```sh
$ make down
$ terraform -chdir=./terraform destroy
```
