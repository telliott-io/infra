kubeauth:
	gcloud container clusters get-credentials primary --region=us-central1

destroy:
	terraform destroy --auto-approve