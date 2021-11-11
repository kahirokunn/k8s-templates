std.manifestYamlDoc({
  apiVersion: 'argoproj.io/v1alpha1',
  kind: 'Application',
  metadata: {
    name: 'argocd',
    namespace: 'argocd',
    finalizers: [
      'resources-finalizer.argocd.argoproj.io'
    ]
  },
  spec: {
    destination: {
      namespace: 'argocd',
      server: 'https://kubernetes.default.svc'
    },
    source: {
      helm: {
        releaseName: 'argocd',
        values: importstr './argocd-add-plugin-values.yaml'
      },
      repoURL: 'https://argoproj.github.io/argo-helm',
      targetRevision: '3.26.7',
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
