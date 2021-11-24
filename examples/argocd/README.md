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

以下のコマンドを入力して、もし`%`が末尾に入ってたら、騙されたと思って、消してみてください.

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
