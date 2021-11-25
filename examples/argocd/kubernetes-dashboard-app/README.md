# k8s dashboard application

## deploy

```sh
$ kubectl apply -f kubernetes-dashboard-app.yaml
```

## web



```sh
$ kubectl port-forward svc/kubernetes-dashboard 7777:443 -n kubernetes-dashboard
```

open in firefox.
