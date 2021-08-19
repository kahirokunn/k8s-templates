std.manifestYamlDoc({
  apiVersion: 'argoproj.io/v1alpha1',
  kind: 'Application',
  metadata: {
    name: 'argocd',
    namespace: 'argo-cd',
    finalizers: [
      'resources-finalizer.argocd.argoproj.io'
    ]
  },
  spec: {
    destination: {
      namespace: 'argo-cd',
      server: 'https://kubernetes.default.svc'
    },
    source: {
      helm: {
        releaseName: 'argo-cd',
        values: importstr './argocd-add-tanka-plugin-values.yaml'
      },
      repoURL: 'https://argoproj.github.io/argo-helm',
      targetRevision: '3.12.1',
      chart: 'argo-cd'
    },
    project: 'default',
    syncPolicy: {
      automated: {
        prune: true,
        selfHeal: true
      }
    }
  }
})
