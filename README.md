# infra

## Setting Up

### Service Account

Before running `terraform`, you need a Service Account.

Create an account with "Owner" permissions and download the credentials as JSON into the file _gcloud_credentials.json_.

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