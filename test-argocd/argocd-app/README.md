## Manage Argo CD Using Argo CD

If you apply the manifest that is applied with the same resources name as helm install, it will take over the argocd that has already been deployed.

### Using jsonnet

```sh
$ jsonnet -S argocd-app.jsonnet | kubectl apply -f-
```
