## create k8s cluster by kind

```sh
$ kind create cluster --name test-argocd --config kind-cluster.yaml

$ kubectl config use-context kind-test-argocd
```

## deploy ArgoCD

It will take about 7 minutes to become Ready.

```sh
$ kubectl create namespace argo-cd
$ helm repo add argo-cd https://argoproj.github.io/argo-helm
$ helm install argo-cd argo-cd/argo-cd -n argo-cd
```

## access ArgoCD dashbaord by port-forward

```sh
$ kubectl port-forward svc/argo-cd-argocd-server 8080:443 -n argo-cd
```

## get login password

```sh
$ kubectl -n argo-cd get secret argocd-initial-admin-secret -o go-template="{{.data.password | base64decode }}"
```

## Tutorial: Manage Argo CD Using Argo CD

If you apply the manifest that is applied with the same resources name as helm install, it will take over the argocd that has already been deployed.

```sh
$ kubectl apply -f argocd-app.yaml
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
