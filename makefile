install-argocd:
	helm repo add argo https://argoproj.github.io/argo-helm
	helm upgrade --install argocd argo/argo-cd --version 9.2.4 --namespace infra-argocd --create-namespace --wait