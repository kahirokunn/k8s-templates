## create k8s cluster by kind

```sh
$ kind create cluster --name test-argocd --config kind-cluster.yaml

$ kubectl config use-context kind-test-argocd
```

## deploy ArgoCD

It will take about 7 minutes to become Ready.

```sh
$ kubectl create namespace argocd

$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## access ArgoCD dashbaord by port-forward

```sh
$ kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## login

```sh
$ kubectl -n argocd get secret argocd-initial-admin-secret -o go-template="{{.data.password | base64decode }}"

$ argocd login localhost:8080
```

## Tutorial: k8s dashboard application

deploy

```sh
$ kubectl apply -f kubernetes-dashboard-app.yaml
```

## Tutorial: prometheus-stack application

deploy

```sh
$ kubectl apply -f prometheus-stack-app.yaml
```

access on the browser.

```sh
$ kubectl port-forward svc/prometheus-stack-grafana -n prometheus-stack 18080:80
```

default credentials.

```
ID: admin
Password: prom-operator
```
