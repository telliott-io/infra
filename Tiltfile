local_resource("infra", cmd="environments/local/setup.sh")

local_resource(
    "argocd", 
    cmd="echo Credentials are admin/password", 
    serve_cmd="kubectl port-forward svc/argo-argocd-server -n argocd 8081:443",
    resource_deps=["infra"]
)

local_resource(
    "consul", 
    cmd="echo Consul", 
    serve_cmd="kubectl port-forward service/consul -n consul 8500:8500",
    resource_deps=["infra"]
)