# prometheus-stack application

## deploy

```sh
$ kubectl apply -f prometheus-stack-app.yaml
```

## access on the browser.

```sh
$ kubectl port-forward svc/prometheus-stack-grafana -n prometheus-stack 18080:80
```

## default credentials.

```
ID: admin
Password: prom-operator
```
