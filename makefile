define helmvalue
global:
  domain: argocd-workshop

configs:
  cm:
    # -- Timeout to discover if a new manifests version got published to the repository
    timeout.reconciliation: 10s

    # -- Maximum jitter added to the reconciliation timeout to spread out refreshes and reduce repo-server load
    timeout.reconciliation.jitter: 10s

    resource.customizations: |
      networking.k8s.io/Ingress:
        health.lua: |
          hs = {}
          hs.status = "Healthy"
          hs.message = "Skip health check for Ingress"
          return hs

  secret:
    argocdServerAdminPassword: $$2y$$05$$DNMReTG24Yg3W6OtW7yucehl5RvtJzig.qTXPHh/sfFB35xdxfxaO

server:
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      nginx.ingress.kubernetes.io/service-upstream: "true"
endef
export helmvalue

install-argocd:
	helm repo add argo https://argoproj.github.io/argo-helm
	@echo "$$helmvalue" | helm upgrade --install argocd argo/argo-cd --version 9.2.4 --namespace infra-argocd --create-namespace -f - --wait

convert_into_pdf:
	sudo chmod 777 -R $(PWD)
	docker run --rm -v $(PWD):/home/marp/app/ -u root marpteam/marp-cli:v4.2.3 --allow-local-files README.md -o ArgoCD-Workshop.pdf