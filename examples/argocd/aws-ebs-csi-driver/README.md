# Deploy EBS CSI

## create policy AmazonEKS_EBS_CSI_Driver_Policy

```sh
$ curl -o example-iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v1.4.0/docs/example-iam-policy.json
aws iam create-policy --policy-name AmazonEKS_EBS_CSI_Driver_Policy --policy-document file://$PWD/example-iam-policy.json
```

## create iamserviceaccount ebs-csi-controller-sa

```sh
$ CALLER_IDENTITY=$(aws sts get-caller-identity | jq ".Account" --raw-output)
$ YOUR_EKS_CLUSTER_NAME=kahirokunn-eks-0
```

## 諸々deploy

```sh
$ kubectl apply -f aws-ebs-csi-driver.yaml
```

## invalidate argocd cache and refresh

crdsを入れましたが、argocdがその前の状態を12時間cacheしちゃってるので、このissueを参考に、invalidate cacheして、aws-ebs-csi-driverをhard refreshしてください.
https://github.com/argoproj/argo-cd/issues/6351#issuecomment-897555869

## test storage

```
$ kubectl apply -f usage
```

## reference

https://aws.amazon.com/jp/blogs/containers/using-ebs-snapshots-for-persistent-storage-with-your-eks-cluster/
