## create k8s cluster by kind

```sh
$ kind create cluster --name test-ingress --config kind-cluster.yaml

$ kubectl config use-context kind-test-ingress
```

## deploy Ambassador to control-plane node

It's a Ingress.

```sh
$ kubectl apply -f https://github.com/datawire/ambassador-operator/releases/latest/download/ambassador-operator-crds.yaml

$ kubectl apply -n ambassador -f https://github.com/datawire/ambassador-operator/releases/latest/download/ambassador-operator-kind.yaml

$ kubectl wait --timeout=180s -n ambassador --for=condition=deployed ambassadorinstallations/ambassador
```

## deploy nginx

```sh
$ kubectl apply -f test.yaml
```

## access to nginx

```sh
$ curl http://127.0.0.1:8080
```
