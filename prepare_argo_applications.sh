#!/bin/bash

# Define the environments
environments=("production" "staging" "development")

# Define the base repository URL and chart path
repoURL="https://your-git-repo-url.git"
chartPath="base"

# Define the Argo CD project
argocdProject="default"

# Create a directory to store the application manifests
mkdir -p argocd-applications

# Generate an Argo CD Application manifest for each environment
for env in "${environments[@]}"; do
  cat <<EOF > argocd-applications/${env}-application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${env}-app
  namespace: argocd
spec:
  project: ${argocdProject}
  source:
    repoURL: ${repoURL}
    targetRevision: HEAD
    path: ${chartPath}
    helm:
      valueFiles:
        - environments/${env}/values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: ${env}-namespace
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF
done

echo "Argo CD application manifests created successfully in the 'argocd-applications' directory."

