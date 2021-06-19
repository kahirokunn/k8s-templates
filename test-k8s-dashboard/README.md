## create k8s ha cluster by kind

```sh
$ kind create cluster --name test-k8s-dashboard --config kind-cluster.yaml

$ kubectl config use-context kind-test-k8s-dashboard
```

## create web dashboard

```sh
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

$ kubectl apply -f admin-user.yaml
```

## generate bearer token command for web dashboard

```sh
$ kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```

## access web dashboard

```sh
$ kubectl proxy
```

URL

```url
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:https/proxy
```
