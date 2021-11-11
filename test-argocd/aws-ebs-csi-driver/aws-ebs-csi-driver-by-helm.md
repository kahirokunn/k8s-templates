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

## snapshot.storage.k8s.io/v1がeksだと用意されていないので、define external snapshotter

```sh
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
```

## deploy snapshot controller

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
```

## define snapshot class
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v1.4.0/examples/kubernetes/snapshot/specs/classes/snapshotclass.yaml

## define storageclass
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/examples/kubernetes/dynamic-provisioning/specs/storageclass.yaml

## install aws-ebs-csi-driver to your cluster

```sh
$ helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
$ helm repo update
$ EBS_TAGS=Hello=world,Name=kahiro
$ helm install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver \
  --namespace kube-system \
  --set controller.serviceAccount.create=false \
  --set $(echo $EBS_TAGS | sed 's/,/\n/g' | sed 's/^/controller.extraVolumeTags./g' | tr '\n' ',' | sed 's/,$//g')
```

## test storage

```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/examples/kubernetes/dynamic-provisioning/specs/claim.yaml
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/examples/kubernetes/dynamic-provisioning/specs/pod.yaml
```

## reference

https://aws.amazon.com/jp/blogs/containers/using-ebs-snapshots-for-persistent-storage-with-your-eks-cluster/
