# infra

## Setting Up

### Service Account

Before running `terraform`, you need a Service Account.

Create an account with "Owner" permissions and download the credentials as JSON into the file _gcloud_credentials.json_.

## Deploying/Updating

`$ terraform apply`

## Setting up Kubectl for your cluster

`$ gcloud container clusters get-credentials primary --region=us-central1`