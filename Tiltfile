local_resource("infra", cmd="environments/local/setup.sh")

local_resource(
    "ingress", 
    cmd="echo Ingress", 
    serve_cmd="kubectl port-forward svc/ingress-nginx -n ingress-nginx 8080:80",
    resource_deps=["infra"]
)

local_resource(
    "argocd", 
    cmd="echo Password is `kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2`", 
    serve_cmd="kubectl port-forward svc/argo-argocd-server -n argocd 8081:443",
    resource_deps=["infra"]
)

local_resource(
    "grafana", 
    cmd="echo Grafana", 
    serve_cmd="kubectl port-forward svc/grafana -n monitoring 3000:3000",
    resource_deps=["infra"]
)

local_resource(
    "jaeger", 
    cmd="echo Jaeger", 
    serve_cmd="kubectl port-forward svc/jaeger-query -n monitoring 8082:80",
    resource_deps=["infra"]
)

local_resource(
    "prometheus", 
    cmd="echo Prometheus", 
    serve_cmd="kubectl port-forward svc/prometheus-service -n monitoring 8083:8080",
    resource_deps=["infra"]
)