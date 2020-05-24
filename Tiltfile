local_resource("infra", cmd="environments/local/setup.sh")

local_resource(
    "argocd", 
    cmd="echo Credentials are admin/password", 
    serve_cmd="kubectl port-forward svc/argo-argocd-server -n argocd 8081:443",
    resource_deps=["infra"]
)