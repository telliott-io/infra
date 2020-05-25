#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

function finish {
    echo "Cleanup"
    kubectl delete -f mysealedsecret.json
    kubectl delete secret mysecret
    rm mysealedsecret.json
    rm mysecret.json
}
trap finish EXIT

# Create a json/yaml-encoded Secret somehow:
# (note use of `--dry-run` - this is just a local file!)
echo -n "bar" | kubectl create secret generic mysecret --dry-run --from-file=foo=/dev/stdin -o json >mysecret.json

# This is the important bit:
# (note default format is json!)
kubeseal --cert tls.crt <mysecret.json >mysealedsecret.json

# mysealedsecret.json is safe to upload to github, post to twitter,
# etc.  Eventually:
kubectl create -f mysealedsecret.json

# Sleep to make sure the operator has time to apply the new secret
sleep 1

# Profit!
SECRET_VALUE=$(kubectl get secret mysecret -o jsonpath="{.data.foo}" | base64 --decode)
if [ "$SECRET_VALUE" == "bar" ]
then
    echo "Secret was as expected, passing"
else
    echo "Secret wasn't as expected, got '$SECRET_VALUE'"
    exit -1
fi