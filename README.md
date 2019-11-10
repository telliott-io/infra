# infra

## Setting Up

### Google Cloud Credentials

Before running `terraform`, you need your Google Cloud credentials in the file _gcloud_credentials.json_.

You can create this file with the `gcloud` tool:

`$ gcloud`

### Cluster Credentials

Before creating or updating your cluster, you need to configure a username and password for your Kubernetes cluster.

```
export TF_VAR_user=admin
export TF_VAR_password={randomly generated password}
```

## Deploying/Updating

`$ terraform apply`

## Setting up Kubectl for your cluster

`$ gcloud container clusters get-credentials primary --region=us-central1`