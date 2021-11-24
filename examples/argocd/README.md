## create k8s cluster by kind

```sh
$ kind create cluster --name argocd --config kind-minimum-cluster.yaml
```

## deploy ArgoCD

It will take about 7 minutes to become Ready.

```sh
$ helm repo add argo https://argoproj.github.io/argo-helm
$ helm repo update
$ helm install argocd argo/argo-cd -n argocd --create-namespace -f argocd-app/argocd-add-plugin-values.yaml
```

## access ArgoCD dashboard by port-forward

```sh
$ kubectl port-forward svc/argocd-server 8080:443 -n argocd
```

## get login password

```sh
$ kubectl -n argocd get secret argocd-initial-admin-secret -o go-template="{{.data.password | base64decode }}"
```

## login argocd cli

If you wanna use ArgoCD commands, just do it.

```sh
$ argocd login localhost:8080
Username: admin
Password: <The password you obtained above>
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
