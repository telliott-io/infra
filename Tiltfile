local_resource("infra", cmd="environments/local/setup.sh")

local_resource(
    "argocd", 
    cmd="echo Credentials are admin/password", 
    serve_cmd="kubectl port-forward svc/argo-argocd-server -n argocd 8081:443",
    resource_deps=["infra"]
)

local_resource(
    "secret_test", 
    cmd="secrets/secrettest.sh",
    deps = ["secrets/secrettest.sh"], 
    resource_deps=["infra"]
)

myos = str(local('echo $OSTYPE')).strip()
tiltMode = "up"

if "darwin" in myos:
    if "tilt down" in str(local('ps -p $PPID')).strip():
        tiltMode = "down"
else:
    if "tilt down" in str(local('cat /proc/$PPID/cmdline')).strip():
        tiltMode = "down"

if tiltMode == "down":
    local("environments/local/teardown.sh")