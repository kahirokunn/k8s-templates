# prerequirements

tfenvを利用している方は`$ tfenv use <version>`してterraformを使えるようにしてください.

## create

### 1. create VPC and Subnets

```sh
$ terraform -chdir=./terraform init
$ terraform -chdir=./terraform apply
```

### 2. create EKS Cluster

```sh
$ make up
```

## destroy

## 1. destroy EKS Cluster

```sh
$ make down
```

## 2. destroy VPC and Subnets

```sh
$ terraform -chdir=./terraform destroy
```
